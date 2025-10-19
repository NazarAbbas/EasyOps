// controller: lib/.../mc_history/controller/mc_history_controller.dart
import 'package:easy_ops/features/production_manager_features/work_order_management/edit_work_order/mc_history/models/edit_history_items.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/edit_work_order/tabs/controller/edit_work_tabs_controller.dart';
import 'package:get/get.dart';

class EditMcHistoryController extends GetxController {
  final items = <EditHistoryItem>[].obs;

  @override
  void onInit() {
    // Load initial data (replace with API call if needed)
    items.assignAll(editSampleHistory);
    super.onInit();
  }

  void goBack(int i) => Get.find<EditWorkTabsController>().goTo(i);
  //void goBack() => Get.back();
}
