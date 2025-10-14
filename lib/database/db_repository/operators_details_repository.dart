import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/entity/operators_details_entity.dart';
import 'package:easy_ops/database/mappers/operators_details_mapper.dart';
import 'package:easy_ops/features/login/models/operators_details.dart';
import 'package:get/get.dart';

class OperatorDetailsRepository {
  final AppDatabase db = Get.find<AppDatabase>();

  /// Get all persons (domain models) sorted by name
  Future<List<OperatosDetails>> getAllOperator() async {
    final List<OperatorsDetailsEntity> rows =
        await db.operatorsDetailsDao.findAll();
    return rows.map((e) => e.toDomain()).toList();
  }

  /// Upsert all rows from the API page response.
  /// Keep it side-effect free (no pruning) just like your LookupRepository.
  Future<void> upsertOperators(OperatorsDetailsResponse apiPage) async {
    final dao = db.operatorsDetailsDao;
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await dao.upsertAll(entities);
    }
  }
}
