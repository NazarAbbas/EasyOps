// closure_controller.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/controller/general_pending_activity_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/controller/general_rca_analysis_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure_signature/controller/sign_off_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/controller/rca_analysis_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/models/close_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class PendingActivityArgs {
  final List<ActivityItem> initial;
  const PendingActivityArgs({required this.initial});
}

class MaintenanceEnginnerClosureController extends GetxController {
  final NetworkRepositoryImpl closeRepositoryImpl = NetworkRepositoryImpl();
  final repository = Get.find<DBRepository>();

  /// Bootstrapping & submit states
  final isBootstrapping = true.obs;
  final isSubmitting = false.obs;

  /// Collected results
  final Rxn<SignatureResult> signatureResult = Rxn<SignatureResult>();
  final Rxn<RcaResult> rcaResult = Rxn<RcaResult>();
  final RxList<ActivityItem> pendingActivities = <ActivityItem>[].obs;
  final RxList<SpareReturnItem> sparesToReturn = <SpareReturnItem>[].obs;

  /// Derived totals
  int get sparesToReturnNosTotal =>
      sparesToReturn.fold(0, (sum, e) => sum + e.nos);
  double get sparesToReturnCostTotal =>
      sparesToReturn.fold(0, (sum, e) => sum + e.cost);

  /// Lookup
  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select resolution type'.obs;

  bool _isPlaceholder(LookupValues? v) =>
      v == null ||
      (v.id.isEmpty &&
          v.displayName.toLowerCase().contains('select resolution'));

  /// Work order
  WorkOrders? workOrderInfo;

  /// User note
  final noteController = TextEditingController();

  /// Accordions
  final sparesOpen = true.obs;
  final rcaOpen = true.obs;
  final pendingOpen = true.obs;

  /// Demo spares figures
  final sparesConsumedNos = 20.obs;
  final sparesConsumedCost = 2000.obs;
  final sparesIssuedNos = 20.obs;
  final sparesIssuedCost = 2000.obs;

  /// Signature pad
  late final SignatureController signatureCtrl;
  final hasSignature = false.obs;
  final savedSignaturePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Init synchronous things
    signatureCtrl = SignatureController(
      penColor: const Color(0xFF111827),
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.transparent,
      onDrawEnd: () => hasSignature.value = true,
    );
  }

  @override
  void onReady() async {
    // Bootstrap async after first frame
    try {
      isBootstrapping.value = true;

      // Load current work order
      workOrderInfo = await SharePreferences.getObject(
        Constant.workOrder,
        WorkOrders.fromJson,
      );

      // Load resolution lookup
      final list = await repository.getLookupByType(LookupType.resolution);

      final placeholder = LookupValues(
        id: '',
        code: '',
        displayName: 'Select resolution type',
        description: '',
        lookupType: LookupType.resolution.name,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      );

      reason.assignAll([placeholder, ...list]);
      selectedReason.value = placeholder;
      selectedReasonValue.value = placeholder.displayName;
    } finally {
      isBootstrapping.value = false;
    }
  }

  @override
  void onClose() {
    // signatureCtrl.dispose();
    // noteController.dispose();
    super.onClose();
  }

  Future<void> resolveWorkOrder() async {
    if (_isPlaceholder(selectedReason.value)) {
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

      // Add signature file path if present (if API expects it)
      final sigPath = savedSignaturePath.value.trim();
      final files = (sigPath.isNotEmpty && File(sigPath).existsSync())
          ? <String>[sigPath]
          : null;

      final sel = selectedReason.value!;
      final req = CloseWorkOrderRequest(
        status: 'Resolved',
        remark: noteController.text.trim(),
        comment: sel.displayName, // or sel.id / sel.code per your API
        files: files, // optional signature image path(s)
      );

      final result = await closeRepositoryImpl.closeOrder(
        closeWorkOrderId: woId,
        closeWorkOrderRequest: req,
      );

      if (result.httpCode == 200 && result.data != null) {
        _snack('Closed', 'Work order closed successfully.', SnackType.success);
        Get.offAllNamed(
          Routes.landingDashboardScreen,
          arguments: {'tab': 3},
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

  void clearSignature() {
    signatureCtrl.clear();
    hasSignature.value = false;
    savedSignaturePath.value = '';
  }
}

/// Save bytes as a PNG in app documents dir
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
  const fg = Colors.black87;

  switch (type) {
    case SnackType.success:
      bg = Colors.greenAccent;
      break;
    case SnackType.error:
      bg = Colors.redAccent;
      break;
    case SnackType.warning:
      bg = Colors.orangeAccent;
      break;
    case SnackType.info:
    default:
      bg = Colors.lightBlueAccent;
      break;
  }

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: bg.withOpacity(0.25),
    colorText: fg,
    margin: const EdgeInsets.all(12),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
  );
}

enum SnackType { success, error, warning, info }

// models/spare_return_item.dart
class SpareReturnItem {
  final String id; // e.g. INV-001 / SP-001
  final String name; // e.g. "Bearing 6203"
  final int nos; // quantity to return
  final double cost; // total cost for this line

  const SpareReturnItem({
    required this.id,
    required this.name,
    required this.nos,
    required this.cost,
  });

  SpareReturnItem copyWith({
    String? id,
    String? name,
    int? nos,
    double? cost,
  }) =>
      SpareReturnItem(
        id: id ?? this.id,
        name: name ?? this.name,
        nos: nos ?? this.nos,
        cost: cost ?? this.cost,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nos": nos,
        "cost": cost,
      };

  factory SpareReturnItem.fromJson(Map<String, dynamic> json) =>
      SpareReturnItem(
        id: json["id"] as String,
        name: json["name"] as String,
        nos: json["nos"] as int,
        cost: (json["cost"] as num).toDouble(),
      );
}
