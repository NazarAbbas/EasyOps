class LoginPersonDetails {
  final String id;
  final String name;
  final DateTime? dob;
  final String? bloodGroup;
  final String? designation;
  final String? type;
  final int recordStatus;
  final DateTime updatedAt;
  final String? userId;
  final String? userEmail;
  final String? organizationId;
  final String? organizationName;
  final String? departmentId;
  final String? departmentName;
  final String? managerId;
  final String? managerName;
  final String? shiftId;
  final String? shiftName;
  final List<LoginPersonContact> contacts;
  final List<dynamic> assets; // Can be expanded if asset model is defined later
  final List<LoginPersonAttendance> attendance;

  LoginPersonDetails({
    required this.id,
    required this.name,
    this.dob,
    this.bloodGroup,
    this.designation,
    this.type,
    required this.recordStatus,
    required this.updatedAt,
    this.userId,
    this.userEmail,
    this.organizationId,
    this.organizationName,
    this.departmentId,
    this.departmentName,
    this.managerId,
    this.managerName,
    this.shiftId,
    this.shiftName,
    this.contacts = const [],
    this.assets = const [],
    this.attendance = const [],
  });

  factory LoginPersonDetails.fromJson(Map<String, dynamic> json) {
    return LoginPersonDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      bloodGroup: json['bloodGroup'] as String?,
      designation: json['designation'] as String?,
      type: json['type'] as String?,
      recordStatus: json['recordStatus'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
      userEmail: json['userEmail'] as String?,
      organizationId: json['organizationId'] as String?,
      organizationName: json['organizationName'] as String?,
      departmentId: json['departmentId'] as String?,
      departmentName: json['departmentName'] as String?,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      shiftId: json['shiftId'] as String?,
      shiftName: json['shiftName'] as String?,
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map(
                  (e) => LoginPersonContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      assets: json['assets'] as List<dynamic>? ?? const [],
      attendance: (json['attendance'] as List<dynamic>?)
              ?.map((e) =>
                  LoginPersonAttendance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'designation': designation,
      'type': type,
      'recordStatus': recordStatus,
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'userEmail': userEmail,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'managerId': managerId,
      'managerName': managerName,
      'shiftId': shiftId,
      'shiftName': shiftName,
      'contacts': contacts.map((e) => e.toJson()).toList(),
      'assets': assets,
      'attendance': attendance.map((e) => e.toJson()).toList(),
    };
  }
}

class LoginPersonContact {
  final String id;
  final String label;
  final String? relationship;
  final String? phone;
  final String? email;
  final int recordStatus;
  final DateTime updatedAt;
  final String personId;
  final String personName;

  LoginPersonContact({
    required this.id,
    required this.label,
    this.relationship,
    this.phone,
    this.email,
    required this.recordStatus,
    required this.updatedAt,
    required this.personId,
    required this.personName,
  });

  factory LoginPersonContact.fromJson(Map<String, dynamic> json) {
    return LoginPersonContact(
      id: json['id'] as String,
      label: json['label'] as String,
      relationship: json['relationship'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      recordStatus: json['recordStatus'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      personId: json['personId'] as String,
      personName: json['personName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'relationship': relationship,
      'phone': phone,
      'email': email,
      'recordStatus': recordStatus,
      'updatedAt': updatedAt.toIso8601String(),
      'personId': personId,
      'personName': personName,
    };
  }
}

class LoginPersonAttendance {
  final String id;
  final DateTime attDate;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? remarks;
  final String status;
  final int recordStatus;
  final DateTime updatedAt;
  final String personId;
  final String personName;
  final String? shiftId;
  final String? shiftName;

  LoginPersonAttendance({
    required this.id,
    required this.attDate,
    this.checkIn,
    this.checkOut,
    this.remarks,
    required this.status,
    required this.recordStatus,
    required this.updatedAt,
    required this.personId,
    required this.personName,
    this.shiftId,
    this.shiftName,
  });

  factory LoginPersonAttendance.fromJson(Map<String, dynamic> json) {
    return LoginPersonAttendance(
      id: json['id'] as String,
      attDate: DateTime.parse(json['attDate'] as String),
      checkIn: json['checkIn'] != null ? DateTime.parse(json['checkIn']) : null,
      checkOut:
          json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      remarks: json['remarks'] as String?,
      status: json['status'] as String,
      recordStatus: json['recordStatus'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      personId: json['personId'] as String,
      personName: json['personName'] as String,
      shiftId: json['shiftId'] as String?,
      shiftName: json['shiftName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attDate': attDate.toIso8601String(),
      'checkIn': checkIn?.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'remarks': remarks,
      'status': status,
      'recordStatus': recordStatus,
      'updatedAt': updatedAt.toIso8601String(),
      'personId': personId,
      'personName': personName,
      'shiftId': shiftId,
      'shiftName': shiftName,
    };
  }
}
