// lib/database/db_repository/shift_repository.dart
import 'package:easy_ops/database/mappers/shift_mapper.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:get/get.dart';
import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/entity/shift_entity.dart';

class ShiftRepository {
  final AppDatabase db = Get.find<AppDatabase>();

  Future<void> upsertAllShift(ShiftData apiPage) async {
    final entities = apiPage.content.map((e) => e.toEntity()).toList();
    if (entities.isNotEmpty) {
      await db.shiftDao.upsertAllShift(entities);
    }
  }

  Future<List<Shift>> getAllShift() async {
    final List<ShiftEntity> rows = await db.shiftDao.getAllShift();
    return rows.map((e) => e.toDomain()).toList();
  }
}
