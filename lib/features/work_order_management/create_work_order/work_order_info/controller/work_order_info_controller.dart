// lib/.../work_order_info/controller/workorder_info_controller.dart
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/database/db_repository/assets_repository.dart';
import 'package:easy_ops/database/db_repository/login_person_details_repository.dart';
import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/work_order_info/ui/work_order_info_page.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WorkorderInfoController extends GetxController {
  // ─────────────────────────────────────────────────────────────────────────
  // Dependencies & config
  // ─────────────────────────────────────────────────────────────────────────
  final lookupRepository = Get.find<LookupRepository>();
  final assetRepository = Get.find<AssetRepository>();
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  final loginPersonDetailsRepository = Get.find<LoginPersonDetailsRepository>();

  //final WorkOrderConfig cfg = WorkOrderConfig.demo;

  // ─────────────────────────────────────────────────────────────────────────
  // UI state: operator footer (editable)
  // ─────────────────────────────────────────────────────────────────────────
  final operatorName = '-'.obs;
  final operatorMobileNumber = '-'.obs;
  final operatorInfo = '-'.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // UI state: media
  // ─────────────────────────────────────────────────────────────────────────
  final photos = <String>[].obs;
  final voiceNotePath = ''.obs;
  final isRecording = false.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // Inputs
  // ─────────────────────────────────────────────────────────────────────────
  final assetsCtrl = TextEditingController();
  final problemCtrl = TextEditingController();

  // Derived from selected asset
  final typeText = '—'.obs; // asset.criticality
  final descriptionText = '—'.obs; // asset.description

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdowns: options + selected
  // ─────────────────────────────────────────────────────────────────────────
  final issueTypeOptions = <LookupValues>[].obs;
  final impactOptions = <LookupValues>[].obs;

  final selectedIssueTypeId = ''.obs;
  final selectedImpactId = ''.obs;
  final assetsId = ''.obs;

  // legacy labels (kept for compatibility with existing bag keys)
  final issueType = ''.obs;
  final impact = ''.obs;

  // assets cache + serial index
  final List<AssetItem> _storeAssets = <AssetItem>[];
  final Map<String, AssetItem> _assetId = <String, AssetItem>{};

  late final VoidCallback _assetListener;

  WorkOrder? workOrderInfo;
  WorkOrderStatus? workOrderStatus;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() async {
    super.onInit();

    final workTabsController = Get.find<WorkTabsController>();
    workOrderInfo = workTabsController.workOrder;
    workOrderStatus = workTabsController.workOrderStatus;
    if (workOrderInfo != null && workOrderStatus != null) {
      _bag.merge({
        WOKeys.issueTypeId:
            'CLU-24Sep2025120750334005', //workOrderInfo.issueTypeId,
        WOKeys.impactId: workOrderInfo?.impactId,
        WOKeys.assetsId: workOrderInfo?.asset.id,
        WOKeys.issueType: issueType.value,
        WOKeys.impact: impact.value,
        WOKeys.assetsNumber: assetsCtrl.text.trim(),
        WOKeys.problemDescription: problemCtrl.text.trim(),
        WOKeys.typeText: typeText.value,
        WOKeys.descriptionText: descriptionText.value,
        WOKeys.photos: photos.toList(),
        WOKeys.voiceNotePath: voiceNotePath.value,
        WOKeys.operatorName: operatorName.value,
        WOKeys.operatorMobileNumber: operatorMobileNumber.value,
        WOKeys.operatorInfo: operatorInfo.value,
        //WOKeys.asset: assetsCtrl.text.trim(),
      });

      //operatorInfo.value = '-'.obs;
    }

    _initDefaults();
    _initAsync();
    _assetListener = () => _applyMetaIfSerialMatch(assetsCtrl.text);
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
  // Init helpers
  // ─────────────────────────────────────────────────────────────────────────
  void _initDefaults() async {
    // operatorName.value = 'Ajay Kumar (MP18292)';
    // operatorMobileNumber.value = '9876543211';
    // operatorInfo.value = 'Assets Shop | 12:20 | 03 Sept | A';

    final prefs = await SharedPreferences.getInstance();
    final loginPerson = prefs.getString(Constant.loginPersonId); // String?
    final details =
        await loginPersonDetailsRepository.getPersonById(loginPerson!);
    operatorName.value = '${details!.name}(${details.id})';
    operatorMobileNumber.value = details.contacts[0].phone!;
    // ignore: prefer_interpolation_to_compose_strings
    final dt = DateTime.parse('2025-10-13T05:34:36.926277Z'); // UTC
    final s = formatTimeDateLocal(dt); // => "11:04 | 13 oct" in Asia/Kolkata
    operatorInfo.value =
        '${details.assets.first.assetName} | $s | ${details.assets.first.assetSerialNumber}';
    typeText.value = '—';
    descriptionText.value = '—';

    // selected dropdown defaults -> placeholders (empty id)
    selectedIssueTypeId.value = '';
    selectedImpactId.value = '';
  }

  /// e.g. DateTime(2025,10,13,05,34,36,926,277).toUtc()
  String formatTimeDateLocal(DateTime dt) {
    final d = dt.isUtc ? dt.toLocal() : dt; // convert if it's UTC (ends with Z)
    final time = DateFormat('HH:mm').format(d); // 24h: 02:30
    final day = DateFormat('dd').format(d); // 02
    final mon = DateFormat('MMM').format(d).toLowerCase(); // oct
    return '$time | $day $mon';
  }

  Future<void> _initAsync() async {
    await _loadLookups();
    await _loadAssets();

    _rebuildAssetSerialIndex();
    _hydrateFromBag();
  }

  Future<void> _loadLookups() async {
    final impact = await lookupRepository.getLookupByType(LookupType.impact);
    final issue = await lookupRepository.getLookupByType(LookupType.issuetype);

    issueTypeOptions.assignAll([
      _placeholderOption('Select Issue Type', LookupType.issuetype),
      ...issue,
    ]);

    impactOptions.assignAll([
      _placeholderOption('Select Impact Type', LookupType.impact),
      ...impact,
    ]);
  }

  Future<void> _loadAssets() async {
    final assetsId = 'AST-24Sep2025130416546006';
    // pulls once; if you want reactive, expose a stream in repository
    final list = await assetRepository.getAllAssets();
    _storeAssets
      ..clear()
      ..addAll(list);
  }

  LookupValues _placeholderOption(String label, LookupType t) {
    return LookupValues(
      id: '',
      code: '',
      displayName: label,
      description: '',
      lookupType: t,
      sortOrder: -1,
      recordStatus: 1,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      clientId: '',
    );
    // note: we use empty id ("") as placeholder sentinel
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Bag hydration & saving
  // ─────────────────────────────────────────────────────────────────────────
  void _hydrateFromBag() {
    // preferred ids
    final bagIssueTypeId = _bag.get<String>('issueTypeId', '');
    final bagImpactId = _bag.get<String>('impactId', '');

    if (bagIssueTypeId.isNotEmpty) selectedIssueTypeId.value = bagIssueTypeId;
    if (bagImpactId.isNotEmpty) selectedImpactId.value = bagImpactId;

    // legacy labels
    final issueTypeLabel = _bag.get<String>('issueType', issueType.value);
    final impactLabel = _bag.get<String>('impact', impact.value);

    // try label->id when id missing
    _maybeFixSelectedIdFromLabel(
      selectedIssueTypeId,
      issueTypeOptions,
      issueTypeLabel,
    );
    _maybeFixSelectedIdFromLabel(
      selectedImpactId,
      impactOptions,
      impactLabel,
    );

    // keep legacy
    issueType.value = issueTypeLabel;
    impact.value = impactLabel;

    // other fields
    assetsCtrl.text = _bag.get<String>(WOKeys.assetsNumber, assetsCtrl.text);
    problemCtrl.text =
        _bag.get<String>(WOKeys.problemDescription, problemCtrl.text);

    typeText.value = _bag.get<String>(WOKeys.typeText, typeText.value);
    descriptionText.value =
        _bag.get<String>(WOKeys.descriptionText, descriptionText.value);

    final ph = _bag.get<List?>(WOKeys.photos, const []) ?? const [];
    photos.assignAll(ph.map((e) => e.toString()));
    voiceNotePath.value =
        _bag.get<String>(WOKeys.voiceNotePath, voiceNotePath.value);

    operatorName.value =
        _bag.get<String>(WOKeys.operatorName, operatorName.value);
    operatorMobileNumber.value = _bag.get<String>(
        WOKeys.operatorMobileNumber, operatorMobileNumber.value);
    operatorInfo.value =
        _bag.get<String>(WOKeys.operatorInfo, operatorInfo.value);

    // bind asset-derived fields if serial present
    _applyMetaIfSerialMatch(assetsCtrl.text);
  }

  void saveToBag() {
    _bag.merge({
      WOKeys.issueTypeId: selectedIssueTypeId.value,
      WOKeys.impactId: selectedImpactId.value,
      WOKeys.assetsId: assetsId.value,
      WOKeys.issueType: issueType.value,
      WOKeys.impact: impact.value,
      WOKeys.assetsNumber: assetsCtrl.text.trim(),
      WOKeys.problemDescription: problemCtrl.text.trim(),
      WOKeys.typeText: typeText.value,
      WOKeys.descriptionText: descriptionText.value,
      WOKeys.photos: photos.toList(),
      WOKeys.voiceNotePath: voiceNotePath.value,
      WOKeys.operatorName: operatorName.value,
      WOKeys.operatorMobileNumber: operatorMobileNumber.value,
      WOKeys.operatorInfo: operatorInfo.value,
      //WOKeys.asset: assetsCtrl.text.trim(),
    });
  }

  void beforeNavigate(VoidCallback navigate) {
    saveToBag();
    navigate();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Asset helpers
  // ─────────────────────────────────────────────────────────────────────────
  void _rebuildAssetSerialIndex() {
    _assetId.clear();
    for (final it in _storeAssets) {
      final key = (it.serialNumber ?? '').trim().toUpperCase();
      if (key.isNotEmpty) _assetId[key] = it;
    }
  }

  void _applyMetaIfSerialMatch(String input) {
    final key = input.trim().toUpperCase();
    final item = _assetId[key];
    if (item != null) _applyAssetFromItem(item);
  }

  void _applyAssetFromItem(AssetItem item) {
    final id = (item.id ?? '').trim();
    final sn = (item.serialNumber ?? '').trim();
    if (sn.isNotEmpty && assetsCtrl.text.trim() != sn) {
      assetsCtrl.text = sn;
      assetsId.value = id;
    }
    _setAssetMeta(type: item.criticality, description: item.description ?? '');
  }

  void _setAssetMeta({required String type, required String description}) {
    typeText.value = type;
    descriptionText.value = description;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UI event helpers
  // ─────────────────────────────────────────────────────────────────────────
  void updateOperatorFooter({String? name, String? mobile, String? info}) {
    if (name != null) operatorName.value = name;
    if (mobile != null) operatorMobileNumber.value = mobile;
    if (info != null) operatorInfo.value = info;
  }

  void addPhoto(String path) => photos.add(path);
  void addPhotos(Iterable<String> paths) => photos.addAll(paths);
  void removePhotoAt(int index) {
    if (index < 0 || index >= photos.length) return;
    photos.removeAt(index);
  }

  void clearPhotos() => photos.clear();

  void setVoiceNote(String path) => voiceNotePath.value = path;
  void clearVoiceNote() => voiceNotePath.value = '';

  // ─────────────────────────────────────────────────────────────────────────
  // Validation & navigation
  // ─────────────────────────────────────────────────────────────────────────
  List<String> _validate() {
    final missing = <String>[];

    if (selectedIssueTypeId.value.isEmpty) missing.add('Issue Type');
    if (selectedImpactId.value.isEmpty) missing.add('Impact');

    if (assetsCtrl.text.trim().isEmpty) missing.add('Assets Number');
    if (problemCtrl.text.trim().isEmpty) missing.add('Problem Description');

    if (photos.isEmpty) missing.add('At least one Photo');
    if (voiceNotePath.value.isEmpty) missing.add('Voice Note');

    return missing;
  }

  void goToWorkOrderDetailScreen() {
    final missing = _validate();
    if (missing.isNotEmpty) {
      _showError('Missing Info', 'Please fill: ${missing.join(', ')}');
      return;
    }
    saveToBag();
    Get.toNamed(Routes.workOrderDetailScreen);
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.red,
      colorText: AppColors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Small utilities
  // ─────────────────────────────────────────────────────────────────────────
  void _maybeFixSelectedIdFromLabel(
    RxString selectedId,
    List<LookupValues> options,
    String label,
  ) {
    if (selectedId.value.isNotEmpty || label.isEmpty) return;
    final hit = _firstWhereOrNull<LookupValues>(
      options,
      (e) => e.displayName.trim().toLowerCase() == label.trim().toLowerCase(),
    );
    if (hit != null) selectedId.value = hit.id;
  }

  T? _firstWhereOrNull<T>(Iterable<T> it, bool Function(T) test) {
    for (final e in it) {
      if (test(e)) return e;
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Asset picker
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> openAssetPickerFromStore(BuildContext context) async {
    _rebuildAssetSerialIndex(); // refresh index in case assets changed

    final picked = await showModalBottomSheet<AssetItem>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AssetSerialSearchSheet(items: _storeAssets),
    );

    if (picked != null) _applyAssetFromItem(picked);
  }
}

/* ------------------------------ DUMMY CONFIG (for initial text only) ------------------------------ */

// class WorkOrderConfig {
//   final String operatorName;
//   final String operatorMobileNumber;
//   final String operatorInfo;
//   final String typeText;
//   final String descriptionText;

//   const WorkOrderConfig({
//     required this.operatorName,
//     required this.operatorMobileNumber,
//     required this.operatorInfo,
//     required this.typeText,
//     required this.descriptionText,
//   });

//   static const demo = WorkOrderConfig(
//     operatorName: 'Ajay Kumar (MP18292)',
//     operatorMobileNumber: '9876543211',
//     operatorInfo: 'Assets Shop | 12:20 | 03 Sept | A',
//     typeText: '—',
//     descriptionText: '—',
//   );
//}
