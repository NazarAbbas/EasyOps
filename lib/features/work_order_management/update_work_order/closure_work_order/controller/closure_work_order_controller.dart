import 'dart:io';
import 'dart:typed_data';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/dashboard_screens/landing_dashboard/controller/landing_dashboard_nav_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class ClosureWorkOrderController extends GetxController {
  final pageTitle = 'Closure'.obs;

  final issueTitle = 'Tool misalignment and spindle speed issues in Bay 3.'.obs;
  final priority = 'High'.obs;
  final statusText = 'In Progress'.obs;
  final duration = '1h 20m'.obs;

  final workOrderId = 'BD-102'.obs;
  final time = '18:08'.obs;
  final date = '09 Aug'.obs;
  final category = 'Mechanical'.obs;

  final resolutionTypes = const [
    'Belt Problem',
    'Electrical Fix',
    'Realignment',
    'Other',
  ];
  final selectedResolution = 'Belt Problem'.obs;
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

  @override
  void onInit() {
    super.onInit();
    signatureCtrl = SignatureController(
      penColor: const Color(0xFF111827),
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.transparent,
      onDrawEnd: () => hasSignature.value = true,
    );
  }

  @override
  void onClose() {
    noteCtrl.dispose();
    signatureCtrl.dispose();
    super.onClose();
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
    if (!hasSignature.value || signatureCtrl.isEmpty) {
      Get.snackbar(
        'Signature required',
        'Please add your signature to proceed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final bytes = await signatureCtrl.toPngBytes();
    if (bytes == null || bytes.isEmpty) {
      Get.snackbar(
        'Error',
        'Could not export signature.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final path = await _saveBytes(bytes);
    savedSignaturePath.value = path ?? '';

    isSubmitting.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSubmitting.value = false;

    // If the controller already exists (you’re still in the app shell),
    // set the tab immediately so PageView updates.
    // if (Get.isRegistered<LandingRootNavController>()) {
    //   Get.find<LandingRootNavController>().select(3, animate: false);
    // }

    // // Also pass the target tab as a route argument so it works even if the shell is rebuilt.
    // Get.offAllNamed(Routes.landingDashboardScreen, arguments: 3);

    Get.offAllNamed(
      Routes.landingDashboardScreen,
      arguments: {'tab': 3}, // open Work Orders
    );
  }

  Future<String?> _saveBytes(Uint8List data) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(data, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}

class _Spare {
  final String name;
  final int qty;
  final int unitPrice; // ₹
  const _Spare(this.name, this.qty, this.unitPrice);
}
