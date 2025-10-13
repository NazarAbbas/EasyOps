/// Dummy response specific to cancel work order.
/// Works even if server returns no body—just construct with status code.
class CloseWorkOrderResponse {
  final bool success;
  final String? message;
  final String? workOrderId; // optional, if server sends it

  const CloseWorkOrderResponse({
    required this.success,
    this.message,
    this.workOrderId,
  });

  factory CloseWorkOrderResponse.fromStatus(int? statusCode,
      {String? message}) {
    final sc = statusCode ?? 0;
    return CloseWorkOrderResponse(
        success: sc >= 200 && sc < 300, message: message);
  }

  factory CloseWorkOrderResponse.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status']?.toString().toUpperCase();
    final ok = json['success'] == true ||
        json['record_status'] == 1 ||
        statusStr == 'OK' ||
        statusStr == 'SUCCESS';
    return CloseWorkOrderResponse(
      success: ok,
      message: json['message']?.toString(),
      workOrderId: (json['workOrderId'] ?? json['work_order_id'] ?? json['id'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        if (message != null) 'message': message,
        if (workOrderId != null) 'workOrderId': workOrderId,
      };
}
