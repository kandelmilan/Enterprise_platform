import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:enterprise_platform/core/errors/failure.dart';
import 'package:enterprise_platform/core/utils/app_logger.dart';
import 'api_response.dart';

/// Handles API responses and converts them into Either<Failure, ApiResponse<T>>.
class ApiResponseHandler {
  ApiResponseHandler._();

  /// Executes an API request and converts the response.
  static Future<Either<Failure, ApiResponse<T>>> handleResponse<T>(
    Future<Response<dynamic>> Function() apiCall,
    T Function(dynamic)? fromJsonT,
  ) async {
    try {
      final response = await apiCall();

      if (response.data == null) {
        return Left(
          ServerFailure('No data received from server.', response.statusCode),
        );
      }

      final apiResponse = ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );

      if (apiResponse.success) {
        return Right(apiResponse);
      }

      return Left(ServerFailure(apiResponse.message, apiResponse.statusCode));
    } on DioException catch (e, stackTrace) {
        AppLogger.error(e.toString(), stackTrace: stackTrace);

      return Left(_handleDioException(e));
    } catch (e, stackTrace) {
      AppLogger.error(e.toString(), stackTrace: stackTrace);

      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Converts DioException into Failure.
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          'Connection timeout. Please try again.',
          error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          'No internet connection.',
          error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return UnknownFailure('Request cancelled.', error.response?.statusCode);

      default:
        return UnknownFailure(
          error.message ?? 'Something went wrong.',
          error.response?.statusCode,
        );
    }
  }

  /// Converts HTTP status codes into Failures.
  static Failure _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return const ServerFailure('Unknown server error.');
    }

    final statusCode = response.statusCode ?? 0;

    String message = 'Something went wrong.';

    if (response.data is Map<String, dynamic>) {
      message = (response.data['message'] as String?) ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message, statusCode);

      case 401:
        return AuthenticationFailure(
          message.isEmpty ? 'Unauthorized.' : message,
          statusCode,
        );

      case 403:
        return AuthenticationFailure(
          message.isEmpty ? 'Forbidden.' : message,
          statusCode,
        );

      case 404:
        return ServerFailure(
          message.isEmpty ? 'Resource not found.' : message,
          statusCode,
        );

      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message.isEmpty ? 'Server error.' : message,
          statusCode,
        );

      default:
        return ServerFailure(message, statusCode);
    }
  }
}
