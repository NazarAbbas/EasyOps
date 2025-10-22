// lib/.../work_order_info/controller/workorder_info_controller.dart
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/work_order_info/ui/work_order_info_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WorkorderInfoController extends GetxController {
  // Optional "Reason" selector kept from your snippet (unused here)
  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select Reason'.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // Dependencies & config
  // ─────────────────────────────────────────────────────────────────────────
  // final lookupRepository = Get.find<LookupRepository>();
  // final assetRepository = Get.find<AssetRepository>();
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();
//  final loginPersonDetailsRepository = Get.find<LoginPersonDetailsRepository>();
  final repository = Get.find<DBRepository>();
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

  // legacy labels (kept for compatibility with existing bag keys & UI mirrors)
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

    // load current work order context if present
    final workTabsController = Get.find<WorkTabsController>();
    workOrderInfo = workTabsController.workOrder;
    workOrderStatus = workTabsController.workOrderStatus;

    // Initialize UI state & async data
    _initDefaults();
    await _initAsync(); // ensure lookups/assets are available before reactions

    // Keep label Rx in sync with selected IDs (without blanking)
    _setupReactions();

    // Asset text field listener → auto-apply meta when serial matches
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
  void _setupReactions() {
    ever<String>(selectedIssueTypeId, (id) {
      final next = _labelFor(issueTypeOptions, id);
      if (next.isNotEmpty) issueType.value = next; // don't overwrite with ''
    });
    ever<String>(selectedImpactId, (id) {
      final next = _labelFor(impactOptions, id);
      if (next.isNotEmpty) impact.value = next; // don't overwrite with ''
    });
  }

  void _initDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    final loginPerson = prefs.getString(Constant.loginPersonId);

    if (loginPerson != null) {
      final details = await repository.getPersonById(loginPerson);
      if (details != null) {
        operatorName.value = '${details.name}(${details.id})';
        if (details.contacts.isNotEmpty &&
            details.contacts.first.phone != null) {
          operatorMobileNumber.value = details.contacts.first.phone!;
        }

        final dt = (details.updatedAt ?? DateTime.now()).toUtc();
        final s = formatTimeDateLocal(dt);

        if (details.assets.isNotEmpty) {
          operatorInfo.value =
              '${details.assets.first.assetName} | $s | ${details.assets.first.assetSerialNumber}';
        }
      }
    }

    typeText.value = '—';
    descriptionText.value = '—';

    // selected dropdown defaults -> placeholders (empty id)
    selectedIssueTypeId.value = '';
    selectedImpactId.value = '';
  }

  /// e.g. DateTime(2025,10,13,05,34,36,926,277).toUtc()
  String formatTimeDateLocal(DateTime dt) {
    final d = dt.isUtc ? dt.toLocal() : dt; // convert if it's UTC (ends with Z)
    final time = DateFormat('HH:mm').format(d); // 24h
    final day = DateFormat('dd').format(d);
    final mon = DateFormat('MMM').format(d).toLowerCase();
    return '$time | $day $mon';
  }

  Future<void> _initAsync() async {
    // Load lookups first so label derivation never blanks out
    await _loadLookups();
    await _loadAssets();
    _rebuildAssetSerialIndex();

    // Hydrate from bag (ids first; labels will sync safely)
    _hydrateFromBag();

    // optional: prefill from currently selected work order
    if (workOrderInfo != null) {
      if ((workOrderInfo!.issueTypeId ?? '').isNotEmpty) {
        selectedIssueTypeId.value = workOrderInfo!.issueTypeId!;
      }
      if ((workOrderInfo!.impactId ?? '').isNotEmpty) {
        selectedImpactId.value = workOrderInfo!.impactId!;
      }
      if ((workOrderInfo!.asset.id ?? '').isNotEmpty) {
        assetsId.value = workOrderInfo!.asset.id!;
      }
    }

    _syncLabelsFromSelection(); // ensure labels mirror ids (non-blank)
  }

  Future<void> _loadLookups() async {
    final impact =
        await repository.getLookupByType(LookupType.impact) ?? <LookupValues>[];
    final issue = await repository.getLookupByType(LookupType.issuetype) ??
        <LookupValues>[];

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
    // pulls once; if you want reactive, expose a stream in repository
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
    // preferred ids (MUST use same keys as saveToBag)
    final bagIssueTypeId = _bag.get<String>(WOKeys.issueTypeId, '');
    final bagImpactId = _bag.get<String>(WOKeys.impactId, '');

    if (bagIssueTypeId.isNotEmpty) selectedIssueTypeId.value = bagIssueTypeId;
    if (bagImpactId.isNotEmpty) selectedImpactId.value = bagImpactId;

    // legacy labels
    final issueTypeLabel = _bag.get<String>(WOKeys.issueType, issueType.value);
    final impactLabel = _bag.get<String>(WOKeys.impact, impact.value);

    // try label->id when id missing (for old bag entries)
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

    // keep legacy mirrors (will be refined by _syncLabelsFromSelection later)
    issueType.value = issueTypeLabel;
    impact.value = impactLabel;

    // other fields (use constants)
    assetsCtrl.text = _bag.get<String>(WOKeys.assetsNumber, assetsCtrl.text);
    problemCtrl.text = _bag.get<String>(
      WOKeys.problemDescription,
      problemCtrl.text,
    );

    typeText.value = _bag.get<String>(WOKeys.typeText, typeText.value);
    descriptionText.value = _bag.get<String>(
      WOKeys.descriptionText,
      descriptionText.value,
    );

    final ph = _bag.get<List?>(WOKeys.photos, const []) ?? const [];
    photos.assignAll(ph.map((e) => e.toString()));

    voiceNotePath.value = _bag.get<String>(
      WOKeys.voiceNotePath,
      voiceNotePath.value,
    );

    operatorName.value = _bag.get<String>(
      WOKeys.operatorName,
      operatorName.value,
    );

    // bind asset-derived fields if serial present
    _applyMetaIfSerialMatch(assetsCtrl.text);

    // ensure labels reflect selected IDs *now* (won't blank)
    _syncLabelsFromSelection();
  }

  String _labelFor(List<LookupValues> options, String id) {
    if (id.isEmpty) return '';
    final hit = _firstWhereOrNull<LookupValues>(options, (e) => e.id == id);
    return hit?.displayName ?? '';
  }

  String _labelForSafe({
    required List<LookupValues> options,
    required String id,
    required String current,
  }) {
    final computed = _labelFor(options, id);
    if (computed.isNotEmpty) return computed;
    // if lookups aren't loaded yet or id not found, keep what user sees
    return current;
  }

  void _syncLabelsFromSelection() {
    final it = _labelFor(issueTypeOptions, selectedIssueTypeId.value);
    if (it.isNotEmpty) issueType.value = it;

    final im = _labelFor(impactOptions, selectedImpactId.value);
    if (im.isNotEmpty) impact.value = im;
  }

  void saveToBag() {
    final issueTypeLabel = _labelForSafe(
      options: issueTypeOptions,
      id: selectedIssueTypeId.value,
      current: issueType.value, // keep current if options missing
    );

    final impactLabel = _labelForSafe(
      options: impactOptions,
      id: selectedImpactId.value,
      current: impact.value,
    );

    // keep the reactive mirrors in sync (and never blank them)
    issueType.value = issueTypeLabel;
    impact.value = impactLabel;

    _bag.merge({
      WOKeys.issueTypeId: selectedIssueTypeId.value,
      WOKeys.impactId: selectedImpactId.value,
      WOKeys.assetsId: assetsId.value,
      WOKeys.issueType: issueTypeLabel, // label
      WOKeys.impact: impactLabel, // label
      WOKeys.assetsNumber: assetsCtrl.text.trim(),
      WOKeys.problemDescription: problemCtrl.text.trim(),
      WOKeys.typeText: typeText.value,
      WOKeys.descriptionText: descriptionText.value,
      WOKeys.photos: photos.toList(),
      WOKeys.voiceNotePath: voiceNotePath.value,
      WOKeys.operatorName: operatorName.value,
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
