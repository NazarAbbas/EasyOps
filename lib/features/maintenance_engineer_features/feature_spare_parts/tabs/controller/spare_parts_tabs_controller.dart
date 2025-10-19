import 'package:get/get.dart';

class MaintenanceEnginnerSparePartsController extends GetxController {
  final tabs = const ['Returns', 'Consumed'];
  final selectedTab = 0.obs; // 0 = WorkOrderPage (default)
  void goTo(int i) => selectedTab.value = i;
}
