// work_order_details_controller.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/database/db_repository/offline_work_order_repository.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/offline_work_order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WorkOrderDetailsController extends GetxController {
  final repository = Get.find<DBRepository>();
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  // Header / UI labels
  final title = 'Work Order Details'.obs;
  final successTitle = 'Work Order Created\nSuccessfully'.obs;
  final successSub = 'Work Order ID - BD265'.obs;

  // Misc shown on UI
  final line = ''.obs;
  final cnc_1 = ''.obs;

  // People
  final operatorName = ''.obs;
  final operatorInfo = ''.obs;
  final operatorPhoneNumber = ''.obs;
  final reportedName = ''.obs;

  // Details
  final descriptionText = ''.obs;
  final priority = ''.obs;
  final issueType = ''.obs;
  final problemTitle = ''.obs;
  final problemDescription = ''.obs;

  // When/Where
  final time = ''.obs; // "HH:mm"
  final date = ''.obs; // "dd Mon"
  final location = ''.obs; // "Dept | Plant"

  // Media
  final photoPaths = <String>[].obs; // file paths OR URLs
  final voiceNotePath = ''.obs; // file path OR URL

  // State
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Header with asset number if present
    final assetNumber = _bag.get<String>(WOKeys.assetsNumber, '');
    cnc_1.value = 'CNC-1 (${assetNumber.isEmpty ? '-' : assetNumber})';

    // Reporter / Operator basics
    reportedName.value = _bag.get<String>(WOKeys.reporterName, '');
    final isSameAsOperator = _bag.get<String>(WOKeys.sameAsOperator, 'false');
    if (isSameAsOperator == 'true') {
      _initDefaults();
    } else {
      operatorName.value = _bag.get<String>(WOKeys.operatorName, '');
      operatorPhoneNumber.value =
          _bag.get<String>(WOKeys.operatorPhoneNumber, '');
    }

    // Types / Priority / Descriptions
    issueType.value = _bag.get<String>(WOKeys.issueType, '');
    priority.value = _bag.get<String>(WOKeys.typeText, '');
    descriptionText.value = _bag.get<String>(WOKeys.descriptionText, '');
    problemTitle.value = _bag.get<String>(WOKeys.title, '');
    problemDescription.value = _bag.get<String>(WOKeys.problemDescription, '');

    // Media: accept file paths & URLs
    final cleanedPhotos = <String>[];
    final seen = <String>{};
    for (final raw in _bag.get<List<String>>(WOKeys.photos, const <String>[])) {
      final p = raw.trim();
      if (p.isEmpty || !seen.add(p)) continue;
      if (_isUrl(p) || _isLocalImagePath(p)) {
        cleanedPhotos.add(p);
      }
    }
    photoPaths.assignAll(cleanedPhotos);

    final voice = _bag.get<String>(WOKeys.voiceNotePath, '').trim();
    if (voice.isNotEmpty && (_isUrl(voice) || _isLocalAudioPath(voice))) {
      voiceNotePath.value = voice;
    } else {
      voiceNotePath.value = '';
    }

    // Time / Date
    final tStr = _bag.get<String?>(WOKeys.reportedTime, null);
    final dStr = _bag.get<String?>(WOKeys.reportedDate, null);
    final t = _decodeTime(tStr);
    final d = _decodeDate(dStr);
    time.value = t == null ? '' : _formatTime(t);
    date.value = d == null ? '' : _formatDate(d);

    // Location (Department | Plant)
    final loc = _bag.get<String>(WOKeys.location, '');
    final plant = _bag.get<String>(WOKeys.plant, '');
    location.value = _joinNonEmpty([loc, plant], ' | ');
  }

  // Load operator defaults from DB
  void _initDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    final loginPerson = prefs.getString(Constant.loginPersonId);
    if (loginPerson == null) return;

    final details = await repository.getPersonById(loginPerson);
    if (details == null) return;

    operatorName.value = '${details.name}(${details.id})';
    if (details.contacts.isNotEmpty && details.contacts.first.phone != null) {
      operatorPhoneNumber.value = details.contacts.first.phone!;
    }

    final dt = (details.updatedAt ?? DateTime.now()).toUtc();
    final s = formatTimeDateLocal(dt);

    if (details.assets.isNotEmpty) {
      operatorInfo.value =
          '${details.assets.first.assetName} | $s | ${details.assets.first.assetSerialNumber}';
    }
  }

  /// e.g. DateTime(2025,10,13,05,34,36,926,277).toUtc()
  String formatTimeDateLocal(DateTime dt) {
    final d = dt.isUtc ? dt.toLocal() : dt;
    final time = DateFormat('HH:mm').format(d);
    final day = DateFormat('dd').format(d);
    final mon = DateFormat('MMM').format(d).toLowerCase();
    return '$time | $day $mon';
  }

  // Create Work Order (builds media from both local + URL entries)
  Future<void> create() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      // Re-read latest bag
      reportedName.value = _bag.get<String>(WOKeys.reporterName, '');
      final reporterId = _bag.get<String>(WOKeys.reporterId, '');
      final reporterPhoneNumber =
          _bag.get<String>(WOKeys.reporterPhoneNumber, '');
      final isSameAsOperator = _bag.get<String>(WOKeys.sameAsOperator, 'false');

      operatorName.value = _bag.get<String>(WOKeys.operatorName, '');
      operatorPhoneNumber.value =
          _bag.get<String>(WOKeys.operatorPhoneNumber, '');
      var operatorId = _bag.get<String>(WOKeys.operatorId, '');

      issueType.value = _bag.get<String>(WOKeys.issueType, '');
      priority.value = _bag.get<String>(WOKeys.typeText, '');
      descriptionText.value = _bag.get<String>(WOKeys.descriptionText, '');
      problemTitle.value = _bag.get<String>(WOKeys.title, '');
      problemDescription.value =
          _bag.get<String>(WOKeys.problemDescription, '');

      location.value = _joinNonEmpty(
        [
          _bag.get<String>(WOKeys.location, ''),
          _bag.get<String>(WOKeys.plant, ''),
        ],
        ' | ',
      );

      final tStr = _bag.get<String?>(WOKeys.reportedTime, null);
      final dStr = _bag.get<String?>(WOKeys.reportedDate, null);
      final t = _decodeTime(tStr);
      final d = _decodeDate(dStr);
      time.value = t == null ? '' : _formatTime(t);
      date.value = d == null ? '' : _formatDate(d);

      // Build media list
      final mediaFiles = <MediaFile>[];
      final cleanedPhotos = <String>[];
      final seen = <String>{};

      for (final raw
          in _bag.get<List<String>>(WOKeys.photos, const <String>[])) {
        final p = raw.trim();
        if (p.isEmpty || !seen.add(p)) continue;
        if (_isUrl(p) || _isLocalImagePath(p)) {
          cleanedPhotos.add(p);
          mediaFiles.add(_mediaFromPath(p));
        }
      }
      final voice = _bag.get<String>(WOKeys.voiceNotePath, '').trim();
      if (voice.isNotEmpty && (_isUrl(voice) || _isLocalAudioPath(voice))) {
        voiceNotePath.value = voice;
        mediaFiles.add(_mediaFromPath(voice));
      }
      photoPaths.assignAll(cleanedPhotos);

      // IDs / schedule
      final issueTypeId = _bag.get<String>(WOKeys.issueTypeId, '');
      final impactId = _bag.get<String>(WOKeys.impactId, '');
      final assetId = _bag.get<String>(WOKeys.assetsId, '');
      final plantId = _bag.get<String>(WOKeys.plantId, '');
      final departmentId = _bag.get<String>(WOKeys.locationId, '');
      final shiftId = _bag.get<String>(WOKeys.shiftId, '');

      final schedStartStr =
          _bag.get<String?>(WOKeys.reportedAt, null) ?? '2025-02-01T07:00:00Z';
      final schedEndStr =
          _bag.get<String?>(WOKeys.reportedOn, null) ?? '2025-02-01T19:00:00Z';

      final typeEnum = WorkType.breakdownManagement;
      final priorityEnum = PriorityX.fromApi(priority.value);
      final statusEnum = WorkStatus.open;
      final title = problemTitle.value.isNotEmpty ? problemTitle.value : "";
      final descText = problemDescription.value.isNotEmpty
          ? problemDescription.value
          : descriptionText.value;
      final remarkText = operatorInfo.value.isNotEmpty
          ? operatorInfo.value
          : 'Created from mobile app';

      if (isSameAsOperator == 'true') {
        operatorId = reporterId;
      }

      final req = CreateWorkOrderRequest(
        operatorId: operatorId,
        operatorName: operatorName.value,
        operatorPhoneNumber: operatorPhoneNumber.value,
        reporterById: reporterId,
        reporterName: reportedName.value,
        reporterPhoneNumber: reporterPhoneNumber,
        type: typeEnum,
        priority: priorityEnum,
        status: statusEnum,
        title: issueType.value.isNotEmpty ? issueType.value : 'Work Order',
        description: descText.trim(),
        remark: remarkText.trim(),
        scheduledStart: DateTime.parse(schedStartStr).toUtc(),
        scheduledEnd: DateTime.parse(schedEndStr).toUtc(),
        assetId: assetId,
        plantId: plantId,
        departmentId: departmentId,
        issueTypeId: issueTypeId,
        impactId: impactId,
        shiftId: shiftId,
        mediaFiles: mediaFiles, // <- mix of URL and local file references
      );

      await createWorkOrder(req);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createWorkOrder(CreateWorkOrderRequest req) async {
    final offlineRepo = Get.find<OfflineWorkOrderRepository>();

    try {
      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity == ConnectivityResult.none) {
        await _saveOffline(req, offlineRepo);
      } else {
        final res = await repositoryImpl.createWorkOrderRequest(req);

        if (res.httpCode == 201 && res.data != null) {
          Get.snackbar(
            'Create',
            'Work Order created successfully (Issue No: ${res.data?.issueNo ?? "N/A"})',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.successGreen,
            colorText: AppColors.white,
          );
        } else {
          await _saveOffline(req, offlineRepo);
        }
      }
    } catch (e) {
      await _saveOffline(req, offlineRepo);
      if (kDebugMode) {
        print('❌ Error creating Work Order online: $e');
      }
    }

    Get.offAllNamed(
      Routes.landingDashboardScreen,
      arguments: {'tab': 3},
    );
  }

  Future<void> _saveOffline(
    CreateWorkOrderRequest req,
    OfflineWorkOrderRepository offlineRepo,
  ) async {
    final offlineOrder = OfflineWorkOrder(
      operatorId: req.operatorId,
      operatorName: req.operatorName,
      operatorPhoneNumber: req.operatorPhoneNumber,
      reporterId: req.reporterById,
      reporterName: req.reporterName,
      reporterPhoneNumber: req.reporterPhoneNumber,
      type: req.type.name,
      priority: req.priority.name,
      status: req.status.name,
      title: req.title,
      description: req.description,
      remark: req.remark,
      scheduledStart: req.scheduledStart,
      scheduledEnd: req.scheduledEnd,
      assetId: req.assetId,
      plantId: req.plantId,
      departmentId: req.departmentId,
      issueTypeId: req.issueTypeId,
      impactId: req.impactId,
      shiftId: req.shiftId,
      mediaFiles: req.mediaFiles,
      createdAt: DateTime.now(),
    );

    await offlineRepo.insertOfflineOrder(offlineOrder);

    Get.snackbar(
      'Offline',
      'No internet. Work order saved locally and will sync later.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.yellow,
      colorText: Colors.black,
    );
  }

  void goBack() => Get.back();

  // ───────────── Helpers ─────────────
  String _joinNonEmpty(List<String> parts, String sep) =>
      parts.where((p) => p.trim().isNotEmpty).join(sep);

  MediaFile _mediaFromPath(String path) {
    final p = path.trim();
    final lower = p.toLowerCase();

    // Guess MIME from extension (works for both URL & local)
    String mime = 'application/octet-stream';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      mime = 'image/jpeg';
    } else if (lower.endsWith('.png')) {
      mime = 'image/png';
    } else if (lower.endsWith('.webp')) {
      mime = 'image/webp';
    } else if (lower.endsWith('.heic')) {
      mime = 'image/heic';
    } else if (lower.endsWith('.mp4')) {
      mime = 'video/mp4';
    } else if (lower.endsWith('.mov')) {
      mime = 'video/quicktime';
    } else if (lower.endsWith('.m4a')) {
      mime = 'audio/m4a';
    } else if (lower.endsWith('.aac')) {
      mime = 'audio/aac';
    } else if (lower.endsWith('.mp3')) {
      mime = 'audio/mpeg';
    } else if (lower.endsWith('.wav')) {
      mime = 'audio/wav';
    } else if (_isUrl(lower)) {
      // If URL without extension, you can keep generic or add heuristics
      // (server may accept URL as-is)
      mime = 'application/octet-stream';
    }
    return MediaFile(filePath: p, fileType: mime);
  }

  bool _isUrl(String p) => p.toLowerCase().startsWith('http');

  bool _isLocalImagePath(String p) {
    final x = p.toLowerCase().trim();
    return x.endsWith('.jpg') ||
        x.endsWith('.jpeg') ||
        x.endsWith('.png') ||
        x.endsWith('.webp') ||
        x.endsWith('.heic');
  }

  bool _isLocalAudioPath(String p) {
    final x = p.toLowerCase().trim();
    return x.endsWith('.m4a') ||
        x.endsWith('.aac') ||
        x.endsWith('.mp3') ||
        x.endsWith('.wav');
  }

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
