// lib/database/dao/asset_dao.dart
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class AssetDao {
  // Simple replace upsert (DELETE+INSERT under the hood)
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAll(List<AssetEntity> items);

  @Query('''
    SELECT * FROM assets
    WHERE recordStatus = 1
    ORDER BY name
  ''')
  Future<List<AssetEntity>> getAllAssets();
}
