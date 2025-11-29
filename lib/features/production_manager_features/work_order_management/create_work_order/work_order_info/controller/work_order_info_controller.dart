// lib/.../work_order_info/controller/work_order_info_controller.dart
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/work_order_info/ui/work_order_info_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkorderInfoController extends GetxController {
  // Optional "Reason" selector (unused here, kept for compatibility)
  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select Reason'.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // Dependencies & config
  // ─────────────────────────────────────────────────────────────────────────
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();
  final repository = Get.find<DBRepository>();

  // ─────────────────────────────────────────────────────────────────────────
  // UI state: operator footer (editable)
  // ─────────────────────────────────────────────────────────────────────────
  final operatorName = ''.obs;
  final operatorMobileNumber = ''.obs;
  final operatorInfo = ''.obs;

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
  final titleCtrl = TextEditingController();

  // Derived from selected asset
  final typeText = '—'.obs; // e.g., asset.criticality
  final descriptionText = '—'.obs; // e.g., asset.description

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdowns: options + selected
  // ─────────────────────────────────────────────────────────────────────────
  final issueTypeOptions = <LookupValues>[].obs;
  final impactOptions = <LookupValues>[].obs;

  final selectedIssueTypeId = ''.obs;
  final selectedImpactId = ''.obs;
  final selectedAssetsId = ''.obs;

  // legacy mirrors (for existing UI/bag compatibility)
  final selectedIssueType = ''.obs;
  final selectedImpact = ''.obs;

  // assets cache + serial index
  final List<AssetItem> _storeAssets = <AssetItem>[];
  final Map<String, AssetItem> _assetId = <String, AssetItem>{};

  late final VoidCallback _assetListener;

  //WorkOrders? workOrderInfo;
  WorkOrderStatus? workOrderStatus;

  final workTypeOptions = <LookupValues>[].obs;
  final selectedWorkTypeId = ''.obs;
  final selectedWorkType = ''.obs;
  final selectedWorkTypeDisplay = 'Select Work Type'.obs;

  final workTypeLookup = LookupValues(
          id: '',
          code: '',
          displayName: '',
          lookupType: '',
          sortOrder: 0,
          recordStatus: 0)
      .obs;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  final Rxn<WorkOrders> workOrderInfo = Rxn<WorkOrders>();

  @override
  void onReady() async {
    super.onReady();
    workOrderInfo.value = await SharePreferences.getObject(
      Constant.workOrder,
      WorkOrders.fromJson,
    );
  }

  @override
  void onInit() async {
    super.onInit();
    await _loadLookups();
    await _loadAssets();
    await _loadWorkType();
    if (workOrderInfo.value != null) {
      await _putWorkOrderIntoBag(workOrderInfo.value!);
      _loadFromBag();
    } else {
      await _initOperatorInfo();
    }
    // await _initOperatorInfo();
    // await _initAsync(); // ensure lookups/assets available before reactions
    // _setupReactions(); // set up reactive label syncing

    _assetListener = () => _applyMetaIfSerialMatch(assetsCtrl.text);
    assetsCtrl.addListener(_assetListener);
  }

  @override
  void onClose() {
    // assetsCtrl
    //   ..removeListener(_assetListener)
    //   ..dispose();
    // problemCtrl.dispose();
    // titleCtrl.dispose();
    super.onClose();
  }

  Future<void> _initOperatorInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final loginPerson = prefs.getString(Constant.loginPersonId);

    if (loginPerson != null) {
      final details = await repository.getPersonById(loginPerson);
      if (details != null) {
        operatorName.value = '${details.name}(${details.code})';
        if (details.userPhone != null) {
          operatorMobileNumber.value = details.userPhone!;
        }

        final dt = (details.updatedAt ?? DateTime.now()).toUtc();
        final s = formatTimeDateLocal(dt);

        if (details.assets.isNotEmpty) {
          operatorInfo.value =
              '${details.assets.first.assetName} | $s | ${details.assets.first.assetSerialNumber}';
        }
      }
    }
  }

  String formatTimeDateLocal(DateTime dt) {
    final d = dt.isUtc ? dt.toLocal() : dt;
    final time = DateFormat('HH:mm').format(d);
    final day = DateFormat('dd').format(d);
    final mon = DateFormat('MMM').format(d).toLowerCase();
    return '$time | $day $mon';
  }

  Future<void> _loadWorkType() async {
    var workType = await repository.getActiveByCode("BREAKDOWN");

    if (workType.isEmpty) {
      final workOrderCategories =
          await repository.getLookupByCode("BREAKDOWN");
      workType = workOrderCategories
          .where((l) => l.code.toUpperCase() == 'BREAKDOWN')
          .toList();
    }

    if (workType.isNotEmpty) {
      workTypeLookup.value = workType.first;
    }

    debugPrint('Work type loaded: ${workTypeLookup.value.displayName}');
  }

  Future<void> _loadLookups() async {
    final impact = await repository.getLookupByType(LookupType.impact);

    impactOptions.assignAll([
      _placeholderOption('Select Impact Type', LookupType.impact),
      ...impact,
    ]);

    final issue =
        await repository.getLookupByType(LookupType.workorderissuetype);

    issueTypeOptions.assignAll([
      _placeholderOption('Select Issue Type', LookupType.workorderissuetype),
      ...issue,
    ]);
  }

  Future<void> _loadAssets() async {
    final list = await repository.getAllAssets();
    _storeAssets
      ..clear()
      ..addAll(list);
  }

  LookupValues _placeholderOption(String label, LookupType t) {
    return LookupValues(
      id: '',
      code: '',
      displayName: label,
      /* description: '',*/
      lookupType: t.name,
      sortOrder: -1,
      recordStatus: 1,
      /*updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      clientId: '',*/
    );
  }

  String _absoluteUrl(String? raw) {
    final p = (raw ?? '').trim();
    if (p.isEmpty) return '';
    final lower = p.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) return p;

    final base = Constant.BASE_URL.endsWith('/')
        ? Constant.BASE_URL.substring(0, Constant.BASE_URL.length - 1)
        : Constant.BASE_URL;
    final path = p.startsWith('/') ? p.substring(1) : p;
    return '$base/$path';
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
      selectedAssetsId.value = id;
    }
    _setAssetMeta(type: item.criticality, description: item.description ?? '');
  }

  void _setAssetMeta({required String type, required String description}) {
    typeText.value = type.isNotEmpty ? type : '—';
    descriptionText.value = description.isNotEmpty ? description : '—';
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
    if (titleCtrl.text.trim().isEmpty) missing.add('Title');

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

  // ── Core: write WO → bag, then read bag → UI ────────────────────────────
  Future<void> _putWorkOrderIntoBag(WorkOrders wo) async {

    //Category
    final workTypeId  =  workTypeLookup.value.id ?? '';
    debugPrint('Work type id from WO: $workTypeId');
    final workTypeName = workTypeLookup.value.code ?? '';
    debugPrint('Work type name from WO: $workTypeName');

    // IDs
    final issueId = (wo.issueTypeId ?? '').trim();
    final impactId = (wo.impactId ?? '').trim();

    // // Asset basics
    final assetIdV = (wo.asset.id ?? '').trim();
    final assetSerial = (wo.asset.serialNumber ?? '').trim();
    final asset = await repository.getAsset(assetSerial);

    // // Title / Description
    final title = (wo.title ?? '').trim();
    final remark = (wo.remark ?? '').trim();

    // // Operator
    final first = (wo.operator?.firstName ?? '').trim();
    final last = (wo.operator?.lastName ?? '').trim();
    final opName = ('$first $last').trim();
    final opPhone = (wo.operator?.phone ?? '').trim();

    // // Media (convert relative paths to absolute URLs when needed)
    final files = wo.mediaFiles;
    final imgs = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('image/'))
        .map((f) => _absoluteUrl(f.filePath))
        .where((p) => p.isNotEmpty)
        .toList();

    final firstAudio = files
        .where((f) => (f.fileType ?? '').toLowerCase().startsWith('audio/'))
        .map((f) => _absoluteUrl(f.filePath))
        .firstWhere((p) => p.isNotEmpty, orElse: () => '');

    final dt = (wo.updatedAt ?? DateTime.now()).toUtc();
    final s = formatTimeDateLocal(dt);

    if (wo.asset.name.isNotEmpty) {
      operatorInfo.value = '${wo.asset.name} | $s | ${wo.asset.serialNumber}';
    }

    // Store everything in the bag
    _bag.merge({
      // IDs & labels (labels optional; use if you have them on the WO)
      WOKeys.issueTypeId: issueId,
      WOKeys.impactId: impactId,
      WOKeys.issueType: (wo.issueTypeName ?? '').trim(),
      WOKeys.impact: (wo.impactName ?? '').trim(),

      //Category details
      WOKeys.categoryID: workTypeLookup.value.id,
      WOKeys.categoryName: workTypeLookup.value.code,

      // // Asset
      WOKeys.assetsId: assetIdV,
      WOKeys.assetsNumber: assetSerial,

      // // Texts
      WOKeys.title: title,
      WOKeys.problemDescription: remark,
      WOKeys.typeText: asset?.criticality,
      WOKeys.descriptionText: asset?.description,

      // // Media
      WOKeys.photos: imgs,
      WOKeys.voiceNotePath: firstAudio,

      // // Operator
      WOKeys.operatorName: pickOrNA(opName, operatorName.value),
      WOKeys.operatorPhoneNumber: pickOrNA(opPhone, operatorMobileNumber.value),
      WOKeys.operatorInfo: operatorInfo.value,
    });
  }

  String joinNonEmpty(Iterable<Object?> parts, {String sep = ' | '}) => parts
      .map((e) => (e?.toString().trim() ?? ''))
      .where((t) => t.isNotEmpty)
      .join(sep);

  String pickOrNA(String? primary, String? secondary,
      {String na = 'Not available'}) {
    final p = primary?.trim();
    if (p != null && p.isNotEmpty) return p;

    final s = secondary?.trim();
    if (s != null && s.isNotEmpty) return s;

    return na;
  }

  void _loadFromBag() {
    // IDs + labels
    selectedIssueTypeId.value = _bag.get<String>(WOKeys.issueTypeId, '');
    selectedIssueType.value = _bag.get<String>(WOKeys.issueType, '');
//  ───────────────────────────────────────────────
    selectedImpactId.value = _bag.get<String>(WOKeys.impactId, '');
    selectedImpact.value = _bag.get<String>(WOKeys.impact, '');
//  ───────────────────────────────────────────────
    selectedAssetsId.value = _bag.get<String>(WOKeys.assetsId, '');
    assetsCtrl.text = _bag.get<String>(WOKeys.assetsNumber, '');
//  ───────────────────────────────────────────────
    typeText.value = _bag.get<String>(WOKeys.typeText, typeText.value);
    descriptionText.value =
        _bag.get<String>(WOKeys.descriptionText, descriptionText.value);
//  ───────────────────────────────────────────────
    typeText.value = _bag.get<String>(WOKeys.typeText, typeText.value);
    descriptionText.value =
        _bag.get<String>(WOKeys.descriptionText, descriptionText.value);
//  ───────────────────────────────────────────────
    titleCtrl.text = _bag.get<String>(WOKeys.title, '');
    problemCtrl.text = _bag.get<String>(WOKeys.problemDescription, '');
//  ───────────────────────────────────────────────
    // Media
    final ph = _bag.get<List?>(WOKeys.photos, const []) ?? const [];
    photos.assignAll(ph.map((e) => e.toString()));
    voiceNotePath.value = _bag.get<String>(WOKeys.voiceNotePath, '');
//  ───────────────────────────────────────────────
    // Operator
    operatorName.value =
        _bag.get<String>(WOKeys.operatorName, operatorName.value);
    operatorMobileNumber.value = _bag.get<String>(
        WOKeys.operatorPhoneNumber, operatorMobileNumber.value);
    operatorInfo.value ==
        _bag.get<String>(WOKeys.operatorInfo, operatorInfo.value);
  }

  // ── Save current UI → bag ───────────────────────────────────────────────
  void saveToBag() {
    _bag.merge({
      WOKeys.issueTypeId: selectedIssueTypeId.value,
      WOKeys.issueType: selectedIssueType.value,
//  ───────────────────────────────────────────────
      WOKeys.impactId: selectedImpactId.value,
      WOKeys.impact: selectedImpact.value,
      //  ───────────────────────────────────────────────
      WOKeys.assetsId: selectedAssetsId.value,
      WOKeys.typeText: typeText.value,
      WOKeys.descriptionText: descriptionText.value,
      WOKeys.assetsNumber: assetsCtrl.text.trim(),
//  ───────────────────────────────────────────────
      WOKeys.title: titleCtrl.text.trim(),
      WOKeys.problemDescription: problemCtrl.text.trim(),
//  ───────────────────────────────────────────────
      WOKeys.photos: photos.toList(),
      WOKeys.voiceNotePath: voiceNotePath.value,
      //  ───────────────────────────────────────────────
      WOKeys.operatorName: operatorName.value,
      WOKeys.operatorPhoneNumber: operatorMobileNumber.value,
      WOKeys.operatorInfo: operatorInfo,

      WOKeys.categoryID : workTypeLookup.value.id,
      WOKeys.categoryName : workTypeLookup.value.code,
    });
  }
}
