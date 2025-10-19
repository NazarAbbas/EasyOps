// lib/features/persons/data/mappers/person_mappers.dart
import 'package:easy_ops/database/entity/operators_details_entity.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';

extension PersonApiToEntityX on OperatosDetails {
  OperatorsDetailsEntity toEntity() => OperatorsDetailsEntity(
        id: id,
        name: name,
        userPhone: userPhone,
        type: type,
        recordStatus: recordStatus,
        tenantId: tenantId,
        clientId: clientId,
        dob: dob, // already DateTime?
        updatedAt: updatedAt,
        bloodGroup: bloodGroup,
        designation: designation,
        userId: userId,
        organizationId: organizationId,
        parentStaffId: parentStaffId,
        managerId: managerId,
        shiftId: shiftId,
        departmentId: departmentId,
        userEmail: userEmail,
        organizationName: organizationName,
        parentStaffName: parentStaffName,
        managerName: managerName,
        shiftName: shiftName,
        departmentName: departmentName,
      );
}

extension PersonEntityToApiX on OperatorsDetailsEntity {
  OperatosDetails toDomain() => OperatosDetails(
        id: id,
        name: name,
        userPhone: userPhone,
        type: type,
        recordStatus: recordStatus,
        tenantId: tenantId,
        clientId: clientId,
        dob: dob,
        updatedAt: updatedAt,
        bloodGroup: bloodGroup,
        designation: designation,
        userId: userId,
        organizationId: organizationId,
        parentStaffId: parentStaffId,
        managerId: managerId,
        shiftId: shiftId,
        departmentId: departmentId,
        userEmail: userEmail,
        organizationName: organizationName,
        parentStaffName: parentStaffName,
        managerName: managerName,
        shiftName: shiftName,
        departmentName: departmentName,
      );
}
