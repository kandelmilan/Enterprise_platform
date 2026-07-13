// Automatically:
// - Adds Authorization: Bearer <token>
// - Handles 401 Unauthorized
// - Refreshes the token via ApiEndpoints.refreshToken
// - Queues concurrent requests during refresh
// - Logs the user out if refresh fails
import 'package:dio/dio.dart';
import 'package:enterprise_platform/app/routes/app_routes.dart';
import 'package:enterprise_platform/core/services/storage/auth-storage_service.dart';
import 'package:enterprise_platform/core/utils/app_logger.dart';
import 'package:get/get.dart' hide Response;

import 'api_endpoints.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor(this._refreshDio);

  final Dio _refreshDio;

  final AuthStorageService _storage = Get.find<AuthStorageService>();

  bool _isRefreshing = false;

  final List<void Function(String token)> _pendingRequests = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    AppLogger.info("TOKEN : $token", tag: "API");
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    _logRequest(options);

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logError(err);

    if (err.requestOptions.path == ApiEndpoints.refreshToken) {
      await _logout();
      handler.next(err);
      return;
    }
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (err.requestOptions.extra['retried'] == true) {
      await _logout();
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      _pendingRequests.add((newToken) async {
        final options = err.requestOptions;

        options.headers['Authorization'] = 'Bearer $newToken';
        options.extra['retried'] = true;

        try {
          final response = await _refreshDio.fetch(options);
          handler.resolve(response);
        } catch (_) {
          handler.next(err);
        }
      });

      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No refresh token found');
      }

      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final body = response.data as Map<String, dynamic>;

      if (body['success'] != true) {
        throw Exception('Refresh token failed');
      }

      final data = body['data'] as Map<String, dynamic>;

      final accessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String?;

      await _storage.saveAccessToken(accessToken);

      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _storage.saveRefreshToken(newRefreshToken);
      }

      for (final callback in List.from(_pendingRequests)) {
        callback(accessToken);
      }

      _pendingRequests.clear();

      final options = err.requestOptions;

      options.headers['Authorization'] = 'Bearer $accessToken';
      options.extra['retried'] = true;

      final retryResponse = await _refreshDio.fetch(options);

      handler.resolve(retryResponse);
    } catch (_) {
      _pendingRequests.clear();

      await _logout();

      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _logout() async {
    await _storage.clearAuthData();

    Get.offAllNamed(AppRoutes.login);
  }

  void _logRequest(RequestOptions options) {
    AppLogger.info(
      '┌────────────────────────────────────────────────────',
      tag: 'API',
    );

    AppLogger.info('│ REQUEST  ${options.method}', tag: 'API');

    AppLogger.info('│ URL      ${options.uri}', tag: 'API');

    AppLogger.info('│ HEADERS', tag: 'API');

    AppLogger.info('│ ${options.headers}', tag: 'API');

    if (options.data != null) {
      AppLogger.info('│ BODY', tag: 'API');

      AppLogger.info('│ ${options.data}', tag: 'API');
    }

    AppLogger.info(
      '└────────────────────────────────────────────────────',
      tag: 'API',
    );
  }

  void _logResponse(Response response) {
    AppLogger.success(
      '┌─────────────────────────────────────────────────────────────',
      tag: 'API',
    );

    AppLogger.success('│ RESPONSE : ${response.statusCode}', tag: 'API');

    AppLogger.success(
      '│ URL      : ${response.requestOptions.uri}',
      tag: 'API',
    );

    AppLogger.success('│ DATA     : ${response.data}', tag: 'API');

    AppLogger.success(
      '└─────────────────────────────────────────────────────────────',
      tag: 'API',
    );
  }

  void _logError(DioException err) {
    AppLogger.error(
      '┌─────────────────────────────────────────────────────────────',
      tag: 'API',
    );

    AppLogger.error('ERROR   : ${err.type}', tag: 'API');

    AppLogger.error('URL     : ${err.requestOptions.uri}', tag: 'API');

    AppLogger.error('STATUS  : ${err.response?.statusCode}', tag: 'API');

    AppLogger.error('MESSAGE : ${err.message}', tag: 'API');

    if (err.response != null) {
      AppLogger.error('DATA    : ${err.response?.data}', tag: 'API');
    }

    AppLogger.error(
      '└─────────────────────────────────────────────────────────────',
      tag: 'API',
    );
  }
}
