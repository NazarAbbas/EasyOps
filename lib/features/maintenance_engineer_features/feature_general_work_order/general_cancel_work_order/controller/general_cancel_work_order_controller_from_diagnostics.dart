import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_repository_impl.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/domain/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerGeneralCancelWorkOrderController
    extends GetxController {
  final CancelRepositoryImpl repositoryImpl = CancelRepositoryImpl();
  final LookupRepository lookupRepository = Get.find<LookupRepository>();

  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  final TextEditingController remarksCtrl = TextEditingController();
  final RxString remarks = ''.obs;

  // submitting state
  final RxBool isSubmitting = false.obs;

  // Example payload for the card (normally injected)
  final RxString woTitle = ''.obs;
  final RxString priority = ''.obs;
  final RxString status = ''.obs; //'In Progress';
  final RxString issueNo = ''.obs; // 'BD-102';
  final RxString time = ''.obs; //'18:08';
  final RxString date = ''.obs; //'09 Aug';
  final RxString department = ''.obs; // 'Mechanical';
  final RxString estimateTimeToFix = ''.obs; //'1h 20m';

  WorkOrder? workOrderInfo;

  @override
  void onInit() async {
    super.onInit();
    final workTabsController = Get.find<UpdateWorkTabsController>();
    workOrderInfo = workTabsController.workOrder!;

    woTitle.value = workOrderInfo!.title;
    priority.value = workOrderInfo!.priority;
    status.value = workOrderInfo!.status;
    issueNo.value = workOrderInfo!.issueNo;
    date.value = _formatDate(workOrderInfo!.createdAt);
    estimateTimeToFix.value = workOrderInfo!.estimatedTimeToFix;
    department.value = workOrderInfo!.departmentName;
    remarks.value = remarksCtrl.text;

    final list = await lookupRepository.getLookupByType(LookupType.resolution);

    // Placeholder + server list
    final placeholder = LookupValues(
      id: '',
      code: '',
      displayName: 'Select reason',
      description: '',
      lookupType: LookupType.department,
      sortOrder: -1,
      recordStatus: 1,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      clientId: '',
    );

    reason.assignAll([placeholder, ...list]);
    selectedReason.value = placeholder;
  }

  @override
  void onClose() {
    remarksCtrl.dispose();
    super.onClose();
  }

  void onDiscard() => Get.back();

  Future<void> onReassign() async {
    if (_isPlaceholder(selectedReason.value)) {
      Get.snackbar(
        'Reason required',
        'Please select a reason to reassign this work order.',
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
        status: 'Reassign',
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
          'Work order reassign successfully.',
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
      isSubmitting.value = false;
    }
  }

  // Future<void> cancelWorkOrder() async {
  //   if (_isPlaceholder(selectedReason.value)) {
  //     Get.snackbar(
  //       'Reason required',
  //       'Please select a reason to cancel this work order.',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       margin: const EdgeInsets.all(12),
  //     );
  //     return;
  //   }

  //   final woId = workOrderInfo?.id ?? '';
  //   if (woId.isEmpty) {
  //     Get.snackbar(
  //       'Missing ID',
  //       'Work order ID not found.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red.shade100,
  //       colorText: Colors.black87,
  //       margin: const EdgeInsets.all(12),
  //     );
  //     return;
  //   }

  //   try {
  //     isSubmitting.value = true;

  //     // Build request (map the reason as needed: id/code/displayName)
  //     final sel = selectedReason.value!;
  //     final req = CancelWorkOrderRequest(
  //       status: 'Cancel',
  //       remark: remarksCtrl.text.trim(),
  //       comment: sel.displayName, // or sel.id / sel.code per API contract
  //     );

  //     final result = await cancelRepositoryImpl.cancelOrder(
  //       cancelWorkOrderId: woId,
  //       cancelWorkOrderRequest: req,
  //     );

  //     if (result.httpCode == 200 && result.data != null) {
  //       Get.snackbar(
  //         'Cancelled',
  //         'Work order cancelled successfully.',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green.shade100,
  //         colorText: Colors.black87,
  //         margin: const EdgeInsets.all(12),
  //       );
  //       Get.offAllNamed(
  //         Routes.maintenanceEngeneerlandingDashboardScreen,
  //         arguments: {'tab': 3},
  //       );
  //     } else {
  //       Get.snackbar(
  //         'Cancel failed',
  //         (result.message?.trim().isNotEmpty ?? false)
  //             ? result.message!
  //             : 'Unexpected response (code ${result.httpCode}).',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.orange.shade100,
  //         colorText: Colors.black87,
  //         margin: const EdgeInsets.all(12),
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red.shade100,
  //       colorText: Colors.black87,
  //       margin: const EdgeInsets.all(12),
  //     );
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }

  String _formatDate(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    return '$hh:$mm | $day $month';
  }
}
