import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UpdateWorkTabsController extends GetxController {
  final tabs = const ['Work Order', 'History', 'Timeline'];
  final selectedTab = 0.obs; // 0 = WorkOrderInfoPage (default)
  void goTo(int i) => {selectedTab.value = i};

  WorkOrder? workOrder;
  //WorkOrderStatus? workOrderStatus;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null) {
      if (kDebugMode) {
        print("⚠️ No arguments passed to UpdateWorkTabsController");
      }
      return;
    }

    // ✅ Expect a Map of arguments
    final map = args as Map;

    workOrder = map[Constant.workOrderInfo] as WorkOrder;
    //workOrderStatus = map[Constant.workOrderStatus] as WorkOrderStatus;
  }
}
