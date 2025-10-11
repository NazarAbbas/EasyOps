import 'package:easy_ops/database/entity/login_person_details_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class LoginPersonDetailsDao {
  /// Upsert person details
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertPerson(LoginPersonDetailsEntity entity);

  @Query('SELECT * FROM login_person_details WHERE id = :id')
  Future<LoginPersonDetailsEntity?> findById(String id);

  @Query('SELECT * FROM login_person_details')
  Future<List<LoginPersonDetailsEntity>> getAllPersons();

  @Query('DELETE FROM login_person_details')
  Future<void> clearAllPersons();
}

@dao
abstract class LoginPersonContactDao {
  /// Upsert all contacts for a person
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertContacts(List<LoginPersonContactEntity> entities);

  @Query('SELECT * FROM login_person_contact WHERE personId = :personId')
  Future<List<LoginPersonContactEntity>> getContactsForPerson(String personId);

  @Query('DELETE FROM login_person_contact WHERE personId = :personId')
  Future<void> deleteContactsForPerson(String personId);
}

@dao
abstract class LoginPersonAttendanceDao {
  /// Upsert all attendance records for a person
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAttendance(List<LoginPersonAttendanceEntity> entities);

  @Query('SELECT * FROM login_person_attendance WHERE personId = :personId')
  Future<List<LoginPersonAttendanceEntity>> getAttendanceForPerson(
      String personId);

  @Query('DELETE FROM login_person_attendance WHERE personId = :personId')
  Future<void> deleteAttendanceForPerson(String personId);
}
