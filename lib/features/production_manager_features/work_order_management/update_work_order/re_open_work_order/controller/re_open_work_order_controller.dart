// reopen_work_order_controller.dart
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/domain/reopen_repository_impl.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/models/re_open_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackType { success, error, warning, info }

class ReopenWorkOrderController extends GetxController {
  final ReopenRepositoryImpl reopenRepositoryImpl = ReopenRepositoryImpl();
  final LookupRepository lookupRepository = Get.find<LookupRepository>();

  final RxList<LookupValues> cancelOrderReason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedCancelOrderReason = Rxn<LookupValues>();
  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  // Header/meta
  final issueTitle = ''.obs;
  final priority = ''.obs;
  final statusText = ''.obs;
  final duration = ''.obs;
  final workOrderId = ''.obs;
  final time = ''.obs;
  final category = ''.obs;

  // submission state
  final isUploading = false.obs;

  // form
  final selectedReason = 'Select Reason'.obs;
  final remarkCtrl = TextEditingController();

  WorkOrder? workOrderInfo;

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

    final tabs = Get.find<UpdateWorkTabsController>();
    workOrderInfo = tabs.workOrder;

    if (workOrderInfo != null) {
      issueTitle.value = workOrderInfo!.title;
      category.value = workOrderInfo!.departmentName;
      time.value = _formatDate(workOrderInfo!.createdAt);
      priority.value = workOrderInfo!.priority;
      duration.value = workOrderInfo!.timeLeft;
      statusText.value = workOrderInfo!.status;
      workOrderId.value = workOrderInfo!.id;
    }

    final list = await lookupRepository.getLookupByType(LookupType.resolution);

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

    cancelOrderReason.assignAll([placeholder, ...list]);
    selectedCancelOrderReason.value = placeholder;
  }

  @override
  void onClose() {
    remarkCtrl.dispose();
    super.onClose();
  }

  void discard() {
    selectedReason.value = 'Select Reason';
    selectedCancelOrderReason.value =
        cancelOrderReason.isNotEmpty ? cancelOrderReason.first : null;
    remarkCtrl.clear();
    Get.back();
  }

  Future<void> reOpenWorkOrder() async {
    // prevent double taps
    if (isUploading.value) return;

    // Validate reason
    if (_isPlaceholder(selectedCancelOrderReason.value)) {
      _snack(
          'Reason required',
          'Please select a reason to re-open this work order.',
          SnackType.error);
      return;
    }

    // Validate ID
    final woId = workOrderInfo?.id ?? '';
    if (woId.isEmpty) {
      _snack('Missing ID', 'Work order ID not found.', SnackType.error);
      return;
    }

    isUploading.value = true; // <- set once at the top
    try {
      final sel = selectedCancelOrderReason.value!;
      final req = ReOpenWorkOrderRequest(
        status: 'ReOpen',
        remark: remarkCtrl.text.trim(),
        comment: sel.displayName, // or sel.id / sel.code per API contract
      );

      final result = await reopenRepositoryImpl.reopenOrder(
        reOpenWorkOrderId: woId,
        reOpenWorkOrderRequest: req,
      );

      final ok = result.httpCode == 200 && result.data != null;
      if (ok) {
        //isUploading.value = false;
        _snack('Re-opened', 'Work order re-opened successfully.',
            SnackType.success);

        Get.offAllNamed(
          Routes.landingDashboardScreen,
          arguments: {'tab': 3},
        );
      } else {
        isUploading.value = false;
        _snack(
          'Re-open failed',
          (result.message?.trim().isNotEmpty ?? false)
              ? result.message!
              : 'Unexpected response (code ${result.httpCode}).',
          SnackType.warning,
        );
      }
    } catch (e) {
      isUploading.value = false;
      _snack('Error', e.toString(), SnackType.error);
    } finally {
      //isUploading.value = false;
    }
  }

  // single snackbar helper (closes previous one first)
  void _snack(String title, String message, SnackType type) {
    Get.closeAllSnackbars();

    Color bg, fg = Colors.black87;
    switch (type) {
      case SnackType.success:
        bg = Colors.green.shade100;
        break;
      case SnackType.error:
        bg = Colors.red.shade100;
        break;
      case SnackType.warning:
        bg = Colors.orange.shade100;
        break;
      case SnackType.info:
      default:
        bg = Colors.blue.shade100;
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bg,
      colorText: fg,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
