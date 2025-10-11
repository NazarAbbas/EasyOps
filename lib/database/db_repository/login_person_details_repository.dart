import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/features/login/models/login_person_details.dart';
import 'package:get/get.dart';
import 'package:easy_ops/database/mappers/login_person_details_mapper.dart';

class LoginPersonDetailsRepository {
  final AppDatabase _db = Get.find<AppDatabase>();

  /// Save or update person details + related contacts + attendance in local DB
  Future<void> upsertLoginPersonDetails(LoginPersonDetails model) async {
    final personEntity = model.toEntity();
    final contactEntities = model.contacts.map((c) => c.toEntity()).toList();
    final attendanceEntities =
        model.attendance.map((a) => a.toEntity()).toList();

    // Floor doesn't support direct manual transaction() calls.
    // Instead, we ensure ordering manually or use @transaction in a DAO.
    await _db.loginPersonDao.upsertPerson(personEntity);

    if (contactEntities.isNotEmpty) {
      await _db.loginPersonContactDao.deleteContactsForPerson(model.id);
      await _db.loginPersonContactDao.upsertContacts(contactEntities);
    }

    if (attendanceEntities.isNotEmpty) {
      await _db.loginPersonAttendanceDao.deleteAttendanceForPerson(model.id);
      await _db.loginPersonAttendanceDao.upsertAttendance(attendanceEntities);
    }
  }

  /// Fetch a single person by ID (with related contacts & attendance)
  Future<LoginPersonDetails?> getPersonById(String id) async {
    final personRow = await _db.loginPersonDao.findById(id);
    if (personRow == null) return null;

    final contacts = await _db.loginPersonContactDao.getContactsForPerson(id);
    final attendance =
        await _db.loginPersonAttendanceDao.getAttendanceForPerson(id);

    return LoginPersonDetails(
      id: personRow.id,
      name: personRow.name,
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
              ))
          .toList(),
      assets: const [], // assets can be handled later
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
    );
  }

  /// Optional: Fetch all persons stored in DB
  // Future<List<LoginPersonDetails>> getAllPersons() async {
  //   final personRows = await _db.loginPersonDao.getAllPersons();
  //   final List<LoginPersonDetails> result = [];
  //   for (final p in personRows) {
  //     final person = await getPersonById(p.id);
  //     if (person != null) result.add(person);
  //   }
  //   return result;
  // }

  /// Optional: Clear all person-related tables
  // Future<void> clearAll() async {
  //   await _db.loginPersonContactDao.clearAllContacts();
  //   await _db.loginPersonAttendanceDao.clearAllAttendance();
  //   await _db.loginPersonDetailsDao.clearAllPersons();
  // }
}
