import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/controller/general_rca_analysis_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/models/rca_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerRcaAnalysisController extends GetxController {
  // UI state
  final isSaving = false.obs;
  final isLoading = true.obs; // <- loading gate for async init
  final fiveWhyOpen = true.obs;

  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  // Form
  final formKey = GlobalKey<FormState>();
  final TextEditingController problemCtrl = TextEditingController();
  final List<TextEditingController> whyCtrls =
      List<TextEditingController>.generate(5, (_) => TextEditingController());
  final TextEditingController rootCauseCtrl = TextEditingController();
  final TextEditingController correctiveCtrl = TextEditingController();

  // Data
  final Rxn<WorkOrders> workOrderInfo = Rxn<WorkOrders>();

  // Do not make onInit async; load heavy stuff in onReady
  @override
  void onInit() {
    super.onInit();
  }

  // Called after the first build → safe place for async loads
  @override
  void onReady() async {
    try {
      final wo = await SharePreferences.getObject(
        Constant.workOrder,
        WorkOrders.fromJson,
      );
      workOrderInfo.value = wo;
    } finally {
      isLoading.value = false;
    }
    super.onReady();
  }

  @override
  void onClose() {
    problemCtrl.dispose();
    for (final c in whyCtrls) {
      c.dispose();
    }
    rootCauseCtrl.dispose();
    correctiveCtrl.dispose();
    super.onClose();
  }

  Future<void> save() async {
    // Don’t submit until data is loaded
    if (isLoading.value) return;

    final woId = workOrderInfo.value?.id ?? '';
    if (woId.isEmpty) {
      Get.snackbar(
        'Missing Work Order',
        'Work order not loaded yet. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) return;

    isSaving.value = true;
    try {
      final req = RcaRequest(
        workOrderId: woId,
        problem: problemCtrl.text.trim(),
        why1: whyCtrls[0].text.trim(),
        why2: whyCtrls[1].text.trim(),
        why3: whyCtrls[2].text.trim(),
        why4: whyCtrls[3].text.trim(),
        why5: whyCtrls[4].text.trim(),
        rca: rootCauseCtrl.text.trim(),
        cap: correctiveCtrl.text.trim(),
      );

      final resp = await repositoryImpl.createRca(req);
      final code = resp.httpCode ?? 0;

      if (code == 200) {
        final result = RcaResult(
          problemIdentified: problemCtrl.text.trim(),
          fiveWhys: whyCtrls.map((e) => e.text.trim()).toList(growable: false),
          rootCause: rootCauseCtrl.text.trim(),
          correctiveAction: correctiveCtrl.text.trim(),
        );
        Get.back(result: result);
        return; // <- important: don’t fall through to “Failed” toast
      }

      Get.snackbar(
        'Failed',
        (resp.message?.trim().isNotEmpty ?? false)
            ? resp.message!.trim()
            : 'Unexpected response (code $code).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
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
      isSaving.value = false;
    }
  }
}
