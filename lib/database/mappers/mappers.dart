// lib/database/mappers/asset_mappers.dart
import 'package:easy_ops/database/converter/converters.dart';
import 'package:easy_ops/database/converter/criticality_converter.dart';
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:easy_ops/database/entity/user_list_entity.dart';
import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/database/entity/login_person_details_entity.dart';
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart';
import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'dart:convert';
import 'package:easy_ops/database/entity/offline_work_order_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/offline_work_order.dart';
import 'package:easy_ops/database/entity/operators_details_entity.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
import 'package:easy_ops/database/entity/shift_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';

extension AssetEntityDomainX on AssetEntity {
  AssetItem toDomain() => AssetItem(
        id: id,
        name: name,
        criticality: criticality.name,
        description: description,
        serialNumber: serialNumber,
        manufacturer: manufacturer,
        manufacturerPhone: manufacturerPhone,
        manufacturerEmail: manufacturerEmail,
        manufacturerAddress: manufacturerAddress,
        status: status.name,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
        plantId: plantId,
        departmentId: departmentId,
        plantName: plantName,
        departmentName: departmentName,
      );
}

extension AssetDomainEntityX on AssetItem {
  AssetEntity toEntity() => AssetEntity(
        id: id,
        name: name,
        criticality: Criticality.values.firstWhere(
          (e) => e.name.toUpperCase() == criticality.toUpperCase(),
          orElse: () => Criticality.MEDIUM,
        ),
        description: description,
        // If your AssetItem.serialNumber is non-nullable, drop the !.
        serialNumber: serialNumber!,
        manufacturer: manufacturer,
        manufacturerPhone: manufacturerPhone,
        manufacturerEmail: manufacturerEmail,
        manufacturerAddress: manufacturerAddress,
        status: AssetStatus.values.firstWhere(
          (e) => e.name.toUpperCase() == status.toUpperCase(),
          orElse: () => AssetStatus.ACTIVE,
        ),
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
        plantId: plantId,
        departmentId: departmentId,
        plantName: plantName,
        departmentName: departmentName,
      );
}

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
      userPhone: userPhone ?? '',
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
      name: name ?? '',
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

extension OrganizationHolidayToEntityX on OrganizationHoliday {
  LoginPersonHolidayEntity toEntity() {
    return LoginPersonHolidayEntity(
      id: _holidayIdFromDate(holidayDate),
      holidayDate: holidayDate == null
          ? null
          : DateTime(holidayDate!.year, holidayDate!.month, holidayDate!.day),
      holidayName: holidayName,
    );
  }
}

extension LoginPersonHolidayEntityToApiX on LoginPersonHolidayEntity {
  OrganizationHoliday toApiModel() {
    return OrganizationHoliday(
      holidayDate: holidayDate == null
          ? null
          : DateTime(holidayDate!.year, holidayDate!.month, holidayDate!.day),
      holidayName: holidayName,
    );
  }
}

