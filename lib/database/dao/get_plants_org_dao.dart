// lib/database/dao/plants_org_dao.dart
import 'package:floor/floor.dart';
import '../entity/get_plants_org_entity.dart';

@dao
abstract class PlantsOrgDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAll(List<PlantsOrgEntity> rows);

  @Query('''
    SELECT * FROM plants_org 
    WHERE recordStatus = 1 
    ORDER BY displayName
  ''')
  Future<List<PlantsOrgEntity>> getActivePlants();

  @Query('''
    SELECT * FROM plants_org 
    WHERE tenantId = :tenantId 
      AND recordStatus = 1 
    ORDER BY displayName
  ''')
  Future<List<PlantsOrgEntity>> getActiveByTenant(String tenantId);

  @Query('''
    SELECT * FROM plants_org 
    WHERE clientId = :clientId 
      AND recordStatus = 1 
    ORDER BY displayName
  ''')
  Future<List<PlantsOrgEntity>> getActiveByClient(String clientId);


  @Query('''
    SELECT * FROM plants_org 
    WHERE parentOrgId = :parentOrgId 
    ORDER BY displayName
  ''')
  Future<List<PlantsOrgEntity>> getAllByParentOrgID(String parentOrgId);

  @Query('SELECT * FROM plants_org ORDER BY displayName')
  Future<List<PlantsOrgEntity>> getAll();

  @Query('SELECT * FROM plants_org WHERE id = :id')
  Future<PlantsOrgEntity?> getById(String id);

  @Query('SELECT * FROM plants_org WHERE displayName LIKE :searchTerm AND recordStatus = 1')
  Future<List<PlantsOrgEntity>> searchPlants(String searchTerm);

  @Query('DELETE FROM plants_org WHERE id = :id')
  Future<void> deletePlant(String id);

  @Query('DELETE FROM plants_org')
  Future<void> deleteAll();
}