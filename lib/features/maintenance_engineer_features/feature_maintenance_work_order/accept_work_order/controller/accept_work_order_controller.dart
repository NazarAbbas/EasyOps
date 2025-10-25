// work_order_details_controller.dart
// ignore: file_names
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerAcceptWorkOrderController extends GetxController {
  // ----- Base URL to prefix -----
  //static const String Constant.BASE_URL = 'https://user-dev.eazyops.in:8443/v1/api/';

  // Header
  final title = 'Work Order Details'.obs;

  // Operator
  final operatorName = ''.obs;
  final operatorInfo = ''.obs;
  final operatorPhoneNumber = ''.obs;

  // Reporter
  final reportedBy = ''.obs;

  // Summary
  final remark = ''.obs;
  final priority = ''.obs;
  final issueType = ''.obs;

  // Time / Date
  final date = ''.obs;

  // Location line under summary
  final line = ''.obs;
  final location = ''.obs;

  // Body
  final headline = ''.obs;
  final workOrderTitle = ''.obs;
  final description = ''.obs;
  final problemDescrition = ''.obs;

  // Media
  final photoPaths = <String>[].obs; // image URLs (absolute)
  final voiceNotePath = ''.obs; // first audio URL (absolute)

  final cnc_1 = ''.obs;
  final issueNo = ''.obs;
  final status = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final workTabsController = Get.find<UpdateWorkTabsController>();
    final workOrderInfo = workTabsController.workOrder;

    if (workOrderInfo == null) return;

    // ----- Operator -----

    status.value = workOrderInfo.status;
    issueNo.value = workOrderInfo.issueNo ?? '-';
    final first = (workOrderInfo.operator?.firstName ?? '').trim();
    final last = (workOrderInfo.operator?.lastName ?? '').trim();
    final name = ('$first $last').trim();

    operatorName.value = name.isEmpty ? 'Not available' : name;
    operatorPhoneNumber.value =
        workOrderInfo.operator?.phone ?? 'Not available';
    operatorInfo.value = workOrderInfo.asset.name.isNotEmpty
        ? workOrderInfo.asset.name
        : 'Not available';

    cnc_1.value = '${workOrderInfo.asset.name}(${workOrderInfo.asset.assetNo})';
    issueType.value = workOrderInfo.type ?? "-";

    // ----- Media binding (images + single audio) -----
    final files = workOrderInfo.mediaFiles ?? const <MediaFile>[];

    final images = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('image/'))
        .map((f) => _absoluteUrl(f.filePath))
        .where((p) => p.isNotEmpty)
        .toList();

    photoPaths.assignAll(images.toList());

    // First audio/* -> absolute URL
    final firstAudio = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('audio/'))
        .map((f) => _absoluteUrlForAudio(f.filePath))
        .firstWhere(
          (p) => p.isNotEmpty,
          orElse: () => '',
        );
    voiceNotePath.value = firstAudio;

    // ----- Reporter -----
    final rFirst = (workOrderInfo.reportedBy?.firstName ?? '').trim();
    final rLast = (workOrderInfo.reportedBy?.lastName ?? '').trim();
    final rName = ('$rFirst $rLast').trim();
    reportedBy.value = rName.isEmpty ? 'Not available' : rName;

    // ----- Meta / summary -----
    date.value = _formatDate(workOrderInfo.createdAt);
    priority.value = workOrderInfo.priority;
    final t = (workOrderInfo.title).trim();
    workOrderTitle.value = t.isEmpty ? 'Not available' : t;
    final r = (workOrderInfo.remark ?? '').trim();
    remark.value = r.isEmpty ? 'Not available' : r;
    description.value = workOrderInfo.description;
  }

  // --------- Helpers ---------

  /// Makes an absolute URL:
  /// - returns empty string for null/empty
  /// - returns as-is if already absolute (http/https)
  /// - otherwise prefixes [Constant.BASE_URL] (with clean single slash)
  String _absoluteUrl(String? raw) {
    final p = (raw ?? '').trim();
    if (p.isEmpty) return '';
    final lower = p.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return 'https://picsum.photos/200/300'; //p;
    }
    // normalize slashes
    final base = Constant.BASE_URL.endsWith('/')
        ? Constant.BASE_URL.substring(0, Constant.BASE_URL.length - 1)
        : Constant.BASE_URL;
    final path = p.startsWith('/') ? p.substring(1) : p;
    return 'https://picsum.photos/200/300'; //'$base/$path';
  }

  String _absoluteUrlForAudio(String? raw) {
    final p = (raw ?? '').trim();
    if (p.isEmpty) return '';
    final lower = p.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3'; //p;
    }
    // normalize slashes
    final base = Constant.BASE_URL.endsWith('/')
        ? Constant.BASE_URL.substring(0, Constant.BASE_URL.length - 1)
        : Constant.BASE_URL;
    final path = p.startsWith('/') ? p.substring(1) : p;
    return 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3'; //'$base/$path';
  }

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

//   // Your navigation actions:
  Future<void> acceptWorkOrder() async {
    Get.toNamed(Routes.maintenanceEngeneerstartWorkOrderScreen);
  }

  Future<void> reAssignWorkOrder() async {
    Get.toNamed(Routes.maintenanceEngeneerreassignWorkOrderScreen);
  }
}
