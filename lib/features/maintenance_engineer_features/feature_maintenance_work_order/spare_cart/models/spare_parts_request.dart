// models/spare_request_line.dart

class SparePartsRequest {
  final String assetSpareId;
  final int requestedQty;
  final String status; // e.g. "REQUESTED"

  const SparePartsRequest({
    required this.assetSpareId,
    required this.requestedQty,
    required this.status,
  });

  SparePartsRequest copyWith({
    String? assetSpareId,
    int? requestedQty,
    String? status,
  }) {
    return SparePartsRequest(
      assetSpareId: assetSpareId ?? this.assetSpareId,
      requestedQty: requestedQty ?? this.requestedQty,
      status: status ?? this.status,
    );
  }

  // ---------- JSON ----------

  factory SparePartsRequest.fromJson(Map<String, dynamic> json) {
    return SparePartsRequest(
      assetSpareId: (json['assetSpareId'] ?? '').toString(),
      requestedQty: (json['requestedQty'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetSpareId': assetSpareId,
      'requestedQty': requestedQty,
      'status': status,
    };
  }

  // ---------- List helpers ----------

  static List<SparePartsRequest> listFromJson(dynamic json) {
    if (json is List) {
      return json
          .map((e) => SparePartsRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const <SparePartsRequest>[];
  }

  static List<Map<String, dynamic>> listToJson(List<SparePartsRequest> items) {
    return items.map((e) => e.toJson()).toList();
  }

  @override
  String toString() =>
      'SpareRequestLine(assetSpareId: $assetSpareId, requestedQty: $requestedQty, status: $status)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SparePartsRequest &&
            other.assetSpareId == assetSpareId &&
            other.requestedQty == requestedQty &&
            other.status == status);
  }

  @override
  int get hashCode => Object.hash(assetSpareId, requestedQty, status);
}
