import 'dart:convert';

/// One line in the spare-issue/return list.
class AddSparePartsResponse {
  final String id;
  final String assetSpareId;
  final int requestedQty;
  final String status;
  final int? recordStatus;

  final DateTime? requestedAt;
  final DateTime? issuedAt;
  final DateTime? consumedAt;
  final DateTime? returnedAt;

  final bool? isRepairable;
  final DateTime? updatedAt;

  final String workOrderId;

  const AddSparePartsResponse({
    required this.id,
    required this.assetSpareId,
    required this.requestedQty,
    required this.status,
    this.recordStatus,
    this.requestedAt,
    this.issuedAt,
    this.consumedAt,
    this.returnedAt,
    this.isRepairable,
    this.updatedAt,
    required this.workOrderId,
  });

  // ---------- Safe converters ----------
  static String _asString(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    if (v is String) return v;
    return v.toString();
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static bool? _asBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    return null;
  }

  static DateTime? _asDateTime(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is num) {
      // treat as epoch seconds/millis (heuristic)
      final n = v.toInt();
      final ms = n > 20000000000 ? n : n * 1000;
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    }
    final s = _asString(v).trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  factory AddSparePartsResponse.fromJson(Map<String, dynamic> json) {
    return AddSparePartsResponse(
      id: _asString(json['id']),
      assetSpareId: _asString(json['assetSpareId']),
      requestedQty: _asInt(json['requestedQty']) ?? 0,
      status: _asString(json['status']),
      recordStatus: _asInt(json['recordStatus']),
      requestedAt: _asDateTime(json['requestedAt']),
      issuedAt: _asDateTime(json['issuedAt']),
      consumedAt: _asDateTime(json['consumedAt']),
      returnedAt: _asDateTime(json['returnedAt']),
      isRepairable: _asBool(json['isRepairable']),
      updatedAt: _asDateTime(json['updatedAt']),
      workOrderId: _asString(json['workOrderId']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'assetSpareId': assetSpareId,
        'requestedQty': requestedQty,
        'status': status,
        'recordStatus': recordStatus,
        'requestedAt': requestedAt?.toIso8601String(),
        'issuedAt': issuedAt?.toIso8601String(),
        'consumedAt': consumedAt?.toIso8601String(),
        'returnedAt': returnedAt?.toIso8601String(),
        'isRepairable': isRepairable,
        'updatedAt': updatedAt?.toIso8601String(),
        'workOrderId': workOrderId,
      };

  AddSparePartsResponse copyWith({
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
    return AddSparePartsResponse(
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

  @override
  String toString() =>
      'WorkOrderSpareLine(id: $id, assetSpareId: $assetSpareId, requestedQty: $requestedQty, status: $status)';
}

/// Parse a JSON string (array) into a list of models
List<AddSparePartsResponse> workOrderSpareLineListFromJson(String jsonStr) {
  final data = json.decode(jsonStr);
  if (data is List) {
    return data
        .whereType<Map<String, dynamic>>()
        .map(AddSparePartsResponse.fromJson)
        .toList();
  }
  return const <AddSparePartsResponse>[];
}

/// Serialize a list back to a JSON string
String workOrderSpareLineListToJson(List<AddSparePartsResponse> list) {
  return json.encode(list.map((e) => e.toJson()).toList());
}
