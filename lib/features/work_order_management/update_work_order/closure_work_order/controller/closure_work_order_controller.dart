import 'dart:io';
import 'dart:typed_data';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/domain/close_repository_impl.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/models/close_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

enum SnackType { success, error, warning, info }

class ClosureWorkOrderController extends GetxController {
  final CloseRepositoryImpl closeRepositoryImpl = CloseRepositoryImpl();
  final LookupRepository lookupRepository = Get.find<LookupRepository>();

  final RxList<LookupValues> cancelOrderReason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedCancelOrderReason = Rxn<LookupValues>();
  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  WorkOrder? workOrderInfo;

  final pageTitle = 'Closure'.obs;

  final issueTitle = ''.obs;
  final priority = ''.obs;
  final statusText = ''.obs;
  final duration = ''.obs;

  final workOrderId = 'BD-102'.obs;
  final time = ''.obs;
  final category = ''.obs;
  final noteCtrl = TextEditingController();

  late final SignatureController signatureCtrl;
  final hasSignature = false.obs;
  final savedSignaturePath = ''.obs;

  final sparesExpanded = false.obs;
  final spares = <_Spare>[
    const _Spare('Belt Type A', 2, 200),
    const _Spare('Grease Pack', 1, 150),
    const _Spare('Alignment Shim', 17, 10),
  ].obs;

  int get totalQty => spares.fold(0, (a, b) => a + b.qty);
  int get totalCost => spares.fold(0, (a, b) => a + (b.qty * b.unitPrice));

  final isSubmitting = false.obs;

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

    final workTabsController = Get.find<UpdateWorkTabsController>();
    workOrderInfo = workTabsController.workOrder;

    if (workOrderInfo != null) {
      issueTitle.value = workOrderInfo!.title;
      category.value = workOrderInfo!.departmentName;
      time.value = _formatDate(workOrderInfo!.createdAt);
      priority.value = workOrderInfo!.priority;
      duration.value = workOrderInfo!.timeLeft;
      statusText.value = workOrderInfo!.status;
    }

    signatureCtrl = SignatureController(
      penColor: const Color(0xFF111827),
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.transparent,
      onDrawEnd: () => hasSignature.value = true,
    );

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

    cancelOrderReason.assignAll([placeholder, ...list]);
    selectedCancelOrderReason.value = placeholder;
  }

  void clearSignature() {
    signatureCtrl.clear();
    hasSignature.value = false;
  }

  void toggleSpares() => sparesExpanded.toggle();

  Future<void> reopenWorkOrder() async {
    Get.toNamed(Routes.reOpenWorkOrderScreen);
  }

  Future<void> closeWorkOrder() async {
    if (_isPlaceholder(selectedCancelOrderReason.value)) {
      _snack('Reason required',
          'Please select a reason to close this work order.', SnackType.error);
      return;
    }

    final woId = workOrderInfo?.id ?? '';
    if (woId.isEmpty) {
      _snack('Missing ID', 'Work order ID not found.', SnackType.error);
      return;
    }

    if (!hasSignature.value || signatureCtrl.isEmpty) {
      _snack('Signature required', 'Please add your signature to proceed.',
          SnackType.warning);
      return;
    }

    // Export signature → bytes
    final bytes = await signatureCtrl.toPngBytes();
    if (bytes == null || bytes.isEmpty) {
      _snack('Error', 'Could not export signature.', SnackType.error);
      return;
    }

    // Save bytes → file and keep the path
    final path = await _saveBytes(bytes);
    if (path == null || path.isEmpty) {
      _snack('Error', 'Could not save signature image.', SnackType.error);
      return;
    }
    savedSignaturePath.value = path;

    try {
      isSubmitting.value = true;

      // Validate/prepare the signature path for the JSON body
      final sigPath = savedSignaturePath.value.trim();
      final files = (sigPath.isNotEmpty && File(sigPath).existsSync())
          ? <String>[sigPath]
          : null;

      // Build JSON request (include files only when valid)
      final sel = selectedCancelOrderReason.value!;
      final req = CloseWorkOrderRequest(
        status: 'Close',
        remark: noteCtrl.text.trim(),
        comment: sel.displayName, // or sel.id / sel.code per your API
        files: files, // <-- signature image path goes here
      );

      // Send plain JSON (NO multipart)
      final result = await closeRepositoryImpl.closeOrder(
        closeWorkOrderId: woId,
        closeWorkOrderRequest: req,
      );

      if (result.httpCode == 200 && result.data != null) {
        _snack('Closed', 'Work order closed successfully.', SnackType.success);
        Get.offAllNamed(
          Routes.landingDashboardScreen,
          arguments: {'tab': 3}, // Work Orders tab
        );
      } else {
        _snack(
          'Close failed',
          (result.message?.trim().isNotEmpty ?? false)
              ? result.message!
              : 'Unexpected response (code ${result.httpCode}).',
          SnackType.warning,
        );
      }
    } catch (e) {
      _snack('Error', e.toString(), SnackType.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String?> _saveBytes(Uint8List data) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(data, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  // ---------- Single Snackbar Helper ----------
  void _snack(String title, String message, SnackType type) {
    Color bg;
    Color fg = Colors.black87;

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

class _Spare {
  final String name;
  final int qty;
  final int unitPrice; // ₹
  const _Spare(this.name, this.qty, this.unitPrice);
}
