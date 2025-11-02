import 'dart:convert';

/// Top-level helpers
OrganizationData orgListResponseFromJson(String source) =>
    OrganizationData.fromJson(json.decode(source) as Map<String, dynamic>);

String orgListResponseToJson(OrganizationData data) =>
    json.encode(data.toJson());

/// ─────────────────────────────────────────────────────────────────────────
/// MODELS
/// ─────────────────────────────────────────────────────────────────────────

class OrganizationData {
  final List<Organization> content;
  final PageMeta page;

  OrganizationData({
    required this.content,
    required this.page,
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    final raw = json['content'];
    final list = (raw is List ? raw : const <dynamic>[]);
    return OrganizationData(
      content: list
          .map((e) => Organization.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      page: PageMeta.fromJson(
        ((json['page'] ?? const <String, dynamic>{}) as Map)
            .cast<String, dynamic>(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };
}

class Organization {
  final String id;
  final String displayName;

  final String? orgTypeId;
  final String? orgTypeName;

  final String? addressLine1;
  final String? addressLine2;
  final String? zip;

  final int? recordStatus;

  final String? tenantId;
  final String? tenantName;

  final String? clientId;
  final String? clientName;

  final String? parentOrgId;
  final String? parentOrgName;

  final String? countryId;
  final String? countryName;

  final String? stateId;
  final String? stateName;

  final String? districtId;
  final String? districtName;

  final String? timezoneId;
  final String? timezoneName;

  final String? dateFormatId;

  final String? languageId;
  final String? languageName;

  final String? currencyId;
  final String? currencyName;

  final String? taxProfileId;

  Organization({
    required this.id,
    required this.displayName,
    this.orgTypeId,
    this.orgTypeName,
    this.addressLine1,
    this.addressLine2,
    this.zip,
    this.recordStatus,
    this.tenantId,
    this.tenantName,
    this.clientId,
    this.clientName,
    this.parentOrgId,
    this.parentOrgName,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.districtId,
    this.districtName,
    this.timezoneId,
    this.timezoneName,
    this.dateFormatId,
    this.languageId,
    this.languageName,
    this.currencyId,
    this.currencyName,
    this.taxProfileId,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: (json['id'] ?? '') as String,
        displayName: (json['displayName'] ?? '') as String,
        orgTypeId: json['orgTypeId'] as String?,
        orgTypeName: json['orgTypeName'] as String?,
        addressLine1: json['addressLine1'] as String?,
        addressLine2: json['addressLine2'] as String?,
        zip: json['zip'] as String?,
        recordStatus: json['recordStatus'] is num
            ? (json['recordStatus'] as num).toInt()
            : null,
        tenantId: json['tenantId'] as String?,
        tenantName: json['tenantName'] as String?,
        clientId: json['clientId'] as String?,
        clientName: json['clientName'] as String?,
        parentOrgId: json['parentOrgId'] as String?,
        parentOrgName: json['parentOrgName'] as String?,
        countryId: json['countryId'] as String?,
        countryName: json['countryName'] as String?,
        stateId: json['stateId'] as String?,
        stateName: json['stateName'] as String?,
        districtId: json['districtId'] as String?,
        districtName: json['districtName'] as String?,
        timezoneId: json['timezoneId'] as String?,
        timezoneName: json['timezoneName'] as String?,
        dateFormatId: json['dateFormatId'] as String?,
        languageId: json['languageId'] as String?,
        languageName: json['languageName'] as String?,
        currencyId: json['currencyId'] as String?,
        currencyName: json['currencyName'] as String?,
        taxProfileId: json['taxProfileId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'orgTypeId': orgTypeId,
        'orgTypeName': orgTypeName,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'zip': zip,
        'recordStatus': recordStatus,
        'tenantId': tenantId,
        'tenantName': tenantName,
        'clientId': clientId,
        'clientName': clientName,
        'parentOrgId': parentOrgId,
        'parentOrgName': parentOrgName,
        'countryId': countryId,
        'countryName': countryName,
        'stateId': stateId,
        'stateName': stateName,
        'districtId': districtId,
        'districtName': districtName,
        'timezoneId': timezoneId,
        'timezoneName': timezoneName,
        'dateFormatId': dateFormatId,
        'languageId': languageId,
        'languageName': languageName,
        'currencyId': currencyId,
        'currencyName': currencyName,
        'taxProfileId': taxProfileId,
      };

  Organization copyWith({
    String? id,
    String? displayName,
    String? orgTypeId,
    String? orgTypeName,
    String? addressLine1,
    String? addressLine2,
    String? zip,
    int? recordStatus,
    String? tenantId,
    String? tenantName,
    String? clientId,
    String? clientName,
    String? parentOrgId,
    String? parentOrgName,
    String? countryId,
    String? countryName,
    String? stateId,
    String? stateName,
    String? districtId,
    String? districtName,
    String? timezoneId,
    String? timezoneName,
    String? dateFormatId,
    String? languageId,
    String? languageName,
    String? currencyId,
    String? currencyName,
    String? taxProfileId,
  }) {
    return Organization(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      orgTypeId: orgTypeId ?? this.orgTypeId,
      orgTypeName: orgTypeName ?? this.orgTypeName,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      zip: zip ?? this.zip,
      recordStatus: recordStatus ?? this.recordStatus,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      parentOrgId: parentOrgId ?? this.parentOrgId,
      parentOrgName: parentOrgName ?? this.parentOrgName,
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      timezoneId: timezoneId ?? this.timezoneId,
      timezoneName: timezoneName ?? this.timezoneName,
      dateFormatId: dateFormatId ?? this.dateFormatId,
      languageId: languageId ?? this.languageId,
      languageName: languageName ?? this.languageName,
      currencyId: currencyId ?? this.currencyId,
      currencyName: currencyName ?? this.currencyName,
      taxProfileId: taxProfileId ?? this.taxProfileId,
    );
  }
}

class PageMeta {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  PageMeta({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
        size: (json['size'] as num?)?.toInt() ?? 0,
        number: (json['number'] as num?)?.toInt() ?? 0,
        totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
        totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}
