// persons_response.dart
import 'dart:convert';

OperatorsDetailsResponse personsResponseFromJson(String source) =>
    OperatorsDetailsResponse.fromJson(
        json.decode(source) as Map<String, dynamic>);

String personsResponseToJson(OperatorsDetailsResponse resp) =>
    json.encode(resp.toJson());

class OperatorsDetailsResponse {
  final List<OperatosDetails> content;
  final Page page;

  OperatorsDetailsResponse({
    required this.content,
    required this.page,
  });

  factory OperatorsDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OperatorsDetailsResponse(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => OperatosDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: Page.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };
}

class OperatosDetails {
  final String id;
  final String name;
  final DateTime? dob; // "1990-01-15"
  final String? bloodGroup; // e.g., "O+"
  final String? designation; // e.g., "Plant Manager"
  final String type; // e.g., "EMPLOYEE"
  final int recordStatus;
  final DateTime? updatedAt; // "2025-10-09T05:46:24.149091Z"

  final String tenantId;
  final String clientId;

  final String? userId;
  final String? organizationId;
  final String? parentStaffId;
  final String? managerId;
  final String? shiftId;
  final String? departmentId;

  final String? userEmail;
  final String? organizationName;
  final String? parentStaffName;
  final String? managerName;
  final String? shiftName;
  final String? departmentName;

  OperatosDetails({
    required this.id,
    required this.name,
    required this.type,
    required this.recordStatus,
    required this.tenantId,
    required this.clientId,
    this.dob,
    this.bloodGroup,
    this.designation,
    this.updatedAt,
    this.userId,
    this.organizationId,
    this.parentStaffId,
    this.managerId,
    this.shiftId,
    this.departmentId,
    this.userEmail,
    this.organizationName,
    this.parentStaffName,
    this.managerName,
    this.shiftName,
    this.departmentName,
  });

  factory OperatosDetails.fromJson(Map<String, dynamic> json) {
    // Safe date parsing helpers
    DateTime? _parseDate(String? v) =>
        (v == null || v.isEmpty) ? null : DateTime.parse(v);

    return OperatosDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      recordStatus: (json['recordStatus'] as num).toInt(),
      tenantId: json['tenantId'] as String,
      clientId: json['clientId'] as String,
      dob: _parseDate(json['dob'] as String?),
      bloodGroup: json['bloodGroup'] as String?,
      designation: json['designation'] as String?,
      updatedAt: _parseDate(json['updatedAt'] as String?),
      userId: json['userId'] as String?,
      organizationId: json['organizationId'] as String?,
      parentStaffId: json['parentStaffId'] as String?,
      managerId: json['managerId'] as String?,
      shiftId: json['shiftId'] as String?,
      departmentId: json['departmentId'] as String?,
      userEmail: json['userEmail'] as String?,
      organizationName: json['organizationName'] as String?,
      parentStaffName: json['parentStaffName'] as String?,
      managerName: json['managerName'] as String?,
      shiftName: json['shiftName'] as String?,
      departmentName: json['departmentName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dob': dob?.toIso8601String().split('T').first, // keep date-only format
        'bloodGroup': bloodGroup,
        'designation': designation,
        'type': type,
        'recordStatus': recordStatus,
        'updatedAt': updatedAt?.toIso8601String(),
        'tenantId': tenantId,
        'clientId': clientId,
        'userId': userId,
        'organizationId': organizationId,
        'parentStaffId': parentStaffId,
        'managerId': managerId,
        'shiftId': shiftId,
        'departmentId': departmentId,
        'userEmail': userEmail,
        'organizationName': organizationName,
        'parentStaffName': parentStaffName,
        'managerName': managerName,
        'shiftName': shiftName,
        'departmentName': departmentName,
      };
}

class Page {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  Page({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
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
