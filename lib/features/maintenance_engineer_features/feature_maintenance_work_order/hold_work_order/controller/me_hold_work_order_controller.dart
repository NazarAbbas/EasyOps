// hold_work_order_page.dart;
import 'package:easy_ops/core/network/network_repository/network_repository.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_repository_impl.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';

/// ───────────────────────── Controller ─────────────────────────
class MEHoldWorkOrderController extends GetxController {
  // Work order info (normally injected)

  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();
  final RxList<LookupValues> reason = <LookupValues>[].obs;

  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  // Context (top middle card)
  final RxString holdContextTitle = 'Need Hydra'.obs;
  final RxString holdContextCategory = 'Assets Availability'.obs;
  final RxString holdContextDesc =
      'Live offline shoulder see gave group like loop. Container.'.obs;

  // Form state
  final TextEditingController reasonTitleCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();
  final RxString reasonTitle = ''.obs;

  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select Reason'.obs;

  final RxList<String> reasonTypes = <String>[
    'Assets Availability/ Manpower/spare/skill',
    'Safety/Permit Pending',
    'Process Dependency',
    'Awaiting Vendor',
    'Other',
  ].obs;
  final RxString selectedReasonType = ''.obs;

  final RxString remarks = ''.obs;

  // submit state
  final RxBool isSubmitting = false.obs;

  WorkOrder? workOrderInfo;

  @override
  void onInit() {
    super.onInit();
    final tabs = Get.find<UpdateWorkTabsController>();
    workOrderInfo = tabs.workOrder;
    selectedReasonType.value = reasonTypes.first;
  }

  @override
  void onClose() {
    reasonTitleCtrl.dispose();
    remarksCtrl.dispose();
    super.onClose();
  }

  Future<void> onEditContext(BuildContext context) async {
    // tiny inline editor (title + desc)
    final titleTemp = TextEditingController(text: holdContextTitle.value);
    final descTemp = TextEditingController(text: holdContextDesc.value);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Hold Context'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleTemp,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descTemp,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              holdContextTitle.value = titleTemp.text.trim().isEmpty
                  ? holdContextTitle.value
                  : titleTemp.text.trim();
              holdContextDesc.value = descTemp.text.trim();
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void onDiscard() => Get.back();

  Future<void> onHold() async {
    if (_isPlaceholder(selectedReason.value)) {
      Get.snackbar(
        'Reason required',
        'Please select a reason to hold this work order.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    final woId = workOrderInfo?.id ?? '';
    if (woId.isEmpty) {
      Get.snackbar(
        'Missing ID',
        'Work order ID not found.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // Build request (map the reason as needed: id/code/displayName)
      final sel = selectedReason.value!;
      final req = CancelWorkOrderRequest(
        status: 'Hold',
        remark: remarksCtrl.text.trim(),
        comment: sel.displayName, // or sel.id / sel.code per API contract
      );

      final result = await repositoryImpl.cancelOrder(
        cancelWorkOrderId: woId,
        cancelWorkOrderRequest: req,
      );

      if (result.httpCode == 200 && result.data != null) {
        Get.snackbar(
          'Cancelled',
          'Work order cancelled successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black87,
          margin: const EdgeInsets.all(12),
        );
        Get.offAllNamed(
          Routes.landingDashboardScreen,
          arguments: {'tab': 3},
        );
      } else {
        Get.snackbar(
          'Cancel failed',
          (result.message?.trim().isNotEmpty ?? false)
              ? result.message!
              : 'Unexpected response (code ${result.httpCode}).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.black87,
          margin: const EdgeInsets.all(12),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      // isSubmitting.value = false;
    }
  }

  // /// Fake API call
  // Future<void> onHold() async {
  //   if (!canSubmit) {
  //     Get.snackbar(
  //       'Missing details',
  //       'Please add Hold Reason Title',
  //       snackPosition: SnackPosition.BOTTOM,
  //       margin: const EdgeInsets.all(12),
  //     );
  //     return;
  //   }

  //   isSubmitting.value = true;
  //   try {
  //     await Future.delayed(const Duration(seconds: 2)); // simulate network
  //     Get.snackbar(
  //       'Work Order On Hold',
  //       'Title: ${reasonTitle.value}\nType: ${selectedReasonType.value}'
  //           '${remarks.value.isNotEmpty ? '\nRemarks: ${remarks.value}' : ''}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       margin: const EdgeInsets.all(12),
  //     );
  //     // Get.back(); // close page
  //     Get.offAllNamed(
  //       Routes.maintenanceEngeneerlandingDashboardScreen,
  //       arguments: {'tab': 3}, // open Work Orders
  //     );
  //   } catch (_) {
  //     Get.snackbar(
  //       'Failed',
  //       'Could not put on hold. Try again.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       margin: const EdgeInsets.all(12),
  //       backgroundColor: Colors.red.shade50,
  //       colorText: Colors.red.shade700,
  //     );
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }
}
