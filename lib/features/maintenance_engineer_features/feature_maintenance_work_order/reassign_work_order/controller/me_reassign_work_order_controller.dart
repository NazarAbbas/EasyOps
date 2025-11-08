import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ───────────────────────── Controller ─────────────────────────
class MEReassignWorkOrderController extends GetxController {
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select Reason'.obs;

  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  final TextEditingController remarksCtrl = TextEditingController();
  final RxString remarks = ''.obs;

  /// submitting state
  final RxBool isSubmitting = false.obs;

  /// ⬇️ Make reactive & nullable so UI can guard rendering
  final Rxn<WorkOrders> workOrderInfo = Rxn<WorkOrders>();

  @override
  void onInit() {
    super.onInit();
    remarks.value = remarksCtrl.text;
  }

  @override
  Future<void> onReady() async {
    final wo = await SharePreferences.getObject(
      Constant.workOrder,
      WorkOrders.fromJson,
    );
    workOrderInfo.value = wo; // triggers UI update
    super.onReady();
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

    final woId = workOrderInfo.value?.id ?? '';
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
          'Reassigned',
          'Work order reassigned successfully.',
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
          'Reassign failed',
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
      isSubmitting.value = false; // ✅ always reset
    }
  }
}
