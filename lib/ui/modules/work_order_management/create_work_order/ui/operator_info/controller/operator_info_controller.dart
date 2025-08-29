import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoController extends GetxController {
  // Tabs
  final tabs = const ['Work Order Info', 'Operator Info', 'M/C History'];
  final selectedTab = 1.obs; // Operator Info selected

  // Reporter
  final reporterCtrl = TextEditingController();
  final employeeId = '-'.obs;
  final phoneNumber = '-'.obs;

  // Location & Shift
  final locations = ['Line 1', 'Line 2', 'Line 3'];
  final plants = ['Plant A', 'Plant B', 'Plant C'];
  final shifts = ['A', 'B', 'C'];

  final location = RxnString();
  final plant = RxnString();
  final shift = RxnString();

  final reportedTime = Rxn<TimeOfDay>();
  final reportedDate = Rxn<DateTime>();

  // Operator
  final sameAsReporter = false.obs;

  @override
  void onClose() {
    reporterCtrl.dispose();
    super.onClose();
  }
}
