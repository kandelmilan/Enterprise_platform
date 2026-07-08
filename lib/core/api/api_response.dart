/// Generic API response wrapper.
///
/// Example:
/// {
///   "success": true,
///   "message": "Login successful",
///   "data": { ... },
///   "statusCode": 200
/// }
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
  });

  /// Whether the request was successful.
  final bool success;

  /// Response message from the server.
  final String message;

  /// Response payload.
  final T? data;

  /// HTTP status code.
  final int statusCode;

  /// Create ApiResponse from JSON.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      statusCode: json['statusCode'] as int? ?? 200,
    );
  }

  /// Convert ApiResponse to JSON.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode, data: $data)';
  }
}
