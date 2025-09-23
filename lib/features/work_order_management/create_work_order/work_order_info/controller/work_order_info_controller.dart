// lib/.../work_order_info/controller/workorder_info_controller.dart
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/work_order_info/ui/work_order_info_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkorderInfoController extends GetxController {
  // Read all hard-coded defaults/lookups from ONE place
  // Later, replace WorkOrderConfig.demo with what you parse from server JSON.
  final WorkOrderConfig cfg = WorkOrderConfig.demo;

  // Operator footer (editable)
  late final RxString operatorName;
  late final RxString operatorMobileNumber;
  late final RxString operatorInfo;

  // Media (local; saved to bag only when moving)
  final photos = <String>[].obs;
  final voiceNotePath = ''.obs;
  final isRecording = false.obs; // UI flag only

  // Dropdowns / inputs
  final issueType = ''.obs; // Electrical / Mechanical / Instrumentation
  final impact = ''.obs; // Low / Medium / High
  final assetsCtrl = TextEditingController();
  final problemCtrl = TextEditingController();

  // Derived from asset
  late final RxString typeText;
  late final RxString descriptionText;

  // Options (come from cfg)
  List<String> get issueTypes => cfg.issueTypes;
  List<String> get impacts => cfg.impacts;

  late final VoidCallback _assetListener;
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  // Quick index for assets (for fast lookups)
  late final Map<String, AssetConfig> _assetIndex = {
    for (final a in cfg.assets) a.number.toUpperCase(): a,
  };

  @override
  void onInit() {
    super.onInit();

    // Initialize reactive fields from the single model
    operatorName = cfg.operatorName.obs;
    operatorMobileNumber = cfg.operatorMobileNumber.obs;
    operatorInfo = cfg.operatorInfo.obs;

    typeText = cfg.typeText.obs;
    descriptionText = cfg.descriptionText.obs;

    // If revisiting this tab, hydrate from bag (may overwrite defaults)
    _hydrateFromBag();

    // Keep derived fields in sync locally (no persistence yet)
    _assetListener = () => applyAssetMetaFor(assetsCtrl.text);
    assetsCtrl.addListener(_assetListener);
  }

  @override
  void onClose() {
    assetsCtrl
      ..removeListener(_assetListener)
      ..dispose();
    problemCtrl.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hydrate from bag (when coming back to this screen)
  // (If bag is empty, UI keeps the defaults from cfg)
  // ─────────────────────────────────────────────────────────────────────────
  void _hydrateFromBag() {
    // If you still use WOKeys (from your bag impl), keep as-is; otherwise
    // you can switch the bag to store the typed WorkOrderDraft directly.
    // Keeping your existing pattern here:

    issueType.value = _bag.get<String>('issueType', issueType.value);
    impact.value = _bag.get<String>('impact', impact.value);
    assetsCtrl.text = _bag.get<String>('assetsNumber', assetsCtrl.text);
    problemCtrl.text = _bag.get<String>('problemDescription', problemCtrl.text);

    typeText.value = _bag.get<String>('typeText', typeText.value);
    descriptionText.value =
        _bag.get<String>('descriptionText', descriptionText.value);

    final ph = _bag.get<List?>('photos', const []) ?? const [];
    photos.assignAll(ph.map((e) => e.toString()));
    voiceNotePath.value =
        _bag.get<String>('voiceNotePath', voiceNotePath.value);

    operatorName.value = _bag.get<String>('operatorName', operatorName.value);
    operatorMobileNumber.value =
        _bag.get<String>('operatorMobileNumber', operatorMobileNumber.value);
    operatorInfo.value = _bag.get<String>('operatorInfo', operatorInfo.value);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Save ONLY when moving screens/tabs
  // ─────────────────────────────────────────────────────────────────────────
  void saveToBag() {
    _bag.merge({
      'issueType': issueType.value,
      'impact': impact.value,
      'assetsNumber': assetsCtrl.text.trim(),
      'problemDescription': problemCtrl.text.trim(),
      'typeText': typeText.value,
      'descriptionText': descriptionText.value,
      'photos': photos.toList(),
      'voiceNotePath': voiceNotePath.value,
      'operatorName': operatorName.value,
      'operatorMobileNumber': operatorMobileNumber.value,
      'operatorInfo': operatorInfo.value,
    });
  }

  /// Call from UI before leaving this page / switching tab
  void beforeNavigate(VoidCallback navigate) {
    saveToBag();
    navigate();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Local mutations (NOT persisted until saveToBag/beforeNavigate)
  // ─────────────────────────────────────────────────────────────────────────
  void updateOperatorFooter({String? name, String? mobile, String? info}) {
    if (name != null) operatorName.value = name;
    if (mobile != null) operatorMobileNumber.value = mobile;
    if (info != null) operatorInfo.value = info;
  }

  void setAssetMeta({required String type, required String description}) {
    typeText.value = type;
    descriptionText.value = description;
  }

  void applyAssetMetaFor(String input) {
    final key = input.trim().toUpperCase();
    final hit = _assetIndex[key];
    if (hit != null) {
      setAssetMeta(type: hit.type, description: hit.description);
    }
  }

  // Media (local only)
  void addPhoto(String path) => photos.add(path);
  void addPhotos(Iterable<String> paths) => photos.addAll(paths);
  void removePhotoAt(int index) {
    if (index < 0 || index >= photos.length) return;
    photos.removeAt(index);
  }

  void clearPhotos() => photos.clear();
  void setVoiceNote(String path) => voiceNotePath.value = path;
  void clearVoiceNote() => voiceNotePath.value = '';

  // ───────── Validate & Navigate (no route args; next screen reads WorkOrderBag)
  void goToWorkOrderDetailScreen() {
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

    saveToBag();
    Get.toNamed(Routes.workOrderDetailScreen);
  }

  // Picker wrapper
  Future<void> openAssetPicker(BuildContext context) async {
    await pickFromList(
      context: context,
      title: 'Select Asset Number',
      items: cfg.assets.map((e) => e.number).toList(),
      onSelected: (selectedNumber) {
        assetsCtrl.text = selectedNumber;
        applyAssetMetaFor(selectedNumber);
        // Not saving here — saved on navigate
      },
    );
  }
}

// DUMMY DATA
//==============================

class WorkOrderConfig {
  // Operator defaults
  final String operatorName;
  final String operatorMobileNumber;
  final String operatorInfo;

  // Derived defaults
  final String typeText;
  final String descriptionText;

  // Lookups
  final List<String> issueTypes;
  final List<String> impacts;

  // Asset catalog
  final List<AssetConfig> assets;

  const WorkOrderConfig({
    required this.operatorName,
    required this.operatorMobileNumber,
    required this.operatorInfo,
    required this.typeText,
    required this.descriptionText,
    required this.issueTypes,
    required this.impacts,
    required this.assets,
  });

  /// A single, hard-coded instance (you can later replace this with server JSON)
  static const demo = WorkOrderConfig(
    operatorName: 'Ajay Kumar (MP18292)',
    operatorMobileNumber: '9876543211',
    operatorInfo: 'Assets Shop | 12:20 | 03 Sept | A',
    typeText: 'Critical for testing',
    descriptionText:
        'CNC Vertical Assets Center where we make housing for testing',
    issueTypes: ['Electrical', 'Mechanical', 'Instrumentation'],
    impacts: ['Low', 'Medium', 'High'],
    assets: [
      AssetConfig(
        number: '1001',
        type: 'High',
        description: 'High - CNC Vertical Assets Center where we make housing',
      ),
      AssetConfig(
        number: '1002',
        type: 'Critical',
        description:
            'Critical - CNC Vertical Assets Center where we make housing',
      ),
      AssetConfig(
        number: '1003',
        type: 'Medium',
        description:
            'Medium - CNC Vertical Assets Center where we make housing',
      ),
      AssetConfig(
        number: '1004',
        type: 'Low',
        description: 'Low CNC Vertical Assets Center where we make housing',
      ),
    ],
  );
}

class AssetConfig {
  final String number;
  final String type;
  final String description;
  const AssetConfig({
    required this.number,
    required this.type,
    required this.description,
  });
}
