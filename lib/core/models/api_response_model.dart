class ApiResponseModel<T> {
  final int code;
  final String message;
  final T? data;
  final bool success;

  ApiResponseModel({
    required this.code,
    required this.message,
    this.data,
    required this.success,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    final response = json['response'] ?? {};
    final code = response['code'] ?? 0;
    final message = response['message'] ?? '';
    final success = code >= 200 && code < 300;

    T? data;
    if (success && json['data'] != null && fromJsonT != null) {
      data = fromJsonT(json['data']);
    }

    return ApiResponseModel<T>(
      code: code,
      message: message,
      data: data,
      success: success,
    );
  }
}
