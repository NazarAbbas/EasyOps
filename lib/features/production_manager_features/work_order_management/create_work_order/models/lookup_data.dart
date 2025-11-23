import 'dart:convert';

/// Top-level wrapper
class LookupData {
  final List<LookupValues> content;
  final PageMeta page;

  const LookupData({
    required this.content,
    required this.page,
  });

  factory LookupData.fromJson(Map<String, dynamic> json) {
    return LookupData(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => LookupValues.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: PageMeta.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };

  /// Convenience
  static LookupData fromJsonString(String s) =>
      LookupData.fromJson(json.decode(s) as Map<String, dynamic>);

  String toJsonString() => json.encode(toJson());
}

/// Single lookup row
class LookupValues {
  final String id;
  final String code;
  final String displayName;
  final String description;
  final String lookupType;
  final int sortOrder;
  final int recordStatus;
  final DateTime? updatedAt;
  final String? tenantId;
  final String? clientId;

  const LookupValues({
    required this.id,
    required this.code,
    required this.displayName,
    required this.description,
    required this.lookupType,
    required this.sortOrder,
    required this.recordStatus,
    this.updatedAt,
    this.tenantId,
    this.clientId,
  });

  factory LookupValues.fromJson(Map<String, dynamic> json) {
    return LookupValues(
      id: json['id'] as String,
      code: json['code'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      lookupType: json['lookupType'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      recordStatus: (json['recordStatus'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tenantId: json['tenantId'] as String,
      clientId: json['clientId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'displayName': displayName,
        'description': description,
        'lookupType': lookupType,
        'sortOrder': sortOrder,
        'recordStatus': recordStatus,
        if (updatedAt != null)
          'updatedAt': updatedAt!.toUtc().toIso8601String(),
        if (clientId != null) 'tenantId': tenantId,
        if (clientId != null) 'clientId': clientId,
      };

  LookupValues copyWith({
    String? id,
    String? code,
    String? displayName,
    String? description,
    String? lookupType,
    int? sortOrder,
    int? recordStatus,
    DateTime? updatedAt,
    String? tenantId,
    String? clientId,
  }) {
    return LookupValues(
      id: id ?? this.id,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      lookupType: lookupType ?? this.lookupType,
      sortOrder: sortOrder ?? this.sortOrder,
      recordStatus: recordStatus ?? this.recordStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      tenantId: tenantId ?? this.tenantId,
      clientId: clientId ?? this.clientId,
    );
  }
}

/// Pagination metadata
class PageMeta {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  const PageMeta({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
        size: (json['size'] as num).toInt(),
        number: (json['number'] as num).toInt(),
        totalElements: (json['totalElements'] as num).toInt(),
        totalPages: (json['totalPages'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}

/// LookupType enum with robust parsing
enum LookupType {
  department,
  plant,
  workorderissuetype,
  impact,
  suggestion,
  resolutiontype,
  cancellation,
  assetcat1,
  activityType,
  unknown
}

extension LookupTypeX on LookupType {
  static LookupType fromString(String? v) {
    switch ((v ?? '').toUpperCase()) {
      case 'DEPARTMENT':
        return LookupType.department;
      case 'PLANT':
        return LookupType.plant;
      case 'WORKORDERISSUETYPE':
        return LookupType.workorderissuetype;
      case 'IMPACT':
        return LookupType.impact;
      case 'SUGGESTION':
        return LookupType.suggestion;
      case 'RESOLUTIONTYPE':
        return LookupType.resolutiontype;
      case 'CANCELLATION':
        return LookupType.cancellation;
      case 'ASSETCAT1':
        return LookupType.assetcat1;
      case 'ACTIVITYTYPE':
        return LookupType.activityType;
      default:
        return LookupType.unknown;
    }
  }
}
