// lib/.../hold_work_order/controller/me_hold_work_order_controller.dart
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/models/cancel_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MEHoldWorkOrderController extends GetxController {
  // Network + DB
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();
  final DBRepository db = Get.find<DBRepository>();

  // Ready state for the screen (prevents reading nulls in build)
  final ready = false.obs;

  // Lookup: Hold Reason
  final RxList<LookupValues> reasons = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select Reason'.obs;

  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  // Context (top card)
  final RxString holdContextTitle = 'Need Hydra'.obs;
  final RxString holdContextCategory = 'Assets Availability'.obs;
  final RxString holdContextDesc =
      'Live offline shoulder see gave group like loop. Container.'.obs;

  // Form state
  final TextEditingController reasonTitleCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();
  final RxString reasonTitle = ''.obs;
  final RxString remarks = ''.obs;

  // Submit state
  final RxBool isSubmitting = false.obs;

  // Current Work Order
  WorkOrders? workOrderInfo;

  @override
  void onInit() {
    super.onInit();
    // no async work here that the UI depends on
  }

  @override
  Future<void> onReady() async {
    // Called after first frame — safe place to do async + then mark ready
    await _loadWorkOrder();
    await _loadHoldReasons();
    ready.value = true;
    super.onReady();
  }

  @override
  void onClose() {
    reasonTitleCtrl.dispose();
    remarksCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadWorkOrder() async {
    workOrderInfo = await SharePreferences.getObject(
      Constant.workOrder,
      WorkOrders.fromJson,
    );
  }

  Future<void> _loadHoldReasons() async {
    // Use your local DB lookups; fallback to a placeholder row
    final list = await db.getLookupByType(LookupType.resolution) ??
        const <LookupValues>[];

    final placeholder = LookupValues(
      id: '',
      code: '',
      displayName: 'Select reason',
      description: '',
      lookupType: LookupType.resolution.name,
      sortOrder: -1,
      recordStatus: 1,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      clientId: '',
    );

    reasons.assignAll([placeholder, ...list]);
    selectedReason.value = placeholder;
    selectedReasonValue.value = placeholder.displayName;
  }

  Future<void> onEditContext(BuildContext context) async {
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
              final t = titleTemp.text.trim();
              final d = descTemp.text.trim();
              if (t.isNotEmpty) holdContextTitle.value = t;
              holdContextDesc.value = d;
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

      final sel = selectedReason.value!;
      final req = CancelWorkOrderRequest(
        status: 'Hold',
        remark: remarksCtrl.text.trim(),
        comment: sel.displayName, // or sel.id / sel.code as per API
      );

      final result = await repositoryImpl.cancelOrder(
        cancelWorkOrderId: woId,
        cancelWorkOrderRequest: req,
      );

      if (result.httpCode == 200 && result.data != null) {
        Get.snackbar(
          'On hold',
          'Work order placed on hold successfully.',
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
          'Failed',
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
}
