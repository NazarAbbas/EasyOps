import 'package:easy_ops/core/network/network_repository/network_repository.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* ───────── Optional: sample model ───────── */
class AssetSummary {
  final String code;
  final String make;
  final String description;
  final String status;
  final String criticality;
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
  final issueTitle = ''.obs;
  final priority = ''.obs;
  final statusText = ''.obs;
  final duration = ''.obs;

  final workOrderId = 'BD-102'.obs;
  final time = ''.obs;
  final category = ''.obs;
  final repository = Get.find<DBRepository>();
  // final LookupRepository lookupRepository = Get.find<LookupRepository>();
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  // Reasons (typed) + selected reason
  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();

  final selectedReasonValue = 'Select Reason'.obs;

  final remarksCtrl = TextEditingController();
  final isSubmitting = false.obs;

  WorkOrders? workOrderInfo;

  // // Optional sample asset
  // final asset = AssetSummary(
  //   code: 'CNC-1',
  //   make: 'Siemens',
  //   description: 'CNC Vertical Assets Center where we make housing',
  //   status: 'Working',
  //   criticality: 'Critical',
  // ).obs;

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

  @override
  void onInit() async {
    super.onInit();
    final workTabsController = Get.find<WorkTabsController>();
    workOrderInfo = workTabsController.workOrder;
    issueTitle.value = workOrderInfo!.title;
    category.value = workOrderInfo!.locationName;
    time.value = _formatDate(workOrderInfo!.createdAt); // as String;
    priority.value = workOrderInfo!.priority;
    duration.value = workOrderInfo!.estimatedTimeToFix;
    statusText.value = workOrderInfo!.status;

    final list = await repository.getLookupByType(LookupType.resolution);

    // Placeholder + server list
    final placeholder = LookupValues(
      id: '',
      code: '',
      displayName: 'Select reason',
      description: '',
      lookupType:
          LookupType.department.name, // keep as-is if your model requires
      sortOrder: -1,
      recordStatus: 1,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      clientId: '',
    );

    reason.assignAll([placeholder, ...list]);
    selectedReason.value = placeholder;
  }

  // @override
  // void onClose() {
  //   remarksCtrl.dispose();
  //   super.onClose();
  // }

  void discard() {
    // selectedReason.value = null;
    remarksCtrl.clear();
    Get.back();
  }

  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  Future<void> cancelWorkOrder() async {
    if (_isPlaceholder(selectedReason.value)) {
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
        status: 'Cancel',
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
          Routes.maintenanceEngeneerlandingDashboardScreen,
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
      //isSubmitting.value = false;
    }
  }
}
