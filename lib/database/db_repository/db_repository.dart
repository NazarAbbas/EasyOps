// lib/database/db_repository/asset_repository.dart
import 'dart:convert';

import 'package:easy_ops/database/entity/user_list_entity.dart';
import 'package:easy_ops/database/mappers/mappers.dart';
import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/organization_data.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart';
import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/database/entity/operators_details_entity.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
// lib/database/db_repository/shift_repository.dart
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/database/entity/shift_entity.dart';

import '../../features/production_manager_features/work_order_management/create_work_order/models/get_plants_org.dart';
import '../entity/get_plants_org_entity.dart';

class DBRepository {
  final AppDatabase db = Get.find<AppDatabase>();

  //Assets Repository
  Future<List<AssetItem>> getAllAssets() async {
    final List<AssetEntity> rows = await db.assetDao.getAllAssets();
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<AssetItem?> getAsset(String serialNo) async {
    final AssetEntity? row = await db.assetDao.getAsset(serialNo);
    return row?.toDomain();
  }

  Future<void> upsertAssetData(AssetsData apiPage) async {
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await db.assetDao.upsertAll(entities);
    }
  }

  // PlantsOrg Repository - UPDATED with correct fields
  Future<List<PlantsOrgItem>> getAllPlants() async {
    final List<PlantsOrgEntity> rows = await db.plantsOrgDao.getAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<List<PlantsOrgItem>> getActivePlants() async {
    final List<PlantsOrgEntity> rows = await db.plantsOrgDao.getActivePlants();
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<List<PlantsOrgItem>> getPlantsByTenant(String tenantId) async {
    final List<PlantsOrgEntity> rows =
    await db.plantsOrgDao.getActiveByTenant(tenantId);
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<List<PlantsOrgItem>> getPlantsByClient(String clientId) async {
    final List<PlantsOrgEntity> rows =
    await db.plantsOrgDao.getActiveByClient(clientId);
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<PlantsOrgItem?> getPlantById(String id) async {
    final PlantsOrgEntity? row = await db.plantsOrgDao.getById(id);
    return row?.toDomain();
  }

  // plantsorg - UPDATED with correct mapping
  Future<void> upsertPlantsOrgData(PlantsOrgData apiPage) async {
    final entities = apiPage.content.map((e) => PlantsOrgEntity.fromDomain(e)).toList();
    if (entities.isNotEmpty) {
      await db.plantsOrgDao.upsertAll(entities);
    }
  }


  // End Assets Repository

  /// Save or update person details + related contacts + attendance in local DB
  Future<void> upsertLoginPersonDetails(LoginPersonDetails model) async {
    final personEntity = model.toEntity();
    final contactEntities = model.contacts.map((c) => c.toEntity()).toList();
    final attendanceEntities =
        model.attendance.map((a) => a.toEntity()).toList();

    final assetsEntities = model.assets.map((c) => c.toEntity()).toList();
    final holdaysEntities =
        model.organizationHolidays.map((c) => c.toEntity()).toList();

    // Floor doesn't support direct manual transaction() calls.
    // Instead, we ensure ordering manually or use @transaction in a DAO.
    await db.loginPersonDao.upsertPerson(personEntity);

    if (contactEntities.isNotEmpty) {
      await db.loginPersonContactDao.deleteContactsForPerson(model.id);
      await db.loginPersonContactDao.upsertContacts(contactEntities);
    }

    if (attendanceEntities.isNotEmpty) {
      await db.loginPersonAttendanceDao.deleteAttendanceForPerson(model.id);
      await db.loginPersonAttendanceDao.upsertAttendance(attendanceEntities);
    }

    if (assetsEntities.isNotEmpty) {
      await db.loginPersonAssetDao.deleteAssetForPerson(model.id);
      await db.loginPersonAssetDao.upsertAssets(assetsEntities);
    }

    if (assetsEntities.isNotEmpty) {
      await db.loginPersonAssetDao.deleteAssetForPerson(model.id);
      await db.loginPersonAssetDao.upsertAssets(assetsEntities);
    }

    if (holdaysEntities.isNotEmpty) {
      await db.loginPersonHolidaysDao.deleteAllHolidays();
      await db.loginPersonHolidaysDao.upsertPersonHolidays(holdaysEntities);
    }
  }

  /// Fetch a single person by ID (with related contacts & attendance)
  Future<LoginPersonDetails?> getPersonById(String id) async {
    final personRow = await db.loginPersonDao.findById(id);
    if (personRow == null) return null;

    final contacts = await db.loginPersonContactDao.getContactsForPerson(id);
    final attendance =
        await db.loginPersonAttendanceDao.getAttendanceForPerson(id);
    final assets = await db.loginPersonAssetDao.getAssetForPerson(id);
    final organizationHolidays =
        await db.loginPersonHolidaysDao.getAllHolidays();

    return LoginPersonDetails(
      id: personRow.id,
      name: personRow.name,
      userPhone: personRow.userPhone,
      dob: personRow.dob != null ? DateTime.parse(personRow.dob!) : null,
      bloodGroup: personRow.bloodGroup,
      designation: personRow.designation,
      type: personRow.type,
      recordStatus: personRow.recordStatus,
      updatedAt: DateTime.parse(personRow.updatedAt),
      userId: personRow.userId,
      userEmail: personRow.userEmail,
      organizationId: personRow.organizationId,
      organizationName: personRow.organizationName,
      departmentId: personRow.departmentId,
      departmentName: personRow.departmentName,
      managerId: personRow.managerId,
      managerName: personRow.managerName,
      managerContact: personRow.managerContact,
      shiftId: personRow.shiftId,
      shiftName: personRow.shiftName,
      contacts: contacts
          .map((e) => LoginPersonContact(
                id: e.id,
                label: e.label,
                relationship: e.relationship,
                phone: e.phone,
                email: e.email,
                recordStatus: e.recordStatus,
                updatedAt: DateTime.parse(e.updatedAt),
                personId: e.personId,
                personName: e.personName,
                name: e.name,
              ))
          .toList(),
      assets: assets
          .map((e) => LoginPersonAsset(
                id: e.id,
                recordStatus: e.recordStatus,
                createdAt: _parseDateTime(e.createdAt), // already DateTime?
                personId: e.personId,
                personName: e.personName,
                assetId: e.assetId,
                assetName: e.assetName,
                assetSerialNumber: e.assetSerialNumber,
              ))
          .toList(), // assets can be handled later
      attendance: attendance
          .map((e) => LoginPersonAttendance(
                id: e.id,
                attDate: DateTime.parse(e.attDate),
                checkIn: e.checkIn != null ? DateTime.parse(e.checkIn!) : null,
                checkOut:
                    e.checkOut != null ? DateTime.parse(e.checkOut!) : null,
                remarks: e.remarks,
                status: e.status,
                recordStatus: e.recordStatus,
                updatedAt: DateTime.parse(e.updatedAt),
                personId: e.personId,
                personName: e.personName,
                shiftId: e.shiftId,
                shiftName: e.shiftName,
              ))
          .toList(),
      // Map DB holidays -> domain model holidays
      organizationHolidays: organizationHolidays
          .map(
            (h) => OrganizationHoliday(
              holidayDate:
                  h.holidayDate, // already DateTime? thanks to converter
              holidayName: h.holidayName,
            ),
          )
          .toList(),
    );
  }

  DateTime? _parseDateTime(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  Future<List<LookupValues>> getLookupByType(LookupType type) async {
    final List<LookupEntity> rows = await db.lookupDao.getActiveByType(type);
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<List<LookupValues>> getActiveByCode(String code) async {
    final List<LookupEntity> rows = await db.lookupDao.getActiveByCode(code);
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<List<LookupValues>> getAll() async {
    final List<LookupEntity> rows = await db.lookupDao.getAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  // --- Helpers ---------------------------------------------------------------

  Map<String, dynamic> _entityToMap(LookupEntity e) {
    // Prefer a real toJson() if present
    try {
      final dynamic json = (e as dynamic).toJson();
      if (json is Map<String, dynamic>) return json;
    } catch (_) {/* ignore */}
    // Fallback: build a minimal map with common fields
    final typeName = () {
      try {
        return (e.lookupType as dynamic).name ?? e.lookupType.toString();
      } catch (_) {
        return e.lookupType.toString();
      }
    }();
    return <String, dynamic>{
      'id': _safe(() => e.id),
      'lookupType': typeName,
      'recordStatus': _safe(() => e.recordStatus),
      'sortOrder': _safe(() => e.sortOrder),
      // add other known fields here if you want them in logs:
      // 'code': e.code,
      // 'displayName': e.displayName,
    };
  }

  T? _safe<T>(T Function() f) {
    try {
      return f();
    } catch (_) {
      return null;
    }
  }

  /// Pretty-encode then print in chunks so logs aren't truncated.
  void _debugPrintJson(Object obj, {String label = 'rows'}) {
    final pretty = const JsonEncoder.withIndent('  ').convert(obj);
    if (!kDebugMode) return;

    const chunk = 800;
    debugPrint('[$label JSON]');
    for (var i = 0; i < pretty.length; i += chunk) {
      debugPrint(pretty.substring(i, (i + chunk).clamp(0, pretty.length)));
    }
  }

// --- Your function ---------------------------------------------------------

  Future<List<LookupValues>> getLookupByCode(String code) async {
    final rows = await db.lookupDao.getAll();

    // 🔎 Print ALL rows once, as JSON
    _debugPrintJson(rows.map(_entityToMap).toList(), label: 'lookup_rows');

    // Filter (case-insensitive)
    final codeUpper = code.toUpperCase();
    final filtered = rows.where((e) {
      final typeName = e.lookupType; // or e.lookupType if it's already String
      return typeName.toUpperCase() == codeUpper &&
          _safe(() => e.recordStatus) == 1;
    }).toList();

    // (Optional) also print filtered as JSON
    _debugPrintJson(filtered.map(_entityToMap).toList(),
        label: 'filtered_rows');

    return filtered.map((e) => e.toDomain()).toList();
  }

  Future<void> upsertLookupData(LookupData apiPage) async {
    final dao = db.lookupDao;
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await dao.upsertAll(entities);
    }
  }

  /// Get all persons (domain models) sorted by name
  Future<List<OperatosDetails>> getAllOperator() async {
    final List<OperatorsDetailsEntity> rows =
        await db.operatorsDetailsDao.findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  /// Upsert all rows from the API page response.
  /// Keep it side-effect free (no pruning) just like your LookupRepository.
  Future<void> upsertOperators(OperatorsDetailsResponse apiPage) async {
    final dao = db.operatorsDetailsDao;
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await dao.upsertAll(entities);
    }
  }

  Future<void> upsertAllShift(ShiftData apiPage) async {
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await db.shiftDao.upsertAllShift(entities);
    }
  }

  Future<List<Shift>> getAllShift() async {
    final List<ShiftEntity> rows = await db.shiftDao.getAllShift();
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<void> upsertAllUsers(UsersResponse resp) async {
    final entities = resp.content.map((e) => e.toEntity()).toList();
    await db.userListDao.upsertUsers(entities);
  }

  Future<List<UserSummary>> getAllUsers() async {
    final List<UserListEntity> rows = await db.userListDao.getAllUsers();
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<void> upsertAllOrganization(List<Organization> list) async {
    final rows = list.map((e) => e.toEntity()).toList();
    await db.organizationDao.upsertAll(rows);
  }

  Future<List<Organization>> getAllOrganization() async =>
      (await db.organizationDao.getAll()).map((e) => e.toDomain()).toList();
}
