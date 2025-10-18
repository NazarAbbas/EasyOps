// lib/api/models/cancel_work_order_request.dart
import 'dart:convert';

class CloseWorkOrderRequest {
  /// Typical payload:
  /// {
  ///   "status": "Close",
  ///   "remark": "some note",
  ///   "comment": "selected reason name or id",
  ///   "files": ["/path/to/signature.png"] // optional
  /// }
  final String status; // e.g., "Close" (default previously was "Cancel")
  final String remark; // required
  final String? comment; // optional
  final List<String>? files; // optional: file paths to send in JSON

  const CloseWorkOrderRequest({
    this.status = 'Cancel',
    required this.remark,
    this.comment,
    this.files,
  });

  Map<String, dynamic> toJson() => {
        'status': status,
        'remark': remark,
        if (comment != null) 'comment': comment,
        if (files != null && files!.isNotEmpty) 'files': files,
      };

  /// Convenience: JSON encode the payload if you need a raw string.
  String toJsonString() => jsonEncode(toJson());

  /// Optional helpers if you ever need them:

  CloseWorkOrderRequest copyWith({
    String? status,
    String? remark,
    String? comment,
    List<String>? files,
  }) {
    return CloseWorkOrderRequest(
      status: status ?? this.status,
      remark: remark ?? this.remark,
      comment: comment ?? this.comment,
      files: files ?? this.files,
    );
  }

  factory CloseWorkOrderRequest.fromJson(Map<String, dynamic> json) {
    return CloseWorkOrderRequest(
      status: json['status'] as String? ?? 'Cancel',
      remark: json['remark'] as String? ?? '',
      comment: json['comment'] as String?,
      files: (json['files'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
