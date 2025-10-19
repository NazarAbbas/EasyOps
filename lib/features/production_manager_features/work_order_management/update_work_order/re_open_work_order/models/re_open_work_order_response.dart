class ReopenWorkOrderResponse {
  final bool success;
  final String? message;

  const ReopenWorkOrderResponse({required this.success, this.message});

  /// Useful when your Retrofit call returns no body (void).
  factory ReopenWorkOrderResponse.fromStatus(int? statusCode,
      {String? message}) {
    final sc = statusCode ?? 0;
    return ReopenWorkOrderResponse(
        success: sc >= 200 && sc < 300, message: message);
  }

  /// Best-effort JSON parser (optional).
  factory ReopenWorkOrderResponse.fromJson(Map<String, dynamic>? json) {
    final j = json ?? const {};
    final status = j['status']?.toString().toUpperCase();
    final ok = j['success'] == true ||
        j['record_status'] == 1 ||
        status == 'OK' ||
        status == 'SUCCESS';
    return ReopenWorkOrderResponse(
        success: ok, message: j['message']?.toString());
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        if (message != null) 'message': message,
      };
}
