import 'dart:convert';
import 'dart:ffi';

class PendingActivityRequest {
  final String workOrderId;
  final String title;
  final String typeId;
  final int sequence;

  /// Format: YYYY-MM-DD
  final String requestedTargetDate;
  final String remark;
  final String status; // e.g. "Pending"
  final String assignedToId; // e.g. "USR-123456"

  const PendingActivityRequest({
    required this.workOrderId,
    required this.title,
    required this.typeId,
    required this.requestedTargetDate,
    required this.remark,
    required this.status,
    required this.assignedToId,
    required this.sequence,
  });

  factory PendingActivityRequest.fromJson(Map<String, dynamic> json) {
    return PendingActivityRequest(
      workOrderId: json['workOrderId'] as String,
      title: json['title'] as String,
      typeId: json['typeId'] as String,
      requestedTargetDate: json['requestedTargetDate'] as String,
      remark: json['remark'] as String,
      status: json['status'] as String,
      sequence: json['sequence'] as int,
      assignedToId: json['assignedToId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'workOrderId': workOrderId,
        'title': title,
        'typeId': typeId,
        'requestedTargetDate': requestedTargetDate,
        'remark': remark,
        'status': status,
        'assignedToId': assignedToId,
        'sequence': sequence,
      };

  /// Helpers for bulk (array) payloads
  static List<PendingActivityRequest> listFromJsonString(String jsonStr) {
    final raw = jsonDecode(jsonStr) as List<dynamic>;
    return raw
        .map((e) => PendingActivityRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<PendingActivityRequest> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  /// Date helper to ensure "YYYY-MM-DD"
  static String yyyymmdd(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
