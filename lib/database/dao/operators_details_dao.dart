// lib/features/persons/data/local/person_dao.dart
import 'package:easy_ops/database/entity/operators_details_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class OperatorsDetailsDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAll(List<OperatorsDetailsEntity> items);

  @Query(
      'SELECT * FROM operators_details_entity ORDER BY name COLLATE NOCASE ASC')
  Future<List<OperatorsDetailsEntity>> findAll();
}
