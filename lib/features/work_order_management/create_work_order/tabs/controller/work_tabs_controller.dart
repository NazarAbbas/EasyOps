import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class WorkTabsController extends GetxController {
  final tabs = const ['Work Order Info', 'Operator Info', 'M/C History'];
  final selectedTab = 0.obs; // 0 = WorkOrderPage (default)
  void goTo(int i) => selectedTab.value = i;

  WorkOrder? workOrder = null;
  WorkOrderStatus? workOrderStatus = null;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null) {
      if (kDebugMode) {
        print("⚠️ No arguments passed to WorkTabsController");
      }
      return;
    }

    // ✅ Expect a Map of arguments
    final map = args as Map;

    workOrder = map[Constant.workOrderInfo] as WorkOrder;
    workOrderStatus = map[Constant.workOrderStatus] as WorkOrderStatus;
  }
}
