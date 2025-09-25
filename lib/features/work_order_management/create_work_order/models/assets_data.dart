// asset_page_response.dart
import 'dart:convert';

class AssetsData {
  final List<AssetItem> content;
  final PageInfo page;

  AssetsData({
    required this.content,
    required this.page,
  });

  factory AssetsData.fromJson(Map<String, dynamic> json) {
    return AssetsData(
      content: (json['content'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AssetItem.fromJson)
          .toList(),
      page: PageInfo.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };

  String toJsonString() => jsonEncode(toJson());
}

class AssetItem {
  final String id;
  final String name;
  final String criticality; // e.g. "HIGH"
  final String? description;
  final String? serialNumber;
  final String? manufacturer;
  final String? manufacturerPhone;
  final String? manufacturerEmail;
  final String? manufacturerAddress;
  final String status; // e.g. "ACTIVE"
  final int recordStatus; // 1/2/0
  final DateTime updatedAt; // ISO-8601
  final String tenantId;
  final String clientId;
  final String plantId;
  final String departmentId;
  final String? plantName;
  final String? departmentName;

  AssetItem({
    required this.id,
    required this.name,
    required this.criticality,
    this.description,
    this.serialNumber,
    this.manufacturer,
    this.manufacturerPhone,
    this.manufacturerEmail,
    this.manufacturerAddress,
    required this.status,
    required this.recordStatus,
    required this.updatedAt,
    required this.tenantId,
    required this.clientId,
    required this.plantId,
    required this.departmentId,
    this.plantName,
    this.departmentName,
  });

  factory AssetItem.fromJson(Map<String, dynamic> j) => AssetItem(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        criticality: (j['criticality'] ?? '').toString(),
        description: j['description'] as String?,
        serialNumber: j['serialNumber'] as String?,
        manufacturer: j['manufacturer'] as String?,
        manufacturerPhone: j['manufacturerPhone'] as String?,
        manufacturerEmail: j['manufacturerEmail'] as String?,
        manufacturerAddress: j['manufacturerAddress'] as String?,
        status: (j['status'] ?? '').toString(),
        recordStatus: (j['recordStatus'] as num?)?.toInt() ?? 0,
        updatedAt: DateTime.parse(j['updatedAt'] as String),
        tenantId: (j['tenantId'] ?? '').toString(),
        clientId: (j['clientId'] ?? '').toString(),
        plantId: (j['plantId'] ?? '').toString(),
        departmentId: (j['departmentId'] ?? '').toString(),
        plantName: j['plantName'] as String?,
        departmentName: j['departmentName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'criticality': criticality,
        if (description != null) 'description': description,
        if (serialNumber != null) 'serialNumber': serialNumber,
        if (manufacturer != null) 'manufacturer': manufacturer,
        if (manufacturerPhone != null) 'manufacturerPhone': manufacturerPhone,
        if (manufacturerEmail != null) 'manufacturerEmail': manufacturerEmail,
        if (manufacturerAddress != null)
          'manufacturerAddress': manufacturerAddress,
        'status': status,
        'recordStatus': recordStatus,
        'updatedAt': updatedAt.toIso8601String(),
        'tenantId': tenantId,
        'clientId': clientId,
        'plantId': plantId,
        'departmentId': departmentId,
        if (plantName != null) 'plantName': plantName,
        if (departmentName != null) 'departmentName': departmentName,
      };
}

class PageInfo {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  PageInfo({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageInfo.fromJson(Map<String, dynamic> j) => PageInfo(
        size: (j['size'] as num).toInt(),
        number: (j['number'] as num).toInt(),
        totalElements: (j['totalElements'] as num).toInt(),
        totalPages: (j['totalPages'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}
