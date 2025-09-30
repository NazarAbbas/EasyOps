// lib/database/db_repository/asset_repository.dart
import 'package:easy_ops/database/mappers/assets_mapper.dart';
import 'package:get/get.dart';
import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';

/// Repository for caching and reading Assets using AssetDao.
class AssetRepository {
  final AppDatabase db = Get.find<AppDatabase>();

  /// DAO filters `recordStatus = 1` and orders by name.
  Future<List<AssetItem>> getAllAssets() async {
    final List<AssetEntity> rows = await db.assetDao.getAllAssets();
    return rows.map((e) => e.toDomain()).toList();
  }

  /// Upsert a whole API page (`AssetsData.content` is List<AssetItem>).
  Future<void> upsertAssetData(AssetsData apiPage) async {
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await db.assetDao.upsertAll(entities);
    }
  }

  // /// (Optional) Upsert a plain list of assets.
  // Future<void> upsertAssets(List<AssetItem> items) async {
  //   final entities = items.map((e) => e.toEntity()).toList();
  //   if (entities.isNotEmpty) {
  //     await db.assetDao.upsertAll(entities);
  //   }
  // }
}
