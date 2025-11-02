// lib/database/dao/organization_dao.dart
import 'package:easy_ops/database/entity/organizations_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class OrganizationDao {
  // Upsert many
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAll(List<OrganizationEntity> rows);

  @Query('SELECT * FROM organizations ORDER BY displayName')
  Future<List<OrganizationEntity>> getAll();
}
