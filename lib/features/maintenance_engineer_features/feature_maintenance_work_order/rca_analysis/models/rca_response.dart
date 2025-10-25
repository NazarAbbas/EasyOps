import 'dart:convert';

class RcaResponse {
  final String id;
  final String workOrderId;
  final String problem;
  final String why1;
  final String why2;
  final String why3;
  final String why4;
  final String why5;
  final String rca; // Root Cause Analysis
  final String cap; // Corrective Action Plan
  final int recordStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RcaResponse({
    required this.id,
    required this.workOrderId,
    required this.problem,
    required this.why1,
    required this.why2,
    required this.why3,
    required this.why4,
    required this.why5,
    required this.rca,
    required this.cap,
    required this.recordStatus,
    this.createdAt,
    this.updatedAt,
  });

  RcaResponse copyWith({
    String? id,
    String? workOrderId,
    String? problem,
    String? why1,
    String? why2,
    String? why3,
    String? why4,
    String? why5,
    String? rca,
    String? cap,
    int? recordStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RcaResponse(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      problem: problem ?? this.problem,
      why1: why1 ?? this.why1,
      why2: why2 ?? this.why2,
      why3: why3 ?? this.why3,
      why4: why4 ?? this.why4,
      why5: why5 ?? this.why5,
      rca: rca ?? this.rca,
      cap: cap ?? this.cap,
      recordStatus: recordStatus ?? this.recordStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ---------- JSON ----------

  factory RcaResponse.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDT(dynamic v) {
      final s = (v ?? '').toString();
      if (s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    return RcaResponse(
      id: (json['id'] ?? '').toString(),
      workOrderId: (json['workOrderId'] ?? '').toString(),
      problem: (json['problem'] ?? '').toString(),
      why1: (json['why1'] ?? '').toString(),
      why2: (json['why2'] ?? '').toString(),
      why3: (json['why3'] ?? '').toString(),
      why4: (json['why4'] ?? '').toString(),
      why5: (json['why5'] ?? '').toString(),
      rca: (json['rca'] ?? '').toString(),
      cap: (json['cap'] ?? '').toString(),
      recordStatus: (json['recordStatus'] as num?)?.toInt() ?? 0,
      createdAt: _parseDT(json['createdAt']),
      updatedAt: _parseDT(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workOrderId': workOrderId,
        'problem': problem,
        'why1': why1,
        'why2': why2,
        'why3': why3,
        'why4': why4,
        'why5': why5,
        'rca': rca,
        'cap': cap,
        'recordStatus': recordStatus,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  // ---------- String helpers (optional) ----------

  static RcaResponse fromJsonString(String jsonStr) =>
      RcaResponse.fromJson(json.decode(jsonStr) as Map<String, dynamic>);

  String toJsonString() => json.encode(toJson());

  @override
  String toString() =>
      'WorkOrderRcaEntry(id: $id, workOrderId: $workOrderId, recordStatus: $recordStatus)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RcaResponse &&
          other.id == id &&
          other.workOrderId == workOrderId &&
          other.problem == problem &&
          other.why1 == why1 &&
          other.why2 == why2 &&
          other.why3 == why3 &&
          other.why4 == why4 &&
          other.why5 == why5 &&
          other.rca == rca &&
          other.cap == cap &&
          other.recordStatus == recordStatus &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt);

  @override
  int get hashCode => Object.hash(
        id,
        workOrderId,
        problem,
        why1,
        why2,
        why3,
        why4,
        why5,
        rca,
        cap,
        recordStatus,
        createdAt,
        updatedAt,
      );
}
