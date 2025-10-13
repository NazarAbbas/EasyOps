class CancelWorkOrderResponse {
  final bool success;
  final String? message;

  const CancelWorkOrderResponse({required this.success, this.message});

  /// Useful when your Retrofit call returns no body (void).
  factory CancelWorkOrderResponse.fromStatus(int? statusCode,
      {String? message}) {
    final sc = statusCode ?? 0;
    return CancelWorkOrderResponse(
        success: sc >= 200 && sc < 300, message: message);
  }

  /// Best-effort JSON parser (optional).
  factory CancelWorkOrderResponse.fromJson(Map<String, dynamic>? json) {
    final j = json ?? const {};
    final status = j['status']?.toString().toUpperCase();
    final ok = j['success'] == true ||
        j['record_status'] == 1 ||
        status == 'OK' ||
        status == 'SUCCESS';
    return CancelWorkOrderResponse(
        success: ok, message: j['message']?.toString());
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        if (message != null) 'message': message,
      };
}
