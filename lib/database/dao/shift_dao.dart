// lib/database/dao/shift_dao.dart
import 'package:floor/floor.dart';
import 'package:easy_ops/database/entity/shift_entity.dart';

@dao
abstract class ShiftDao {
  /// Simple upsert (DELETE+INSERT on conflict of PK/UNIQUE)
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAllShift(List<ShiftEntity> items);

  /// All active, sorted by name
  @Query('''
    SELECT * FROM shifts
    WHERE recordStatus = 1
    ORDER BY name
  ''')
  Future<List<ShiftEntity>> getAllShift();
}
