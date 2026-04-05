class ApiResponse {
  final bool success;
  final dynamic data;
  final int statusCode;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    required this.statusCode,
    this.message,
  });
}
