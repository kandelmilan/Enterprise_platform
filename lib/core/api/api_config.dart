// It will: Load BASE_URL from .env , Configure Dio , Set timeouts , Add interceptors , Handle common request options
// Every repository will use this client.
import 'package:dio/dio.dart';
import 'package:enterprise_platform/core/api/auth_interceptor.dart';
import 'package:enterprise_platform/core/constants/app_constants.dart';

class ApiConfig {
  final Dio dio;

  ApiConfig() : dio = Dio(_baseOptions()) {
    // Separate Dio, same config, NO interceptors — used only by
    // AuthInterceptor for refresh + retry, to avoid infinite refresh loops.
    final refreshDio = Dio(_baseOptions());

    dio.interceptors.add(AuthInterceptor(refreshDio));
  }

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: 'https://hydroapi.gyanbato.com/api/v1',
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}
