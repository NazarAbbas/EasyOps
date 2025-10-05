import 'package:easy_ops/database/entity/offline_work_order_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class OfflineWorkOrderDao {
  @Query('SELECT * FROM offline_workorders WHERE synced = "false"')
  Future<List<OfflineWorkOrderEntity>> getUnsynced();

  @insert
  Future<void> insertWorkOrder(OfflineWorkOrderEntity order);

  @Query('UPDATE offline_workorders SET synced = :status WHERE id = :id')
  Future<void> updateSyncStatus(int id, String status);

  @delete
  Future<void> deleteWorkOrder(OfflineWorkOrderEntity order);
}
