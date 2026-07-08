// Automatically:
// - Adds Authorization: Bearer <token>
// - Handles 401 Unauthorized
// - Refreshes the token via ApiEndpoints.refreshToken
// - Queues concurrent requests during refresh
// - Logs the user out if refresh fails
import 'package:dio/dio.dart';

import '../api/api_endpoints.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService.instance;

  final Dio _refreshDio;

  AuthInterceptor(this._refreshDio);

  bool _isRefreshing = false;
  final List<void Function(String token)> _pendingRequests = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.extra['retried'] == true) {
      await _logout();
      return handler.next(err);
    }

    if (_isRefreshing) {
      _pendingRequests.add((newToken) async {
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        opts.extra['retried'] = true;
        try {
          final response = await _refreshDio.fetch(opts);
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
        throw Exception('No refresh token available');
      }

      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final body = response.data;
      if (body is! Map<String, dynamic> || body['success'] != true) {
        throw Exception(
          'Refresh failed: ${body is Map ? body['message'] : body}',
        );
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Unexpected refresh response format');
      }

      final newAccessToken = data['accessToken'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw Exception('No accessToken in refresh response');
      }

      await _storage.saveAccessToken(newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _storage.saveRefreshToken(newRefreshToken);
      }

      for (final callback in _pendingRequests) {
        callback(newAccessToken);
      }
      _pendingRequests.clear();

      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      opts.extra['retried'] = true;

      final retriedResponse = await _refreshDio.fetch(opts);
      handler.resolve(retriedResponse);
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
    // e.g. Get.offAllNamed('/login');
  }
}
