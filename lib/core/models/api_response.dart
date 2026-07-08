class ApiResponse<T> {
  final bool success;
  final T data;
  final String? message;
  final String correlationId;

  const ApiResponse({
    required this.success,
    required this.data,
    this.message,
    required this.correlationId,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      data: fromJsonT(json['data']),
      message: json['message'] as String?,
      correlationId: json['correlationId'] as String,
    );
  }
}
