// lib/features/persons/data/local/person_entity.dart
import 'package:floor/floor.dart';

@Entity(
  tableName: 'operators_details_entity',
  indices: [
    Index(value: ['name']),
    Index(value: ['tenantId']),
    Index(value: ['clientId']),
    Index(value: ['organizationId']),
    Index(value: ['shiftId']),
    Index(value: ['departmentId']),
  ],
)
class OperatorsDetailsEntity {
  @primaryKey
  final String id;
  final String? code;

  final String name;
  final String userPhone;

  // Dates stored via converter (epoch millis)
  final DateTime? dob;
  final DateTime? updatedAt;

  final String? bloodGroup;
  final String? designation;

  /// e.g., EMPLOYEE
  final String type;

  final int recordStatus;

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

  const OperatorsDetailsEntity({
    required this.id,
    required this.name,
    this.code,
    required this.userPhone,
    required this.type,
    required this.recordStatus,
    required this.tenantId,
    required this.clientId,
    this.dob,
    this.updatedAt,
    this.bloodGroup,
    this.designation,
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
}
