// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/domain/repository_impl.dart'
    show RepositoryImpl;
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrderDetailsController extends GetxController {
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();
  final RepositoryImpl repositoryImpl = RepositoryImpl();

  final line = ''.obs;
  final cnc_1 = ''.obs;

  final title = 'Work Order Details'.obs;
  final successTitle = 'Work Order Created\nSuccessfully'.obs;
  final successSub = 'Work Order ID - BD265'.obs;

  final operatorName = ''.obs;
  final operatorInfo = ''.obs;
  final operatorPhoneNumber = ''.obs;
  final reportedBy = ''.obs;

  final descriptionText = ''.obs;
  final priority = ''.obs;
  final issueType = ''.obs;

  final time = ''.obs;
  final date = ''.obs;

  final location = ''.obs;
  //final headline = ''.obs;
  final problemDescription = ''.obs;

  final photoPaths = <String>[].obs;
  final voiceNotePath = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    cnc_1.value = 'CNC-1 (${_bag.get<String>(WOKeys.assetsNumber, '')})';
    reportedBy.value = _bag.get<String>(WOKeys.reporter, '');
    operatorName.value = _bag.get<String>(WOKeys.operatorName, '');
    operatorPhoneNumber.value = _bag.get<String>(WOKeys.phoneNumber, '');
    operatorInfo.value = _bag.get<String>(WOKeys.operatorInfo, '');
    issueType.value = _bag.get<String>(WOKeys.issueType, '');
    priority.value = _bag.get<String>(WOKeys.typeText, '');
    descriptionText.value = _bag.get<String>(WOKeys.descriptionText, '');
    //headline.value = _bag.get<String>(WOKeys.typeText, '');
    problemDescription.value = _bag.get<String>(WOKeys.problemDescription, '');
    final cleanedPhotos = <String>[];
    final seen = <String>{};
    for (final raw in _bag.get<List<String>>(WOKeys.photos, const <String>[])) {
      final p = raw.trim();
      if (p.isEmpty || !seen.add(p) || !_isImagePath(p)) continue;
      cleanedPhotos.add(p);
    }
    photoPaths.assignAll(cleanedPhotos);

    final voice = _bag.get(WOKeys.voiceNotePath, '').trim();
    voiceNotePath.value = _isAudioPath(voice) ? voice : '';

    final tStr = _bag.get<String?>(WOKeys.reportedTime, null);
    final dStr = _bag.get<String?>(WOKeys.reportedDate, null);
    final t = _decodeTime(tStr);
    final d = _decodeDate(dStr);
    time.value = t == null ? '' : _formatTime(t);
    date.value = d == null ? '' : _formatDate(d);

    final loc = _bag.get<String>(WOKeys.location, '');
    final plant = _bag.get<String>(WOKeys.plant, '');
    location.value = _joinNonEmpty([loc, plant], ' | ');
  }

  MediaFile _mediaFromPath(String path) {
    final p = path.trim();
    final lower = p.toLowerCase();
    String mime = 'application/octet-stream';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg'))
      mime = 'image/jpeg';
    else if (lower.endsWith('.png'))
      mime = 'image/png';
    else if (lower.endsWith('.webp'))
      mime = 'image/webp';
    else if (lower.endsWith('.heic'))
      mime = 'image/heic';
    else if (lower.endsWith('.mp4'))
      mime = 'video/mp4';
    else if (lower.endsWith('.mov'))
      mime = 'video/quicktime';
    else if (lower.endsWith('.m4a'))
      mime = 'audio/m4a';
    else if (lower.endsWith('.aac'))
      mime = 'audio/aac';
    else if (lower.endsWith('.mp3'))
      mime = 'audio/mpeg';
    else if (lower.endsWith('.wav')) mime = 'audio/wav';
    return MediaFile(filePath: p, fileType: mime);
  }

  String _joinNonEmpty(List<String> parts, String sep) =>
      parts.where((p) => p.trim().isNotEmpty).join(sep);

  void create() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      reportedBy.value = _bag.get<String>(WOKeys.reporter, '');
      operatorName.value = _bag.get<String>(WOKeys.operatorName, '');
      operatorPhoneNumber.value = _bag.get<String>(WOKeys.phoneNumber, '');
      operatorInfo.value = _bag.get<String>(WOKeys.operatorInfo, '');
      issueType.value = _bag.get<String>(WOKeys.issueType, '');
      priority.value = _bag.get<String>(WOKeys.typeText, '');
      descriptionText.value = _bag.get<String>(WOKeys.descriptionText, '');
      // headline.value = _bag.get<String>(WOKeys.typeText, '');
      problemDescription.value =
          _bag.get<String>(WOKeys.problemDescription, '');
      location.value = _joinNonEmpty(
        [
          _bag.get<String>(WOKeys.location, ''),
          _bag.get<String>(WOKeys.plant, '')
        ],
        ' | ',
      );

      final tStr = _bag.get<String?>(WOKeys.reportedTime, null);
      final dStr = _bag.get<String?>(WOKeys.reportedDate, null);
      final t = _decodeTime(tStr);
      final d = _decodeDate(dStr);
      time.value = t == null ? '' : _formatTime(t);
      date.value = d == null ? '' : _formatDate(d);
      final mediaFiles = <MediaFile>[];
      final cleanedPhotos = <String>[];
      final seen = <String>{};

      for (final raw
          in _bag.get<List<String>>(WOKeys.photos, const <String>[])) {
        final p = raw.trim();
        if (p.isEmpty || !seen.add(p) || !_isImagePath(p)) continue;
        cleanedPhotos.add(p);
        mediaFiles.add(_mediaFromPath(p)); // image only
      }

