import 'dart:convert';

class SparePartsResponse {
  final String id;
  final String assetId;
  final String? partCat1Id;
  final String? partCat2Id;
  final String partName;
  final String partNumber;
  final double? cost;
  final int? quantity;

  /// 1 = active, 2 = inactive, 0 = deleted (adjust per your convention)
  final int? recordStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SparePartsResponse({
    required this.id,
    required this.assetId,
    this.partCat1Id,
    this.partCat2Id,
    required this.partName,
    required this.partNumber,
    this.cost,
    this.quantity,
    this.recordStatus,
    this.createdAt,
    this.updatedAt,
  });

  /// Convenience for UI: treat `quantity` as stock.
  int get stock => quantity ?? 0;

  SparePartsResponse copyWith({
    String? id,
    String? assetId,
    String? partCat1Id,
    String? partCat2Id,
    String? partName,
    String? partNumber,
    double? cost,
    int? quantity,
    int? recordStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SparePartsResponse(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      partCat1Id: partCat1Id ?? this.partCat1Id,
      partCat2Id: partCat2Id ?? this.partCat2Id,
      partName: partName ?? this.partName,
      partNumber: partNumber ?? this.partNumber,
      cost: cost ?? this.cost,
      quantity: quantity ?? this.quantity,
      recordStatus: recordStatus ?? this.recordStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SparePartsResponse.fromJson(Map<String, dynamic> json) {
    String? _str(dynamic v) => v == null ? null : v as String;
    num? _num(dynamic v) => v == null ? null : v as num;

    DateTime? _dt(dynamic v) {
      final s = _str(v);
      if (s == null || s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    return SparePartsResponse(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      partCat1Id: _str(json['partCat1Id']),
      partCat2Id: _str(json['partCat2Id']),
      partName: json['partName'] as String,
      partNumber: json['partNumber'] as String,
      cost: _num(json['cost'])?.toDouble(),
      quantity: _num(json['quantity'])?.toInt(),
      recordStatus: _num(json['recordStatus'])?.toInt(),
      createdAt: _dt(json['createdAt']),
      updatedAt: _dt(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'assetId': assetId,
        'partCat1Id': partCat1Id,
        'partCat2Id': partCat2Id,
        'partName': partName,
        'partNumber': partNumber,
        'cost': cost,
        'quantity': quantity,
        'recordStatus': recordStatus,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() =>
      'SparePartsResponse(id: $id, partName: $partName, partNumber: $partNumber)';
}

/// Parse a JSON **string** that contains a list of parts
List<SparePartsResponse> assetSparePartListFromJson(String jsonStr) {
  final data = json.decode(jsonStr);
  if (data is List) {
    return data
        .map((e) => SparePartsResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  // If the API returns an object with `content`, handle that too:
  final content = (data as Map<String, dynamic>)['content'] as List<dynamic>;
  return content
      .map((e) => SparePartsResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Serialize a list back to a JSON **string**
String assetSparePartListToJson(List<SparePartsResponse> list) {
  return json.encode(list.map((e) => e.toJson()).toList());
}
