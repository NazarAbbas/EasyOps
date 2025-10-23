/// Cancel / Reassign Work Order request payload.
class CancelWorkOrderRequest {
  /// e.g. "Reassign", "Cancel", "Hold" — per your API contract.
  final String status;

  /// Free-text remark entered by the user.
  final String remark;

  /// Reason/comment label (or send id/code if your API expects that).
  final String comment;

  const CancelWorkOrderRequest({
    required this.status,
    required this.remark,
    required this.comment,
  });

  /// Convenience factory for the common "Reassign" flow.
  factory CancelWorkOrderRequest.reassign({
    required String remark,
    required String comment,
  }) {
    return CancelWorkOrderRequest(
      status: 'Reassign',
      remark: remark.trim(),
      comment: comment.trim(),
    );
  }

  /// JSON → Model
  factory CancelWorkOrderRequest.fromJson(Map<String, dynamic> json) {
    return CancelWorkOrderRequest(
      status: (json['status'] ?? '').toString(),
      remark: (json['remark'] ?? '').toString(),
      comment: (json['comment'] ?? '').toString(),
    );
  }

  /// Model → JSON (adjust keys if your API uses snake_case)
  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status,
        'remark': remark,
        'comment': comment,
      };

  CancelWorkOrderRequest copyWith({
    String? status,
    String? remark,
    String? comment,
  }) {
    return CancelWorkOrderRequest(
      status: status ?? this.status,
      remark: remark ?? this.remark,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() =>
      'CancelWorkOrderRequest(status: $status, remark: $remark, comment: $comment)';

  @override
  bool operator ==(Object other) {
    return other is CancelWorkOrderRequest &&
        other.status == status &&
        other.remark == remark &&
        other.comment == comment;
  }

  @override
  int get hashCode => Object.hash(status, remark, comment);
}