// voice note: do NOT add to photoPaths; only to mediaFiles
      final voice = _bag.get<String>(WOKeys.voiceNotePath, '').trim();
      if (voice.isNotEmpty && _isAudioPath(voice)) {
        voiceNotePath.value = voice;
        mediaFiles.add(_mediaFromPath(voice)); // audio only
      }

      photoPaths.assignAll(cleanedPhotos);

      final issueTypeId = _bag.get<String>(WOKeys.issueTypeId, '');
      final impactId = _bag.get<String>(WOKeys.impactId, '');
      final assetId = _bag.get<String>(WOKeys.assetsId, '');
      final plantId = _bag.get<String>(WOKeys.plantId, '');
      final departmentId = _bag.get<String>(WOKeys.departmentId, '');
      final shiftId = _bag.get<String>(WOKeys.shiftId, '');

      final schedStartStr =
          _bag.get<String?>(WOKeys.reportedAt, null) ?? '2025-02-01T07:00:00Z';
      final schedEndStr =
          _bag.get<String?>(WOKeys.reportedOn, null) ?? '2025-02-01T19:00:00Z';

      final typeEnum = WorkType.breakdownManagement;
      final priorityEnum = PriorityX.fromApi(priority.value);
      final statusEnum = WorkStatus.open;

      ///final titleText = issueType.value;
      final descText = problemDescription.value.isNotEmpty
          ? problemDescription.value
          : descriptionText.value;
      final remarkText = operatorInfo.value.isNotEmpty
          ? operatorInfo.value
          : 'Created from mobile app';

      final req = CreateWorkOrderRequest(
        type: typeEnum,
        priority: priorityEnum,
        status: statusEnum,
        title: "dsds", //titleText.trim(),
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
        mediaFiles: mediaFiles,
      );

      final res = await repositoryImpl.createWorkOrderRequest(req);

      if (res.httpCode == 201 && res.data != null) {
        // Get.offAllNamed(Routes.landingDashboardScreen, arguments: {'tab': 3});
        // _bag.clear();

        Get.snackbar(
          'Create',
          'Work Order Created Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.successGreen,
          colorText: AppColors.white,
        );
      } else {
        // Not OK
        Get.snackbar(
          'Create',
          res.message!,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() => Get.back();

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
      'Dec'
    ];
    final dd = d.day.toString().padLeft(2, '0');
    final mon = months[d.month - 1];
    return '$dd $mon';
  }

  bool _isImagePath(String p) {
    final x = p.toLowerCase().trim();
    return x.endsWith('.jpg') ||
        x.endsWith('.jpeg') ||
        x.endsWith('.png') ||
        x.endsWith('.webp') ||
        x.endsWith('.heic');
  }

  bool _isAudioPath(String p) {
    final x = p.toLowerCase().trim();
    return x.endsWith('.m4a') ||
        x.endsWith('.aac') ||
        x.endsWith('.mp3') ||
        x.endsWith('.wav');
  }
}
