import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WorkorderInfoController extends GetxController {
  // media
  final photos = <String>[].obs; // file paths
  final voiceNotePath = ''.obs; // file path of recorded audio
  final isRecording = false.obs; // UI state only (not persisted)

  static const _draftKey = 'work_order_info_draft_v1';
  final _box = GetStorage();

  // dropdown values
  final issueType = ''.obs;
  final impact = ''.obs;

  // inputs
  final assetsCtrl = TextEditingController();
  final problemCtrl = TextEditingController();

  // static/derived tiles
  final typeText = '-'.obs;
  final descriptionText = '-'.obs;

  // sample options
  final issueTypes = ['Electrical', 'Mechanical', 'Instrumentation'];
  final impacts = ['Low', 'Medium', 'High'];

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  @override
  void onClose() {
    assetsCtrl.dispose();
    problemCtrl.dispose();
    super.onClose();
  }

  // ---------- simple save/load ----------
  Map<String, dynamic> payload() => {
    'issueType': issueType.value,
    'impact': impact.value,
    'assetsNumber': assetsCtrl.text.trim(),
    'problemDescription': problemCtrl.text.trim(),
    'typeText': typeText.value,
    'descriptionText': descriptionText.value,
    // ✅ persist media too
    'photos': photos.toList(),
    'voiceNotePath': voiceNotePath.value,
  };

  void saveDraft() => _box.write(_draftKey, payload());

  void _loadDraft() {
    final data = _box.read(_draftKey);
    if (data is Map) {
      final json = Map<String, dynamic>.from(data);

      issueType.value = (json['issueType'] ?? '') as String;
      impact.value = (json['impact'] ?? '') as String;
      assetsCtrl.text = (json['assetsNumber'] ?? '') as String;
      problemCtrl.text = (json['problemDescription'] ?? '') as String;
      typeText.value = (json['typeText'] ?? '-') as String;
      descriptionText.value = (json['descriptionText'] ?? '-') as String;

      final ph = json['photos'];
      if (ph is List) photos.assignAll(ph.map((e) => e.toString()));
      voiceNotePath.value = (json['voiceNotePath'] ?? '') as String;
    }
  }

  // ---------- helpers (call these from the page UI) ----------
  void setAssetMeta({required String type, required String description}) {
    typeText.value = type;
    descriptionText.value = description;
    saveDraft();
  }

  void addPhoto(String path) {
    photos.add(path);
    saveDraft();
  }

  void addPhotos(Iterable<String> paths) {
    photos.addAll(paths);
    saveDraft();
  }

  void removePhotoAt(int index) {
    photos.removeAt(index);
    saveDraft();
  }

  void clearPhotos() {
    photos.clear();
    saveDraft();
  }

  void setVoiceNote(String path) {
    voiceNotePath.value = path;
    saveDraft();
  }

  void clearVoiceNote() {
    voiceNotePath.value = '';
    saveDraft();
  }

  // ---------- submit ----------
  void goToWorkOrderDetailScreen() {
    // (optional) quick required checks
    final missing = <String>[];
    if (issueType.value.isEmpty) missing.add('Issue Type');
    if (impact.value.isEmpty) missing.add('Impact');
    if (assetsCtrl.text.trim().isEmpty) missing.add('Assets Number');
    if (problemCtrl.text.trim().isEmpty) missing.add('Problem Description');

    if (missing.isNotEmpty) {
      Get.snackbar(
        'Missing Info',
        'Please fill: ${missing.join(', ')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
      return;
    }

    saveDraft(); // persist before leaving
    Get.snackbar(
      'Create',
      'Work order saved',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryBlue,
      colorText: AppColors.white,
    );
    Get.toNamed(Routes.workOrderDetailScreen, arguments: payload());
  }
}
