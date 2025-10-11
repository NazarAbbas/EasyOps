import 'package:easy_ops/database/entity/login_person_details_entity.dart';
import 'package:easy_ops/features/login/models/login_person_details.dart';

extension LoginPersonDetailsMapper on LoginPersonDetails {
  LoginPersonDetailsEntity toEntity() {
    return LoginPersonDetailsEntity(
      id: id,
      name: name,
      dob: dob?.toIso8601String(),
      bloodGroup: bloodGroup,
      designation: designation,
      type: type,
      recordStatus: recordStatus,
      updatedAt: updatedAt.toIso8601String(),
      userId: userId,
      userEmail: userEmail,
      organizationId: organizationId,
      organizationName: organizationName,
      departmentId: departmentId,
      departmentName: departmentName,
      managerId: managerId,
      managerName: managerName,
      shiftId: shiftId,
      shiftName: shiftName,
    );
  }
}

extension ContactMapper on LoginPersonContact {
  LoginPersonContactEntity toEntity() {
    return LoginPersonContactEntity(
      id: id,
      label: label,
      relationship: relationship,
      phone: phone,
      email: email,
      recordStatus: recordStatus,
      updatedAt: updatedAt.toIso8601String(),
      personId: personId,
      personName: personName,
    );
  }
}

extension AttendanceMapper on LoginPersonAttendance {
  LoginPersonAttendanceEntity toEntity() {
    return LoginPersonAttendanceEntity(
      id: id,
      attDate: attDate.toIso8601String(),
      checkIn: checkIn?.toIso8601String(),
      checkOut: checkOut?.toIso8601String(),
      remarks: remarks,
      status: status,
      recordStatus: recordStatus,
      updatedAt: updatedAt.toIso8601String(),
      personId: personId,
      personName: personName,
      shiftId: shiftId,
      shiftName: shiftName,
    );
  }
}
