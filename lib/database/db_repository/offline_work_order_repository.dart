// lib/features/work_order_management/create_work_order/repository/offline_work_order_repository.dart

import 'package:easy_ops/database/app_database.dart';
import 'package:easy_ops/database/mappers/offline_workorder_mappers.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/domain/create_work_order_repository_impl.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/offline_work_order.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OfflineWorkOrderRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final CreateWorkOrderRepositoryImpl apiRepo = CreateWorkOrderRepositoryImpl();

  /// Insert locally when offline
  Future<void> insertOfflineOrder(OfflineWorkOrder model) async {
    await db.offlineWorkOrderDao.insertWorkOrder(model.toEntity());
  }

  /// Fetch all unsynced offline work orders
  Future<List<OfflineWorkOrder>> getUnsyncedOrders() async {
    final rows = await db.offlineWorkOrderDao.getUnsynced();
    return rows.map((e) => e.toDomain()).toList();
  }

  /// Delete order from local DB
  Future<void> deleteOrder(OfflineWorkOrder model) async {
    await db.offlineWorkOrderDao.deleteWorkOrder(model.toEntity());
  }

  /// Sync unsynced offline work orders with server, then delete them
  Future<void> syncWithServer() async {
    final unsynced = await getUnsyncedOrders();

    if (unsynced.isEmpty) {
      if (kDebugMode) {
        print("📭 No unsynced work orders to sync.");
      }
      return;
    }

    print("🔁 Found ${unsynced.length} offline work orders to sync...");

    for (final order in unsynced) {
      try {
        final req = order.toApiRequest(); // Convert to API request format
        final res = await apiRepo.createWorkOrderRequest(req);

        if (res.httpCode == 201 && res.data != null) {
          // ✅ Successfully synced with server
          await deleteOrder(order);
          if (kDebugMode) {
            print("✅ Synced and deleted local order id=${order.id}");
          }
        } else {
          if (kDebugMode) {
            print("⚠️ Failed to sync order id=${order.id}, will retry later");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("❌ Sync error for order id=${order.id} -> $e");
        }
      }
    }
  }
}