/// --- Date helpers (yyyy-MM-dd) ---
String? _dateOnly(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

/// Create a stable primary key from the date (and optional org/person scopes if you add later)
String _holidayIdFromDate(DateTime? d) => _dateOnly(d) ?? 'HOL-UNKNOWN';

extension LookupEntityDomain on LookupEntity {
  LookupValues toDomain() => LookupValues(
        id: id,
        code: code,
        displayName: displayName,
        description: description,
        lookupType: lookupType,
        sortOrder: sortOrder,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}

extension LookupEntityMapper on LookupValues {
  LookupEntity toEntity() => LookupEntity(
        id: id,
        code: code,
        displayName: displayName,
        description: description,
        lookupType: lookupType,
        sortOrder: sortOrder,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}

/// ------------------ ENTITY -> DOMAIN ------------------
extension OfflineWorkOrderEntityX on OfflineWorkOrderEntity {
  OfflineWorkOrder toDomain() => OfflineWorkOrder(
        id: id,
        operatorId: operatorId,
        operatorName: operatorName,
        operatorPhoneNumber: operatorPhoneNumber,
        reporterId: reporterId,
        reporterName: reporterName,
        reporterPhoneNumber: reporterPhoneNumber,
        type: type,
        priority: priority,
        status: status,
        title: title,
        description: description,
        remark: remark,
        scheduledStart: DateTime.parse(scheduledStart),
        scheduledEnd: DateTime.parse(scheduledEnd),
        assetId: assetId,
        plantId: plantId,
        departmentId: departmentId,
        issueTypeId: issueTypeId,
        impactId: impactId,
        shiftId: shiftId,
        mediaFiles: (jsonDecode(mediaFilesJson) as List<dynamic>)
            .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(createdAt),
        synced: synced == "true",
      );
}

/// ------------------ DOMAIN -> ENTITY ------------------
extension OfflineWorkOrderDomainX on OfflineWorkOrder {
  OfflineWorkOrderEntity toEntity() => OfflineWorkOrderEntity(
        id: id,
        operatorId: operatorId,
        operatorName: operatorName,
        operatorPhoneNumber: operatorPhoneNumber,
        reporterId: reporterId,
        reporterName: reporterName,
        reporterPhoneNumber: reporterPhoneNumber,
        type: type,
        priority: priority,
        status: status,
        title: title,
        description: description,
        remark: remark,
        scheduledStart: scheduledStart.toIso8601String(),
        scheduledEnd: scheduledEnd.toIso8601String(),
        assetId: assetId,
        plantId: plantId,
        departmentId: departmentId,
        issueTypeId: issueTypeId,
        impactId: impactId,
        shiftId: shiftId,
        mediaFilesJson: jsonEncode(mediaFiles
            .map((m) => m.toJson())
            .toList()), // ✅ proper serialization
        createdAt: createdAt.toIso8601String(),
        synced: synced ? "true" : "false",
      );
}

/// ------------------ DOMAIN -> API REQUEST ------------------
extension OfflineWorkOrderApiMapper on OfflineWorkOrder {
  CreateWorkOrderRequest toApiRequest() {
    return CreateWorkOrderRequest(
      operatorId: operatorId,
      operatorName: operatorName,
      operatorPhoneNumber: operatorPhoneNumber,
      reporterById: reporterId,
      reporterName: reporterName,
      reporterPhoneNumber: reporterPhoneNumber,

      type: WorkType.values.byName(type),
      priority: PriorityX.fromApi(priority),
      status: WorkStatus.values.byName(status),
      title: title,
      description: description,
      remark: remark,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      assetId: assetId,
      plantId: plantId,
      departmentId: departmentId,
      issueTypeId: issueTypeId,
      impactId: impactId,
      shiftId: shiftId,
      mediaFiles: mediaFiles, // ✅ keep your MediaFile list for API
    );
  }
}

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

extension ShiftEntityDomainX on ShiftEntity {
  Shift toDomain() => Shift(
        id: id,
        name: name,
        description: description ?? '',
        startTime: startTime,
        endTime: endTime,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}

extension ShiftDomainEntityX on Shift {
  ShiftEntity toEntity() => ShiftEntity(
        id: id,
        name: name,
        description:
            description, // entity allows nullable; your model has non-null
        startTime: startTime,
        endTime: endTime,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}

extension UserSummaryToEntity on UserSummary {
  UserListEntity toEntity() => UserListEntity(
        id: id,
        email: email,
        communicationEmail: communicationEmail,
        passwordHash: passwordHash,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        userType: userType,
        recordStatus: recordStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        tenantId: tenantId,
        tenantName: tenantName,
        clientId: clientId,
        clientName: clientName,
        orgId: orgId,
        orgName: orgName,
      );
}

extension UserEntityToSummary on UserListEntity {
  UserSummary toDomain() => UserSummary(
        id: id,
        email: email,
        communicationEmail: communicationEmail,
        passwordHash: passwordHash,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        userType: userType,
        recordStatus: recordStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        tenantId: tenantId,
        tenantName: tenantName,
        clientId: clientId,
        clientName: clientName,
        orgId: orgId,
        orgName: orgName,
      );
}
