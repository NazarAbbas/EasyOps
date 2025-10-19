// features/staff/tabs/controller/staff_tabs_controller.dart
import 'package:get/get.dart';

class MaintenanceEngineerStaffTabsController extends GetxController {
  final selectedTab = 0.obs;

  void setTab(int i) {
    if (i == selectedTab.value) return;
    selectedTab.value = i;
  }
}
