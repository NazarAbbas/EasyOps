// person_models.dart

/// Root Person model
class LoginPersonDetails {
  final String id;
  final String name;
  final DateTime? dob; // "1990-01-15"
  final String? bloodGroup; // e.g., "O+"
  final String? designation; // e.g., "Plant Manager"
  final String? type; // e.g., EMPLOYEE
  final int recordStatus;
  final DateTime? updatedAt;

  final String? userId;
  final String? userEmail;
  final String? userPhone;

  final String? organizationId;
  final String? organizationName;

  final String? departmentId; // can be null
  final String? departmentName; // can be null

  final String? managerId; // can be null
  final String? managerName; // can be null
  final String? managerContact;

  final String? shiftId;
  final String? shiftName;

  final List<LoginPersonContact> contacts;
  final List<LoginPersonAsset> assets;
  final List<LoginPersonAttendance> attendance;
  final List<OrganizationHoliday> organizationHolidays;

  LoginPersonDetails({
    required this.id,
    required this.name,
    required this.userPhone,
    required this.recordStatus,
    this.dob,
    this.bloodGroup,
    this.designation,
    this.type,
    this.updatedAt,
    this.userId,
    this.userEmail,
    this.organizationId,
    this.organizationName,
    this.departmentId,
    this.departmentName,
    this.managerId,
    this.managerName,
    this.managerContact,
    this.shiftId,
    this.shiftName,
    this.contacts = const [],
    this.assets = const [],
    this.attendance = const [],
    this.organizationHolidays = const [],
  });

  factory LoginPersonDetails.fromJson(Map<String, dynamic> json) {
    return LoginPersonDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      userPhone: json['userPhone'] as String,
      recordStatus: (json['recordStatus'] as num).toInt(),
      dob: _parseDate(json['dob']),
      bloodGroup: json['bloodGroup'] as String?,
      designation: json['designation'] as String?,
      type: json['type'] as String?,
      updatedAt: _parseDateTime(json['updatedAt']),
      userId: json['userId'] as String?,
      userEmail: json['userEmail'] as String?,
      organizationId: json['organizationId'] as String?,
      organizationName: json['organizationName'] as String?,
      departmentId: json['departmentId'] as String?,
      departmentName: json['departmentName'] as String?,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      managerContact: json['managerContact'] ?? '',
      shiftId: json['shiftId'] as String?,
      shiftName: json['shiftName'] as String?,
      contacts: _readList<Map<String, dynamic>>(json['contacts'])
          .map(LoginPersonContact.fromJson)
          .toList(),
      assets: _readList<Map<String, dynamic>>(json['assets'])
          .map(LoginPersonAsset.fromJson)
          .toList(),
      attendance: _readList<Map<String, dynamic>>(json['attendance'])
          .map(LoginPersonAttendance.fromJson)
          .toList(),
      organizationHolidays: (_asList(json['organizationHolidays']))
              ?.map((e) => OrganizationHoliday.fromJson(_asMap(e)))
              .whereType<OrganizationHoliday>()
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userPhone': userPhone,
        'dob': _formatDate(dob),
        'bloodGroup': bloodGroup,
        'designation': designation,
        'type': type, // back to "EMPLOYEE"
        'recordStatus': recordStatus,
        'updatedAt': updatedAt?.toIso8601String(),
        'userId': userId,
        'userEmail': userEmail,
        'organizationId': organizationId,
        'organizationName': organizationName,
        'departmentId': departmentId,
        'departmentName': departmentName,
        'managerId': managerId,
        'managerName': managerName,
        'managerContact': managerContact,
        'shiftId': shiftId,
        'shiftName': shiftName,
        'contacts': contacts.map((e) => e.toJson()).toList(),
        'assets': assets.map((e) => e.toJson()).toList(),
        'attendance': attendance.map((e) => e.toJson()).toList(),
        'organizationHolidays':
            organizationHolidays.map((e) => e.toJson()).toList(),
      };

