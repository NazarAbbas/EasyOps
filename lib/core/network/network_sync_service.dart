import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_ops/database/db_repository/offline_work_order_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NetworkSyncService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final _isConnected = false.obs;

  late final OfflineWorkOrderRepository _offlineRepo;

  @override
  void onInit() {
    super.onInit();
    _offlineRepo = Get.find<OfflineWorkOrderRepository>();
    _initConnectivityListener();
  }

  /// Initialize connectivity listener and perform an initial check
  void _initConnectivityListener() async {
    // ✅ New API: returns List<ConnectivityResult>
    final initialStatuses = await _connectivity.checkConnectivity();
    final initialStatus = initialStatuses.isNotEmpty
        ? initialStatuses.first
        : ConnectivityResult.none;

    _handleConnectivityChange(initialStatus);

    // ✅ The stream now returns List<ConnectivityResult>
    _connectivity.onConnectivityChanged.listen((statusList) {
      final status =
          statusList.isNotEmpty ? statusList.first : ConnectivityResult.none;
      _handleConnectivityChange(status);
    });
  }

  /// Handle connectivity transitions
  void _handleConnectivityChange(ConnectivityResult status) async {
    final nowConnected = status != ConnectivityResult.none;

    if (nowConnected && !_isConnected.value) {
      _isConnected.value = true;
      if (kDebugMode) {
        print("[NetworkSync] 🌐 Connection restored → syncing offline data...");
      }
      await _syncOfflineCreateOrders();
    } else if (!nowConnected && _isConnected.value) {
      _isConnected.value = false;
      if (kDebugMode) {
        print("[NetworkSync] 🚫 Network lost → offline mode active.");
      }
    }
  }

  /// Sync unsynced work orders via repository
  Future<void> _syncOfflineCreateOrders() async {
    try {
      final unsynced = await _offlineRepo.getUnsyncedOrders();
      if (unsynced.isEmpty) {
        if (kDebugMode) print("[NetworkSync] ✅ No unsynced work orders found.");
        return;
      }

      if (kDebugMode) {
        print("[NetworkSync] Found ${unsynced.length} unsynced work orders.");
      }

      await _offlineRepo.syncWithServer();

      if (kDebugMode) {
        print("[NetworkSync] ✅ All offline work orders synced successfully.");
      }
    } catch (e) {
      if (kDebugMode) print("[NetworkSync] ❌ Error during sync: $e");
    }
  }
}
