/// Cancel / Reassign Work Order request payload.
class CancelWorkOrderRequest {
  /// e.g. "Reassign", "Cancel", "Hold" — per your API contract.
  final String status;

  /// Free-text remark entered by the user.
  final String remark;

  /// Reason/comment label (or send id/code if your API expects that).
  final String comment;

  /// Optional ETA text (e.g. "2h", "Tomorrow 3 PM").
  final String? estimatedTimeToFix;

  const CancelWorkOrderRequest({
    required this.status,
    required this.remark,
    required this.comment,
    this.estimatedTimeToFix,
  });

  /// Convenience factory for the common "Reassign" flow.
  factory CancelWorkOrderRequest.reassign({
    required String remark,
    required String comment,
    String? estimatedTimeToFix,
  }) {
    final cleanedEta = estimatedTimeToFix?.trim();
    return CancelWorkOrderRequest(
      status: 'Reassign',
      remark: remark.trim(),
      comment: comment.trim(),
      estimatedTimeToFix:
          (cleanedEta == null || cleanedEta.isEmpty) ? null : cleanedEta,
    );
  }

  /// JSON → Model
  factory CancelWorkOrderRequest.fromJson(Map<String, dynamic> json) {
    String? eta;
    final rawEta = json['estimatedTimeToFix'];
    if (rawEta != null) {
      final s = rawEta.toString().trim();
      eta = s.isEmpty ? null : s;
    }

    return CancelWorkOrderRequest(
      status: (json['status'] ?? '').toString(),
      remark: (json['remark'] ?? '').toString(),
      comment: (json['comment'] ?? '').toString(),
      estimatedTimeToFix: eta,
    );
  }

  /// Model → JSON (adjust keys if your API uses snake_case)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'status': status,
      'remark': remark,
      'comment': comment,
    };
    final eta = estimatedTimeToFix?.trim();
    if (eta != null && eta.isNotEmpty) {
      map['estimatedTimeToFix'] = eta;
    }
    return map;
  }
}
