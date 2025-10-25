// start_work_order_controller.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/utils/utils.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/WorkTabsController.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/controller/spare_cart_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/models/spares_models.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerStartWorkOrderController extends GetxController {
  static const String _BASE_URL =
      'https://user-dev.eazyops.in:8443/v1/api/uploads/';
  // Demo hero values
  final subject = ''.obs; // 'Hydraulic Leak in CNC-1'.obs;
  final priority = ''.obs; // 'High'.obs;
  final elapsed = ''.obs; //'00:23'.obs;
  final woCode = ''.obs; // 'WO-2025-00123'.obs;
  final time = '10:15 AM'.obs;
  final date = '13 Sep 2025'.obs;
  final category = 'Breakdown'.obs;
  final status = ''.obs;

  // Phone numbers (bind your real values)
  final reportedByPhone = '+911234567890'.obs;
  final maintenanceManagerPhone = '+919876543210'.obs;

  final operatorOpen = true.obs;
  final reportedBy = ''.obs;
  final maintenanceManager = ''.obs;
  final workInfoOpen = true.obs;
  final assetLine = 'CNC-1 · Line A'.obs;
  final assetLocation = 'Bay 2 · Shop Floor'.obs;
  final description = ''.obs;

  final RxList<CartLine> requestedSpares = <CartLine>[].obs;

  // Track active audio players from the page
  final Set<AudioPlayer> _players = {};

  void registerPlayer(AudioPlayer p) => _players.add(p);
  void unregisterPlayer(AudioPlayer p) => _players.remove(p);

  // Media
  final photoPaths = <String>[].obs; // image URLs (absolute)
  final voiceNotePath = ''.obs; // first audio URL (absolute)

  Future<void> stopAllAudio() async {
    for (final p in _players.toList()) {
      try {
        await p.stop();
      } catch (_) {}
    }
  }

  WorkOrders? workOrderInfo;

  @override
  void onInit() {
    super.onInit();
    final workTabsController =
        Get.find<MaintenanceEngineerWorkTabsController>();
    if (workTabsController.workOrder == null) {
      workOrderInfo = getWorkOrderFromArgs(Get.arguments);
    } else {
      workOrderInfo = workTabsController.workOrder;
    }
    subject.value = workOrderInfo!.title;
    priority.value = workOrderInfo!.priority;
    elapsed.value = workOrderInfo!.estimatedTimeToFix;
    woCode.value = workOrderInfo!.issueNo;
    status.value = workOrderInfo!.status;
    date.value = formatDate(workOrderInfo!.createdAt);
    description.value = workOrderInfo!.description;

    reportedByPhone.value = (workOrderInfo?.reportedBy?.phone).orNA();
    final operatorName = [
      workOrderInfo?.reportedBy?.firstName,
      workOrderInfo?.reportedBy?.lastName
    ]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' ');
    reportedBy.value = operatorName.orNA();

    maintenanceManagerPhone.value = (workOrderInfo?.operator?.phone).orNA();
    final managerName = [
      workOrderInfo?.operator?.firstName,
      workOrderInfo?.operator?.lastName
    ]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' ');
    maintenanceManager.value = managerName.orNA();

    // final args = Get.arguments;

    // ----- Media binding (images + single audio) -----
    final files = workOrderInfo?.mediaFiles ?? const <MediaFile>[];

    final images = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('image/'))
        .map((f) => _absoluteUrl(f.filePath))
        .where((p) => p.isNotEmpty)
        .toList();

    photoPaths.assignAll(images.toList());

    // First audio/* -> absolute URL
    final firstAudio = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('audio/'))
        .map((f) => _absoluteUrl(f.filePath))
        .firstWhere(
          (p) => p.isNotEmpty,
          orElse: () => '',
        );
    voiceNotePath.value = firstAudio;
  }

  String _absoluteUrl(String? raw) {
    final p = (raw ?? '').trim();
    if (p.isEmpty) return '';
    final lower = p.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return p;
    }
    // normalize slashes
    final base = _BASE_URL.endsWith('/')
        ? _BASE_URL.substring(0, _BASE_URL.length - 1)
        : _BASE_URL;
    final path = p.startsWith('/') ? p.substring(1) : p;
    return '$base/$path';
  }

  @override
  void onClose() {
    // ensure we stop anything if controller/page is disposed
    stopAllAudio();
    super.onClose();
  }

  // Actions
  void toggleOperator() => operatorOpen.toggle();
  void toggleWorkInfo() => workInfoOpen.toggle();

  Future<void> startOrder() async {
    await stopAllAudio(); // ⬅️ stop audio before navigating
    // Get.toNamed(Routes.maintenanceEngeneerstartWorkSubmitScreen);
    Get.toNamed(
      Routes.maintenanceEngeneerstartWorkSubmitScreen,
      arguments: {
        Constant.workOrderInfo: workOrderInfo,
      },
    );
  }

  /// Open Request Spares and pre-fill with already requested items
  Future<void> needSpares() async {
    await stopAllAudio(); // ⬅️ stop audio before navigating

    final cartCtrl = Get.find<MaintenanceEnginnerSpareCartController>();
    cartCtrl.cart
      ..clear()
      ..addAll(
        requestedSpares.map(
          (l) => CartLine(
            key: l.key,
            item: l.item,
            qty: l.qty,
            cat1: l.cat1,
            cat2: l.cat2,
          ),
        ),
      );
    Get.toNamed(
      Routes.maintenanceEngeneerrequestSparesScreen,
      arguments: {
        Constant.workOrderInfo: workOrderInfo,
      },
    );
    //Get.toNamed(Routes.maintenanceEngeneerrequestSparesScreen);
  }

  /// Merge-in lines from the cart (called by SpareCartController.placeOrder()).
  void addSparesFromCart(List<CartLine> lines) {
    for (final l in lines) {
      final idx = requestedSpares.indexWhere((e) => e.key == l.key);
      if (idx >= 0) {
        requestedSpares[idx].qty += l.qty;
      } else {
        requestedSpares.add(
          CartLine(
            key: l.key,
            item: l.item,
            qty: l.qty,
            cat1: l.cat1,
            cat2: l.cat2,
          ),
        );
      }
    }
    requestedSpares.refresh();
  }

  void openAssetHistory() async {
    await stopAllAudio(); // keep UX clean if audio is playing
    // TODO: Navigate to your history screen
    // Get.toNamed(Routes.assetHistoryScreen, arguments: {'asset': assetLine.value});
    Get.snackbar(
      'History',
      'Open asset history for ${assetLine.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

extension StringOrNA on String? {
  String orNA([String fallback = 'Not available']) {
    final s = (this ?? '').trim();
    return s.isEmpty ? fallback : s;
  }
}
