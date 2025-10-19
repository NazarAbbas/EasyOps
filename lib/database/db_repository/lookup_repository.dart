import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:easy_ops/database/mappers/lookup_mappers.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:get/get.dart';

class LookupRepository {
  final AppDatabase db = Get.find<AppDatabase>();

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
}
