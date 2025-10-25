import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MaintenanceEngineerWorkTabsController extends GetxController {
  WorkOrders? workOrder;
  WorkOrderStatus? workOrderStatus;

  /// Tabs shown in header (keep in sync with body pages below)
  final tabs = const ['Work Order', 'History', 'Timeline'];

  /// 0 = Work Order (default)
  final selectedTab = 0.obs;

  void goTo(int i) {
    if (i < 0) i = 0;
    if (i >= tabs.length) i = tabs.length - 1;
    selectedTab.value = i;
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null) {
      if (kDebugMode) {
        print(
            "⚠️ No arguments passed to MaintenanceEngineerWorkTabsController");
      }
      return;
    }

    // Expecting a Map of arguments with the Constant keys
    try {
      final map = args as Map;
      final wo = map[Constant.workOrderInfo];
      final ws = map[Constant.workOrderStatus];

      if (wo is WorkOrders) workOrder = wo;
      if (ws is WorkOrderStatus) workOrderStatus = ws;
    } catch (e, st) {
      if (kDebugMode) {
        print("⚠️ Failed to parse arguments in WorkTabsController: $e\n$st");
      }
    }
  }
}
