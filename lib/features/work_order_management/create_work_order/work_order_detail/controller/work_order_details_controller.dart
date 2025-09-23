// work_order_details_controller.dart
// ignore: file_names
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditWorkOrderDetailsController extends GetxController {
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();
  late final WorkOrderDetailVM vm;

  // Header
  final title = 'Work Order Details'.obs;

  // Operator
  final operatorName = ''.obs;
  final operatorInfo = ''.obs;
  final operatorPhoneNumber = ''.obs;

  // Banner
  final successTitle = 'Work Order Created\nSuccessfully'.obs;
  final successSub = 'Work Order ID - BD265'.obs;

  // Reporter
  final reportedBy = ''.obs;

  // Summary
  final descriptionText = ''.obs; // falls back to problemDescription
  final priority = ''.obs; // impact
  final issueType = ''.obs; // issueType

  // Time / Date (from operator tab)
  final time = ''.obs; // HH:mm
  final date = ''.obs; // dd MMM

  // Location line
  final line = ''.obs;
  final location = ''.obs; // "Location | Plant"

  // Body
  final headline = ''.obs; // typeText
  final problemDescription = ''.obs; // problemDescription

  // Media
  final photoPaths = <String>[].obs;
  final voiceNotePath = ''.obs;

  final cnc_1 = 'CNC-1'.obs;

  @override
  void onInit() {
    super.onInit();

    // Optionally merge args -> bag
    final args = Get.arguments;
    if (args is Map<String, dynamic>) _bag.merge(args);

    // Build VM from bag
    vm = WorkOrderDetailVM.fromBag(_bag);

    // Bind all page-facing values
    _bindFromVMAndBag();
  }

  void _bindFromVMAndBag() {
    // Operator footer
    operatorName.value = vm.operatorName;
    operatorPhoneNumber.value = vm.operatorMobileNumber;
    operatorInfo.value = vm.operatorInfo;

    // Reporter
    reportedBy.value = _bag.get<String>(WOKeys.reporter, '');

    // Summary
    issueType.value = vm.issueType;
    priority.value = vm.impact;
    descriptionText.value = vm.descriptionText.isNotEmpty
        ? vm.descriptionText
        : vm.problemDescription;

    // Body
    headline.value = vm.typeText;
    problemDescription.value = vm.problemDescription;

    // Media
    photoPaths.assignAll(vm.photos);
    voiceNotePath.value = vm.voiceNotePath;

    // Location | Plant
    final loc = _bag.get<String>(WOKeys.location, '');
    final plant = _bag.get<String>(WOKeys.plant, '');
    location.value = _joinNonEmpty([loc, plant], ' | ');

    // Time (stored HH:mm) and Date (stored ISO-8601) -> strings
    final tStr = _bag.get<String?>(WOKeys.reportedTime, null);
    final dStr = _bag.get<String?>(WOKeys.reportedDate, null);

    final t = _decodeTime(tStr);
    final d = _decodeDate(dStr);

    time.value = t == null ? '' : _formatTime(t); // "HH:mm"
    date.value = d == null ? '' : _formatDate(d); // "dd MMM"
  }

  String _joinNonEmpty(List<String> parts, String sep) {
    final filtered = parts.where((p) => p.trim().isNotEmpty).toList();
    return filtered.join(sep);
  }

  void create() {
    Get.offAllNamed(
      Routes.landingDashboardScreen,
      arguments: {'tab': 3},
    );

    Get.snackbar(
      'Create',
      'Work Order Created Successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successGreen,
      colorText: AppColors.white,
    );
  }

  void goBack() => Get.back();

  // --------- Helpers ---------

  TimeOfDay? _decodeTime(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  DateTime? _decodeDate(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime d) {
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
      'Dec',
    ];
    final dd = d.day.toString().padLeft(2, '0');
    final mon = months[d.month - 1];
    return '$dd $mon';
  }
}

/// A plain VM to hold what the UI will render
class WorkOrderDetailVM {
  final String operatorName;
  final String operatorMobileNumber;
  final String operatorInfo;

  final String issueType;
  final String impact;
  final String assetsNumber;
  final String problemDescription;

  final String typeText;
  final String descriptionText;

  final List<String> photos;
  final String voiceNotePath;

  WorkOrderDetailVM({
    required this.operatorName,
    required this.operatorMobileNumber,
    required this.operatorInfo,
    required this.issueType,
    required this.impact,
    required this.assetsNumber,
    required this.problemDescription,
    required this.typeText,
    required this.descriptionText,
    required this.photos,
    required this.voiceNotePath,
  });

  /// Read-by-key from the bag
  factory WorkOrderDetailVM.fromBag(WorkOrderBag bag) {
    final rawPhotos = bag.get<List?>(WOKeys.photos, const []) ?? const [];
    final photos = rawPhotos.map((e) => e.toString()).toList();

    return WorkOrderDetailVM(
      operatorName: bag.get<String>(WOKeys.operatorName, ''),
      operatorMobileNumber: bag.get<String>(WOKeys.operatorMobileNumber, ''),
      operatorInfo: bag.get<String>(WOKeys.operatorInfo, ''),
      issueType: bag.get<String>(WOKeys.issueType, ''),
      impact: bag.get<String>(WOKeys.impact, ''),
      assetsNumber: bag.get<String>(WOKeys.assetsNumber, ''),
      problemDescription: bag.get<String>(WOKeys.problemDescription, ''),
      typeText: bag.get<String>(WOKeys.typeText, ''),
      descriptionText: bag.get<String>(WOKeys.descriptionText, ''),
      photos: photos,
      voiceNotePath: bag.get<String>(WOKeys.voiceNotePath, ''),
    );
  }
}