  LoginPersonDetails copyWith({
    String? id,
    String? userPhone,
    String? name,
    String? us,
    DateTime? dob,
    String? bloodGroup,
    String? designation,
    String? type,
    int? recordStatus,
    DateTime? updatedAt,
    String? userId,
    String? userEmail,
    String? organizationId,
    String? organizationName,
    String? departmentId,
    String? departmentName,
    String? managerId,
    String? managerName,
    String? managerContact,
    String? shiftId,
    String? shiftName,
    List<LoginPersonContact>? contacts,
    List<LoginPersonAsset>? assets,
    List<LoginPersonAttendance>? attendance,
    List<OrganizationHoliday>? organizationHolidays,
  }) {
    return LoginPersonDetails(
      id: id ?? this.id,
      userPhone: userPhone ?? this.userPhone,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      designation: designation ?? this.designation,
      type: type ?? this.type,
      recordStatus: recordStatus ?? this.recordStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      managerContact: managerContact ?? this.managerContact,
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      contacts: contacts ?? this.contacts,
      assets: assets ?? this.assets,
      attendance: attendance ?? this.attendance,
      organizationHolidays: organizationHolidays ?? this.organizationHolidays,
    );
  }
}

Map<String, dynamic> _asMap(dynamic v) =>
    (v is Map) ? v.cast<String, dynamic>() : <String, dynamic>{};

DateTime? _parseDateTime(dynamic v) {
  final s = _asString(v);
  if (s == null || s.trim().isEmpty) return null;
  try {
    return DateTime.parse(s);
  } catch (_) {
    return null;
  }
}

/// Parse "yyyy-MM-dd" into DateTime (local date at midnight).
DateTime? _parseDateOnly(dynamic v) {
  final s = _asString(v);
  if (s == null || s.trim().isEmpty) return null;
  try {
    // Ensure only the date portion is considered
    final parts = s.split('T').first;
    final date = DateTime.parse(parts);
    return DateTime(date.year, date.month, date.day);
  } catch (_) {
    return null;
  }
}

/// Format date-only fields as "yyyy-MM-dd"
String? _formatDateOnly(DateTime? d) {
  if (d == null) return null;
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

/// Person type enum, safely parsed
enum PersonType { employee, contractor, intern, vendor, unknown }

extension PersonTypeX on PersonType {
  String get name {
    switch (this) {
      case PersonType.employee:
        return 'EMPLOYEE';
      case PersonType.contractor:
        return 'CONTRACTOR';
      case PersonType.intern:
        return 'INTERN';
      case PersonType.vendor:
        return 'VENDOR';
      case PersonType.unknown:
        return 'UNKNOWN';
    }
  }

  static PersonType? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'EMPLOYEE':
        return PersonType.employee;
      case 'CONTRACTOR':
        return PersonType.contractor;
      case 'INTERN':
        return PersonType.intern;
      case 'VENDOR':
        return PersonType.vendor;
      case null:
        return null;
      default:
        return PersonType.unknown;
    }
  }
}

/// Contact record within Person
class LoginPersonContact {
  final String id;
  final String? label; // "Emergency Contact"
  final String? relationship; // "Spouse"
  final String? phone;
  final String? email;
  final int recordStatus;
  final DateTime? updatedAt;
  final String? personId;
  final String? personName;
  final String? name;

  LoginPersonContact(
      {required this.id,
      required this.recordStatus,
      this.label,
      this.relationship,
      this.phone,
      this.email,
      this.updatedAt,
      this.personId,
      this.personName,
      this.name});

