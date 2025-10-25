// start_work_page.dart
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/utils/utils.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/WorkTabsController.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// ───────────────────────── Controller ─────────────────────────
class MaintenanceEnginnerStartWorkSubmitController extends GetxController {
  // Work-order info (normally injected)
  final String woTitle = 'Conveyor Belt Stopped Abruptly During Operation';
  final String priority = 'High';
  final String status = 'In Progress';
  final String code = 'BD-102';
  final String time = '18:08';
  final String date = '09 Aug';
  final String department = 'Mechanical';
  final String eta = '1h 20m';

  // Form state
  final TextEditingController estimateCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  final RxString estimate = ''.obs; // “HH:MM” or any text you like
  final RxString remarks = ''.obs;
  final RxBool isSubmitting = false.obs;
  WorkOrders? workOrderInfo;

  @override
  void onInit() {
    super.onInit();
    estimate.value = estimateCtrl.text;
    remarks.value = remarksCtrl.text;

    final workTabsController =
        Get.find<MaintenanceEngineerWorkTabsController>();
    if (workTabsController.workOrder == null) {
      workOrderInfo = getWorkOrderFromArgs(Get.arguments);
    } else {
      workOrderInfo = workTabsController.workOrder;
    }
  }

  @override
  void onClose() {
    estimateCtrl.dispose();
    remarksCtrl.dispose();
    super.onClose();
  }

  Future<void> pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final t = await showTimePicker(context: context, initialTime: now);
    if (t != null) {
      final hh = t.hour.toString().padLeft(2, '0');
      final mm = t.minute.toString().padLeft(2, '0');
      final v = '$hh:$mm';
      estimateCtrl.text = v;
      estimate.value = v;
      HapticFeedback.selectionClick();
    }
  }

  void onDiscard() => Get.back();

  /// Fake API call
  Future<void> onSubmit() async {
    if (estimate.value.trim().isEmpty) {
      Get.snackbar(
        'Missing time',
        'Please enter estimated time to fix',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // simulate network
      Get.snackbar(
        'Work Started',
        'Estimated: ${estimate.value}${remarks.value.isNotEmpty ? '\nRemarks: ${remarks.value}' : ''}',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      Get.toNamed(
        Routes.maintenanceEngeneerdiagnosticsScreen,
        arguments: {
          Constant.workOrderInfo: workOrderInfo,
          Constant.workOrderStatus: WorkOrderStatus.open,
        },
      );
      //Get.back(); // close page
    } catch (_) {
      Get.snackbar(
        'Failed',
        'Please try again',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
