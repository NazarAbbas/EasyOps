import 'package:easy_ops/database/entity/login_person_details_entity.dart';
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart';

/// Format YYYY-MM-DD for date-only fields
String? _formatDate(DateTime? d) {
  if (d == null) return null;
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mm-$dd';
}

/// Get enum uppercase name if it's an enum; pass through if already String
String? _enumNameOrString(dynamic v) {
  if (v == null) return null;
  try {
    // Works for Dart enums that expose `.name`
    final n = (v as dynamic).name;
    if (n is String) return n; // e.g., 'EMPLOYEE'
  } catch (_) {/* ignore */}
  return v is String ? v : v.toString();
}

extension LoginPersonDetailsMapper on LoginPersonDetails {
  LoginPersonDetailsEntity toEntity() {
    return LoginPersonDetailsEntity(
      id: id, // assumed non-null
      name: name, // keep as-is (per your requirement)
      dob: _formatDate(dob) ?? '',
      bloodGroup: bloodGroup ?? '',
      designation: designation ?? '',
      type: _enumNameOrString(type) ?? '', // 'EMPLOYEE', etc.
      recordStatus: recordStatus,
      updatedAt: updatedAt?.toIso8601String() ?? '',
      userId: userId ?? '',
      userEmail: userEmail ?? '',
      organizationId: organizationId ?? '',
      organizationName: organizationName ?? '',
      departmentId: departmentId ?? '',
      departmentName: departmentName ?? '',
      managerId: managerId ?? '',
      managerName: managerName ?? '',
      shiftId: shiftId ?? '',
      shiftName: shiftName ?? '',
    );
  }
}

extension ContactMapper on LoginPersonContact {
  LoginPersonContactEntity toEntity() {
    return LoginPersonContactEntity(
      id: id, // assume non-null
      label: label ?? '',
      relationship: relationship ?? '',
      phone: phone ?? '',
      email: email ?? '',
      recordStatus: recordStatus,
      updatedAt: updatedAt?.toIso8601String() ?? '',
      personId: personId ?? '',
      personName: personName ?? '',
    );
  }
}

extension AttendanceMapper on LoginPersonAttendance {
  LoginPersonAttendanceEntity toEntity() {
    return LoginPersonAttendanceEntity(
      id: id, // assuming non-null in your model
      attDate: _formatDate(attDate) ?? '',
      checkIn: checkIn?.toIso8601String() ?? '',
      checkOut: checkOut?.toIso8601String() ?? '',
      remarks: remarks ?? '',
      status: status ?? '',
      recordStatus: recordStatus,
      updatedAt: updatedAt?.toIso8601String() ?? '',
      personId: personId ?? '',
      personName: personName ?? '',
      shiftId: shiftId ?? '',
      shiftName: shiftName ?? '',
    );
  }
}

extension AssetEntityMapper on LoginPersonAsset {
  LoginPersonAssetEntity toEntity() => LoginPersonAssetEntity(
        id: id,
        recordStatus: recordStatus,
        personId: personId,
        createdAt: createdAt?.toIso8601String() ?? '',
        personName: personName,
        assetId: assetId,
        assetName: assetName,
        assetSerialNumber: assetSerialNumber,
      );
}
