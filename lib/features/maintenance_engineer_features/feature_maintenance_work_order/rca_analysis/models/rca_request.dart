import 'dart:convert';

class RcaRequest {
  final String workOrderId;
  final String problem;
  final String why1;
  final String why2;
  final String why3;
  final String why4;
  final String why5;
  final String rca; // Root Cause Analysis
  final String cap; // Corrective Action Plan

  const RcaRequest({
    required this.workOrderId,
    required this.problem,
    required this.why1,
    required this.why2,
    required this.why3,
    required this.why4,
    required this.why5,
    required this.rca,
    required this.cap,
  });

  RcaRequest copyWith({
    String? workOrderId,
    String? problem,
    String? why1,
    String? why2,
    String? why3,
    String? why4,
    String? why5,
    String? rca,
    String? cap,
  }) {
    return RcaRequest(
      workOrderId: workOrderId ?? this.workOrderId,
      problem: problem ?? this.problem,
      why1: why1 ?? this.why1,
      why2: why2 ?? this.why2,
      why3: why3 ?? this.why3,
      why4: why4 ?? this.why4,
      why5: why5 ?? this.why5,
      rca: rca ?? this.rca,
      cap: cap ?? this.cap,
    );
  }

  // ---------- JSON ----------

  factory RcaRequest.fromJson(Map<String, dynamic> json) {
    return RcaRequest(
      workOrderId: (json['workOrderId'] ?? '').toString(),
      problem: (json['problem'] ?? '').toString(),
      why1: (json['why1'] ?? '').toString(),
      why2: (json['why2'] ?? '').toString(),
      why3: (json['why3'] ?? '').toString(),
      why4: (json['why4'] ?? '').toString(),
      why5: (json['why5'] ?? '').toString(),
      rca: (json['rca'] ?? '').toString(),
      cap: (json['cap'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'workOrderId': workOrderId,
        'problem': problem,
        'why1': why1,
        'why2': why2,
        'why3': why3,
        'why4': why4,
        'why5': why5,
        'rca': rca,
        'cap': cap,
      };

  // ---------- Helpers ----------

  static RcaRequest fromJsonString(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return RcaRequest.fromJson(map);
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() =>
      'WorkOrderRca(workOrderId: $workOrderId, problem: $problem, rca: $rca, cap: $cap)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RcaRequest &&
          other.workOrderId == workOrderId &&
          other.problem == problem &&
          other.why1 == why1 &&
          other.why2 == why2 &&
          other.why3 == why3 &&
          other.why4 == why4 &&
          other.why5 == why5 &&
          other.rca == rca &&
          other.cap == cap);

  @override
  int get hashCode => Object.hash(
        workOrderId,
        problem,
        why1,
        why2,
        why3,
        why4,
        why5,
        rca,
        cap,
      );
}
