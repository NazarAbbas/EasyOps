import 'package:floor/floor.dart';

@Entity(tableName: 'login_person_details')
class LoginPersonDetailsEntity {
  @primaryKey
  final String id;
  final String name;
  final String code;
  final String userPhone;
  final String? dob;
  final String? bloodGroup;
  final String? designation;
  final String? type;
  final int recordStatus;
  final String updatedAt;
  final String? userId;
  final String? userEmail;
  final String? organizationId;
  final String? organizationName;
  final String? departmentId;
  final String? departmentName;
  final String? managerId;
  final String? managerName;
  final String? managerContact;
  final String? shiftId;
  final String? shiftName;

  LoginPersonDetailsEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.userPhone,
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
    this.managerContact,
    this.shiftId,
    this.shiftName,
  });
}

@Entity(
  tableName: 'login_person_contact',
  foreignKeys: [
    ForeignKey(
      childColumns: ['personId'],
      parentColumns: ['id'],
      entity: LoginPersonDetailsEntity,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class LoginPersonContactEntity {
  @primaryKey
  final String id;
  final String label;
  final String? relationship;
  final String? phone;
  final String? email;
  final int recordStatus;
  final String updatedAt;
  final String personId;
  final String personName;
  final String name;

  LoginPersonContactEntity({
    required this.id,
    required this.label,
    this.relationship,
    this.phone,
    this.email,
    required this.recordStatus,
    required this.updatedAt,
    required this.personId,
    required this.personName,
    required this.name,
  });
}

@Entity(
  tableName: 'login_person_attendance',
  foreignKeys: [
    ForeignKey(
      childColumns: ['personId'],
      parentColumns: ['id'],
      entity: LoginPersonDetailsEntity,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class LoginPersonAttendanceEntity {
  @primaryKey
  final String id;
  final String attDate;
  final String? checkIn;
  final String? checkOut;
  final String? remarks;
  final String status;
  final int recordStatus;
  final String updatedAt;
  final String personId;
  final String personName;
  final String? shiftId;
  final String? shiftName;

  LoginPersonAttendanceEntity({
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
}

@Entity(
  tableName: 'login_person_assets',
  foreignKeys: [
    ForeignKey(
      childColumns: ['personId'],
      parentColumns: ['id'],
      entity: LoginPersonDetailsEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['personId']),
    Index(value: ['assetId']),
  ],
)
class LoginPersonAssetEntity {
  @primaryKey
  final String id;

  final int recordStatus;
  final String? createdAt;
  final String? personId;
  final String? personName;
  final String? assetId;
  final String? assetName;
  final String? assetSerialNumber;

  const LoginPersonAssetEntity({
    required this.id,
    required this.recordStatus,
    required this.personId,
    this.createdAt,
    this.personName,
    this.assetId,
    this.assetName,
    this.assetSerialNumber,
  });
}

@Entity(tableName: 'login_person_holidays')
class LoginPersonHolidayEntity {
  @primaryKey
  final String id;
  final DateTime? holidayDate;
  final String? holidayName;

  const LoginPersonHolidayEntity({
    required this.id,
    this.holidayDate,
    this.holidayName,
  });
}
