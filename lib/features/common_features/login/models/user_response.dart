// users_page_response.dart

import 'dart:convert';

class UsersResponse {
  final List<UserSummary> content;
  final PageInfo page;

  const UsersResponse({
    required this.content,
    required this.page,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      content: (json['content'] as List<dynamic>? ?? const [])
          .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: PageInfo.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };

  /// Convenience if you receive a raw JSON string
  static UsersResponse fromJsonString(String source) =>
      UsersResponse.fromJson(jsonDecode(source) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}

class UserSummary {
  final String id;
  final String email;
  final String? communicationEmail;
  final String passwordHash;
  final String firstName;
  final String lastName;
  final String phone;
  final UserType userType;
  final int recordStatus; // keep as int (0/1/2 per your platform)
  final DateTime createdAt;
  final DateTime updatedAt;

  final String tenantId;
  final String tenantName;
  final String clientId;
  final String clientName;
  final String? orgId;
  final String? orgName;

  const UserSummary({
    required this.id,
    required this.email,
    required this.communicationEmail,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.tenantId,
    required this.tenantName,
    required this.clientId,
    required this.clientName,
    required this.orgId,
    required this.orgName,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['id'] as String,
      email: json['email'] as String,
      communicationEmail: json['communicationEmail'] as String?,
      passwordHash: json['passwordHash'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      userType: UserTypeX.fromString(json['userType'] as String?),
      recordStatus: (json['recordStatus'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      orgId: json['orgId'] as String?,
      orgName: json['orgName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'communicationEmail': communicationEmail,
        'passwordHash': passwordHash,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'userType': userType.label,
        'recordStatus': recordStatus,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        'tenantId': tenantId,
        'tenantName': tenantName,
        'clientId': clientId,
        'clientName': clientName,
        'orgId': orgId,
        'orgName': orgName,
      };

  /// Handy display helpers
  String get fullName =>
      [firstName, lastName].where((s) => s.trim().isNotEmpty).join(' ').trim();
  bool get hasOrg => orgId != null && orgId!.isNotEmpty;
}

class PageInfo {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  const PageInfo({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      size: (json['size'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}

/// User type with safe parsing
enum UserType {
  clientAdmin,
  productionSupervisor,
  maintenanceEngineer,
  unknown,
}

extension UserTypeX on UserType {
  String get label {
    switch (this) {
      case UserType.clientAdmin:
        return 'Client Admin';
      case UserType.productionSupervisor:
        return 'Production Supervisor';
      case UserType.maintenanceEngineer:
        return 'Maintenance Engineer';
      case UserType.unknown:
        return 'Unknown';
    }
  }

  static UserType fromString(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'client admin':
        return UserType.clientAdmin;
      case 'production supervisor':
        return UserType.productionSupervisor;
      case 'maintenance engineer':
        return UserType.maintenanceEngineer;
      default:
        return UserType.unknown;
    }
  }
}
