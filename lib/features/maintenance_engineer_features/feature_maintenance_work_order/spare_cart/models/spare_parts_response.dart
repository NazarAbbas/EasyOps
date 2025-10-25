// models/work_order_spare_part.dart

class SparePartsResponse {
  final String id;
  final String assetSpareId;
  final int requestedQty;
  final String status; // e.g. "REQUESTED"
  final int recordStatus; // e.g. 1/2/0
  final DateTime? requestedAt;
  final DateTime? issuedAt;
  final DateTime? consumedAt;
  final DateTime? returnedAt;
  final bool? isRepairable;
  final DateTime? updatedAt;
  final String workOrderId;

  const SparePartsResponse({
    required this.id,
    required this.assetSpareId,
    required this.requestedQty,
    required this.status,
    required this.recordStatus,
    required this.requestedAt,
    required this.issuedAt,
    required this.consumedAt,
    required this.returnedAt,
    required this.isRepairable,
    required this.updatedAt,
    required this.workOrderId,
  });

  SparePartsResponse copyWith({
    String? id,
    String? assetSpareId,
    int? requestedQty,
    String? status,
    int? recordStatus,
    DateTime? requestedAt,
    DateTime? issuedAt,
    DateTime? consumedAt,
    DateTime? returnedAt,
    bool? isRepairable,
    DateTime? updatedAt,
    String? workOrderId,
  }) {
    return SparePartsResponse(
      id: id ?? this.id,
      assetSpareId: assetSpareId ?? this.assetSpareId,
      requestedQty: requestedQty ?? this.requestedQty,
      status: status ?? this.status,
      recordStatus: recordStatus ?? this.recordStatus,
      requestedAt: requestedAt ?? this.requestedAt,
      issuedAt: issuedAt ?? this.issuedAt,
      consumedAt: consumedAt ?? this.consumedAt,
      returnedAt: returnedAt ?? this.returnedAt,
      isRepairable: isRepairable ?? this.isRepairable,
      updatedAt: updatedAt ?? this.updatedAt,
      workOrderId: workOrderId ?? this.workOrderId,
    );
  }

  // -------- JSON --------

  factory SparePartsResponse.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDt(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return DateTime.parse(s); // handles offsets like +05:30
    }

    return SparePartsResponse(
      id: (json['id'] ?? '').toString(),
      assetSpareId: (json['assetSpareId'] ?? '').toString(),
      requestedQty: (json['requestedQty'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
      recordStatus: (json['recordStatus'] as num?)?.toInt() ?? 0,
      requestedAt: _parseDt(json['requestedAt']),
      issuedAt: _parseDt(json['issuedAt']),
      consumedAt: _parseDt(json['consumedAt']),
      returnedAt: _parseDt(json['returnedAt']),
      isRepairable: json['isRepairable'] as bool?,
      updatedAt: _parseDt(json['updatedAt']),
      workOrderId: (json['workOrderId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    String? _fmtDt(DateTime? d) => d?.toIso8601String();
    return {
      'id': id,
      'assetSpareId': assetSpareId,
      'requestedQty': requestedQty,
      'status': status,
      'recordStatus': recordStatus,
      'requestedAt': _fmtDt(requestedAt),
      'issuedAt': _fmtDt(issuedAt),
      'consumedAt': _fmtDt(consumedAt),
      'returnedAt': _fmtDt(returnedAt),
      'isRepairable': isRepairable,
      'updatedAt': _fmtDt(updatedAt),
      'workOrderId': workOrderId,
    };
  }

  // -------- List helpers --------

  static List<SparePartsResponse> listFromJson(dynamic json) {
    if (json is List) {
      return json
          .map((e) => SparePartsResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const <SparePartsResponse>[];
  }

  static List<Map<String, dynamic>> listToJson(
          List<SparePartsResponse> items) =>
      items.map((e) => e.toJson()).toList();

  // -------- Equality / debug --------

  @override
  String toString() =>
      'WorkOrderSparePart(id: $id, assetSpareId: $assetSpareId, requestedQty: $requestedQty, status: $status, recordStatus: $recordStatus, requestedAt: $requestedAt, issuedAt: $issuedAt, consumedAt: $consumedAt, returnedAt: $returnedAt, isRepairable: $isRepairable, updatedAt: $updatedAt, workOrderId: $workOrderId)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SparePartsResponse &&
            other.id == id &&
            other.assetSpareId == assetSpareId &&
            other.requestedQty == requestedQty &&
            other.status == status &&
            other.recordStatus == recordStatus &&
            other.requestedAt == requestedAt &&
            other.issuedAt == issuedAt &&
            other.consumedAt == consumedAt &&
            other.returnedAt == returnedAt &&
            other.isRepairable == isRepairable &&
            other.updatedAt == updatedAt &&
            other.workOrderId == workOrderId);
  }

  @override
  int get hashCode => Object.hash(
        id,
        assetSpareId,
        requestedQty,
        status,
        recordStatus,
        requestedAt,
        issuedAt,
        consumedAt,
        returnedAt,
        isRepairable,
        updatedAt,
        workOrderId,
      );
}
