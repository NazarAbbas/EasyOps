// lib/api/models/work_order_update_request.dart
class CancelWorkOrderRequest {
  final String status;
  final String remark;
  final String comment;

  CancelWorkOrderRequest({
    required this.status,
    required this.remark,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'status': status,
        'remark': remark,
        'comment': comment,
      };
}
