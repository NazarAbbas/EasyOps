import 'dart:convert';

class PendingActivityResponse {
  final String id;
  final String title;
  final String typeId;

  /// "YYYY-MM-DD"
  final String requestedTargetDate;
  final String remark;
  final int sequence;
  final String status; // e.g. "Pending"
  final int recordStatus; // e.g. 1
  final DateTime updatedAt; // ISO8601
  final String workOrderId;
  final String assignedToId;

  const PendingActivityResponse({
    required this.id,
    required this.title,
    required this.typeId,
    required this.requestedTargetDate,
    required this.remark,
    required this.sequence,
    required this.status,
    required this.recordStatus,
    required this.updatedAt,
    required this.workOrderId,
    required this.assignedToId,
  });

  factory PendingActivityResponse.fromJson(Map<String, dynamic> json) {
    return PendingActivityResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      typeId: json['typeId'] as String,
      requestedTargetDate: json['requestedTargetDate'] as String,
      remark: json['remark'] as String,
      sequence: (json['sequence'] as num).toInt(),
      status: json['status'] as String,
      recordStatus: (json['recordStatus'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      workOrderId: json['workOrderId'] as String,
      assignedToId: json['assignedToId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'typeId': typeId,
        'requestedTargetDate': requestedTargetDate,
        'remark': remark,
        'sequence': sequence,
        'status': status,
        'recordStatus': recordStatus,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        'workOrderId': workOrderId,
        'assignedToId': assignedToId,
      };

  PendingActivityResponse copyWith({
    String? id,
    String? title,
    String? typeId,
    String? requestedTargetDate,
    String? remark,
    int? sequence,
    String? status,
    int? recordStatus,
    DateTime? updatedAt,
    String? workOrderId,
    String? assignedToId,
  }) {
    return PendingActivityResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      typeId: typeId ?? this.typeId,
      requestedTargetDate: requestedTargetDate ?? this.requestedTargetDate,
      remark: remark ?? this.remark,
      sequence: sequence ?? this.sequence,
      status: status ?? this.status,
      recordStatus: recordStatus ?? this.recordStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      workOrderId: workOrderId ?? this.workOrderId,
      assignedToId: assignedToId ?? this.assignedToId,
    );
  }

  // ---------- List helpers ----------
  static List<PendingActivityResponse> listFromJsonString(String jsonStr) {
    final raw = jsonDecode(jsonStr) as List<dynamic>;
    return raw
        .map((e) => PendingActivityResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<PendingActivityResponse> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }
}
