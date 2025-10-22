// lib/database/db_repository/asset_repository.dart
import 'package:easy_ops/database/mappers/mappers.dart';
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

class DBRepository {
  final AppDatabase db = Get.find<AppDatabase>();

  //Assets Repository
  Future<List<AssetItem>> getAllAssets() async {
    final List<AssetEntity> rows = await db.assetDao.getAllAssets();
    return rows.map((e) => e.toDomain()).toList();
  }

  Future<void> upsertAssetData(AssetsData apiPage) async {
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await db.assetDao.upsertAll(entities);
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
}