  factory LoginPersonContact.fromJson(Map<String, dynamic> json) {
    return LoginPersonContact(
      id: json['id'] as String,
      label: json['label'] as String?,
      relationship: json['relationship'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      recordStatus: (json['recordStatus'] as num).toInt(),
      updatedAt: _parseDateTime(json['updatedAt']),
      personId: json['personId'] as String?,
      personName: json['personName'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'relationship': relationship,
        'phone': phone,
        'email': email,
        'recordStatus': recordStatus,
        'updatedAt': updatedAt?.toIso8601String(),
        'personId': personId,
        'personName': personName,
        'name': name,
      };
}

/// Asset assignment linked to Person
class LoginPersonAsset {
  final String id;
  final int recordStatus;
  final DateTime? createdAt;
  final String? personId;
  final String? personName;
  final String? assetId;
  final String? assetName;
  final String? assetSerialNumber;

  LoginPersonAsset({
    required this.id,
    required this.recordStatus,
    this.createdAt,
    this.personId,
    this.personName,
    this.assetId,
    this.assetName,
    this.assetSerialNumber,
  });

  factory LoginPersonAsset.fromJson(Map<String, dynamic> json) {
    return LoginPersonAsset(
      id: json['id'] as String,
      recordStatus: (json['recordStatus'] as num).toInt(),
      createdAt: _parseDateTime(json['createdAt']),
      personId: json['personId'] as String?,
      personName: json['personName'] as String?,
      assetId: json['assetId'] as String?,
      assetName: json['assetName'] as String?,
      assetSerialNumber: json['assetSerialNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'recordStatus': recordStatus,
        'createdAt': createdAt?.toIso8601String(),
        'personId': personId,
        'personName': personName,
        'assetId': assetId,
        'assetName': assetName,
        'assetSerialNumber': assetSerialNumber,
      };
}

List<dynamic>? _asList(dynamic v) => v is List ? v : null;

/// Attendance record linked to Person
class LoginPersonAttendance {
  final String id;
  final DateTime? attDate; // date-only: "2025-01-15"
  final DateTime? checkIn; // ISO: "2025-01-15T09:00:00Z"
  final DateTime? checkOut; // ISO: "2025-01-15T17:00:00Z"
  final String? remarks; // "Regular working day"
  final String?
      status; // "Present" (kept as string; map to enum later if needed)
  final int recordStatus;
  final DateTime? updatedAt;

  final String? personId;
  final String? personName;
  final String? shiftId;
  final String? shiftName;

  LoginPersonAttendance({
    required this.id,
    required this.recordStatus,
    this.attDate,
    this.checkIn,
    this.checkOut,
    this.remarks,
    this.status,
    this.updatedAt,
    this.personId,
    this.personName,
    this.shiftId,
    this.shiftName,
  });

  factory LoginPersonAttendance.fromJson(Map<String, dynamic> json) {
    return LoginPersonAttendance(
      id: json['id'] as String,
      attDate: _parseDate(json['attDate']),
      checkIn: _parseDateTime(json['checkIn']),
      checkOut: _parseDateTime(json['checkOut']),
      remarks: json['remarks'] as String?,
      status: json['status'] as String?,
      recordStatus: (json['recordStatus'] as num).toInt(),
      updatedAt: _parseDateTime(json['updatedAt']),
      personId: json['personId'] as String?,
      personName: json['personName'] as String?,
      shiftId: json['shiftId'] as String?,
      shiftName: json['shiftName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'attDate': _formatDate(attDate),
        'checkIn': checkIn?.toIso8601String(),
        'checkOut': checkOut?.toIso8601String(),
        'remarks': remarks,
        'status': status,
        'recordStatus': recordStatus,
        'updatedAt': updatedAt?.toIso8601String(),
        'personId': personId,
        'personName': personName,
        'shiftId': shiftId,
        'shiftName': shiftName,
      };
}

class OrganizationHoliday {
  final DateTime? holidayDate; // date-only
  final String? holidayName;

  const OrganizationHoliday({
    this.holidayDate,
    this.holidayName,
  });

  factory OrganizationHoliday.fromJson(Map<String, dynamic> json) =>
      OrganizationHoliday(
        holidayDate: _parseDateOnly(json['holidayDate']),
        holidayName: _asString(json['holidayName']),
      );

  Map<String, dynamic> toJson() => {
        'holidayDate': _formatDateOnly(holidayDate),
        'holidayName': holidayName,
      };

  OrganizationHoliday copyWith({
    DateTime? holidayDate,
    String? holidayName,
  }) =>
      OrganizationHoliday(
        holidayDate: holidayDate ?? this.holidayDate,
        holidayName: holidayName ?? this.holidayName,
      );
}

/* ===================== helpers ===================== */

T _as<T>(dynamic v) => v as T;

/// Safely read a JSON list and cast each element to T (Map<String, dynamic> for nested objects).
List<T> _readList<T>(dynamic value) {
  if (value is List) {
    return value
        .where((e) => e != null)
        .map<T>((e) => _as<T>(e is Map ? Map<String, dynamic>.from(e) : e))
        .toList();
  }
  return const [];
}

// DateTime? _parseDateTime(dynamic v) {
//   if (v == null) return null;
//   try {
//     return DateTime.parse(v.toString());
//   } catch (_) {
//     return null;
//   }
// }

/// Accepts "YYYY-MM-DD" and returns a DateTime at midnight UTC.
/// If you need local, adjust accordingly.
DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  try {
    // Ensure it's date-only. If a full timestamp sneaks in, DateTime.parse still works.
    final s = v.toString();
    return DateTime.parse(s.length >= 10 ? s.substring(0, 10) : s);
  } catch (_) {
    return null;
  }
}

String? _formatDate(DateTime? d) {
  if (d == null) return null;
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mm-$dd';
}

String? _asString(dynamic v) => v is String ? v : null;
