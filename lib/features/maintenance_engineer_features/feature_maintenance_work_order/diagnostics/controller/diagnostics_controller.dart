import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/WorkTabsController.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerDiagnosticsController extends GetxController {
  static const String _BASE_URL =
      'https://user-dev.eazyops.in:8443/v1/api/uploads/';

  /// top progress
  final isLoading = true.obs;

  /// accordions
  final opInfoExpanded = true.obs;
  final woInfoExpanded = false.obs;

  /// current work order (nullable until resolved)
  WorkOrders? workOrderInfo;

  /// Media
  final photoPaths = <String>[].obs; // absolute image URLs
  final voiceNotePath = ''.obs; // absolute audio URL

  @override
  void onInit() {
    super.onInit();

    // Resolve work order (from tab controller or route args)
    final workTabsController =
        Get.find<MaintenanceEngineerWorkTabsController>();
    if (workTabsController.workOrder == null) {
      workOrderInfo = getWorkOrderFromArgs(Get.arguments);
    } else {
      workOrderInfo = workTabsController.workOrder;
    }

    // Populate media from work order
    final files = workOrderInfo?.mediaFiles ?? const <MediaFile>[];

    final images = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('image/'))
        .map((f) => _absoluteUrl(f.filePath))
        .where((p) => p.isNotEmpty)
        .toList();
    photoPaths.assignAll(images);

    final firstAudio = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('audio/'))
        .map((f) => _absoluteUrl(f.filePath))
        .firstWhere((p) => p.isNotEmpty, orElse: () => '');
    voiceNotePath.value = firstAudio;

    // page initial state
    isLoading.value = false;
  }

  /* -------------------------- Actions (footer) -------------------------- */

  Future<void> endWork() async {
    Get.toNamed(Routes.maintenanceEngeneerclosureScreen);
  }

  Future<void> hold() async {
    Get.toNamed(Routes.maintenanceEngeneerholdWorkOrderScreen);
  }

  Future<void> reassign() async {
    Get.toNamed(Routes.maintenanceEngeneerreassignWorkOrderScreen);
  }

  Future<void> cancel() async {
    Get.toNamed(Routes.maintenanceEngeneercancelWorkOrderFromDiagnosticsScreen);
  }

  /* ----------------------------- Helpers ----------------------------- */

  /// Accepts either a WorkOrders instance or a Map with common keys.
  WorkOrders? getWorkOrderFromArgs(dynamic args) {
    if (args is WorkOrders) return args;

    if (args is Map) {
      final map = args.cast<String, dynamic>();
      final raw = map['work_order_info'] ??
          map['workOrder'] ??
          map['work_order'] ??
          map['workOrderInfo'] ??
          args; // sometimes route sends the JSON itself

      if (raw is WorkOrders) return raw;
      if (raw is Map) {
        return WorkOrders.fromJson(Map<String, dynamic>.from(raw));
      }
    }
    return null;
  }

  /// Turn a relative path into an absolute URL using _BASE_URL.
  String _absoluteUrl(String? raw) {
    final p = (raw ?? '').trim();
    if (p.isEmpty) return '';
    final lower = p.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) return p;

    final base = _BASE_URL.endsWith('/')
        ? _BASE_URL.substring(0, _BASE_URL.length - 1)
        : _BASE_URL;
    final path = p.startsWith('/') ? p.substring(1) : p;
    return '$base/$path';
  }
}
