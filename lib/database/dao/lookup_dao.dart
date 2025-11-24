import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:floor/floor.dart';
import '../../features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
// lib/database/dao/dropdown_dao.dart

@dao
abstract class LookupDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAll(List<LookupEntity> rows);
// lib/database/dao/dropdown_dao.dart

  @Query('''
    SELECT * FROM lookup
    WHERE lookupType = :lookupType
      AND recordStatus = 1
    ORDER BY sortOrder
  ''')
  Future<List<LookupEntity>> getActiveByType(
    LookupType lookupType,
  );

  @Query('''
    SELECT * FROM lookup
    WHERE code = :lookupCode
      AND recordStatus = 1
    ORDER BY sortOrder
  ''')
  Future<List<LookupEntity>> getActiveByCode(
    String lookupCode,
  );

  // 1) All rows (optionally keep ORDER BY)
  @Query('SELECT * FROM lookup ORDER BY sortOrder')
  Future<List<LookupEntity>> getAll();
}
