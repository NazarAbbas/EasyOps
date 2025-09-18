// cancel_work_order_page.dart
// deps: get: ^4.x

import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* ───────── Model (optional) ───────── */
class AssetSummary {
  final String code;
  final String make;
  final String description;
  final String status; // e.g., Working
  final String criticality; // e.g., Critical
  AssetSummary({
    required this.code,
    required this.make,
    required this.description,
    required this.status,
    required this.criticality,
  });
}

/* ───────── Controller ───────── */
class CancelWorkOrderController extends GetxController {
  // Example asset (wire your real data)
  final asset = AssetSummary(
    code: 'CNC-1',
    make: 'Siemens',
    description: 'CNC Vertical Assets Center where we make housing',
    status: 'Working',
    criticality: 'Critical',
  ).obs;

  final reasons = <String>[
    'Customer request',
    'Duplicate work order',
    'Wrong asset selected',
    'Planned shutdown',
    'Other',
  ];

  final selectedReason = RxnString();
  final remarksCtrl = TextEditingController();
  final isSubmitting = false.obs;

  void discard() {
    // Clear inputs or simply pop
    selectedReason.value = null;
    remarksCtrl.clear();
    Get.back();
  }

  Future<void> cancelWorkOrder() async {
    final reason = selectedReason.value;
    if (reason == null || reason.isEmpty) {
      Get.snackbar(
        'Reason required',
        'Please select a reason to cancel this work order.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 900));
      //Get.toNamed(Routes.workOrderScreen);
      Get.offAllNamed(
        Routes.landingDashboardScreen,
        arguments: {'tab': 3}, // open Work Orders
      );
      Get.snackbar(
        'Cancelled',
        'Work order cancelled successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel work order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
