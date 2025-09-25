// lib/.../work_order_info/controller/workorder_info_controller.dart
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/login/store/assets_data_store.dart';
import 'package:easy_ops/features/login/store/drop_down_store.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/drop_down_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkorderInfoController extends GetxController {
  // Config (only used for initial UI text defaults; binding comes from store)
  final WorkOrderConfig cfg = WorkOrderConfig.demo;

  // Operator footer (editable)
  late final RxString operatorName;
  late final RxString operatorMobileNumber;
  late final RxString operatorInfo;

  // Media (local only; saved to bag when navigating)
  final photos = <String>[].obs;
  final voiceNotePath = ''.obs;
  final isRecording = false.obs;

  // Inputs
  final assetsCtrl = TextEditingController();
  final problemCtrl = TextEditingController();

  // Derived from selected asset (BOUND to store data)
  late final RxString typeText; // ← asset.criticality
  late final RxString descriptionText; // ← asset.description

  // Store-backed options
  final RxList<DropDownValues> issueTypeOptions = <DropDownValues>[].obs;
  final RxList<DropDownValues> impactOptions = <DropDownValues>[].obs;

  // Selected (IDs)
  final RxString selectedIssueTypeId = ''.obs;
  final RxString selectedImpactId = ''.obs;

  // Legacy labels (kept for compatibility with existing bag keys)
  final issueType = ''.obs;
  final impact = ''.obs;

  late final VoidCallback _assetListener;
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  // ── Fast lookup by serialNumber (uppercase key) built from AssetDataStore
  final Map<String, AssetItem> _assetBySerial = {};

  // Convenience to get current assets list from store
  List<AssetItem> get _storeAssets =>
      Get.find<AssetDataStore>().data.value?.content ?? const <AssetItem>[];

  @override
  void onInit() {
    super.onInit();

    // Load dropdown options from global store and prepend placeholders
    final dd = Get.find<DropDownStore>();
    final it = dd.ofType(LookupType.issuetype);
    final im = dd.ofType(LookupType.impact);

    issueTypeOptions.assignAll([
      DropDownValues(
        id: '',
        code: '',
        displayName: 'Select Issue Type',
        description: '',
        lookupType: LookupType.issuetype,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      ),
      ...it,
    ]);

    impactOptions.assignAll([
      DropDownValues(
        id: '',
        code: '',
        displayName: 'Select Impact Type',
        description: '',
        lookupType: LookupType.impact,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      ),
      ...im,
    ]);

    // Keep selected IDs empty initially so placeholder shows
    selectedIssueTypeId.value = '';
    selectedImpactId.value = '';

    // Reactive fields defaults (will be overridden by store binding when chosen)
    operatorName = cfg.operatorName.obs;
    operatorMobileNumber = cfg.operatorMobileNumber.obs;
    operatorInfo = cfg.operatorInfo.obs;

    typeText = cfg.typeText.obs;
    descriptionText = cfg.descriptionText.obs;

    // Build index from store assets (serialNumber -> AssetItem)
    _rebuildAssetSerialIndex();

    // Hydrate from bag (may overwrite defaults)
    _hydrateFromBag();

    // Keep derived fields in sync while typing: try exact serial match
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
  // Build fast index from store assets
  // ─────────────────────────────────────────────────────────────────────────
  void _rebuildAssetSerialIndex() {
    _assetBySerial.clear();
    for (final it in _storeAssets) {
      final key = (it.serialNumber ?? '').trim().toUpperCase();
      if (key.isNotEmpty) _assetBySerial[key] = it;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hydrate from bag (prefers IDs, falls back to labels)
  // ─────────────────────────────────────────────────────────────────────────
  void _hydrateFromBag() {
    // Prefer IDs if present
    final bagIssueTypeId = _bag.get<String>('issueTypeId', '');
    final bagImpactId = _bag.get<String>('impactId', '');

    if (bagIssueTypeId.isNotEmpty) selectedIssueTypeId.value = bagIssueTypeId;
    if (bagImpactId.isNotEmpty) selectedImpactId.value = bagImpactId;

    // Legacy labels
    final issueTypeLabel = _bag.get<String>('issueType', issueType.value);
    final impactLabel = _bag.get<String>('impact', impact.value);

    // If ID not found, try to map label -> ID
    if (selectedIssueTypeId.value.isEmpty && issueTypeLabel.isNotEmpty) {
      final itHit = _firstWhereOrNull<DropDownValues>(
        issueTypeOptions,
        (e) =>
            e.displayName.trim().toLowerCase() ==
            issueTypeLabel.trim().toLowerCase(),
      );
      if (itHit != null) selectedIssueTypeId.value = itHit.id;
    }

    if (selectedImpactId.value.isEmpty && impactLabel.isNotEmpty) {
      final imHit = _firstWhereOrNull<DropDownValues>(
        impactOptions,
        (e) =>
            e.displayName.trim().toLowerCase() ==
            impactLabel.trim().toLowerCase(),
      );
      if (imHit != null) selectedImpactId.value = imHit.id;
    }

    // Keep legacy labels too
    issueType.value = issueTypeLabel;
    impact.value = impactLabel;

    // Other fields
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

    // If an asset serial is already in the bag, try to bind meta from store now
    _applyMetaIfSerialMatch(assetsCtrl.text);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Save ONLY when moving screens/tabs
  // ─────────────────────────────────────────────────────────────────────────
  void saveToBag() {
    final it = _firstWhereOrNull<DropDownValues>(
      issueTypeOptions,
      (e) => e.id == selectedIssueTypeId.value,
    );
    final im = _firstWhereOrNull<DropDownValues>(
      impactOptions,
      (e) => e.id == selectedImpactId.value,
    );

    _bag.merge({
      // New IDs (authoritative)
      'issueTypeId': selectedIssueTypeId.value,
      'impactId': selectedImpactId.value,

      // Legacy labels (store displayName for readability)
      'issueType': it?.displayName ?? issueType.value,
      'impact': im?.displayName ?? impact.value,

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
  // Local mutations
  // ─────────────────────────────────────────────────────────────────────────
  void updateOperatorFooter({String? name, String? mobile, String? info}) {
    if (name != null) operatorName.value = name;
    if (mobile != null) operatorMobileNumber.value = mobile;
    if (info != null) operatorInfo.value = info;
  }

  // Bind UI with these two values
  void setAssetMeta({required String type, required String description}) {
    typeText.value = type;
    descriptionText.value = description;
  }

  // When user types in the serial number field
  void _applyMetaIfSerialMatch(String input) {
    final key = input.trim().toUpperCase();
    final item = _assetBySerial[key];
    if (item != null) {
      _applyAssetFromItem(item);
    }
  }

  // Centralized mapping when an asset is chosen
  void _applyAssetFromItem(AssetItem item) {
    // Ensure the input shows the authoritative serialNumber
    final sn = (item.serialNumber ?? '').trim();
    if (sn.isNotEmpty && assetsCtrl.text.trim() != sn) {
      assetsCtrl.text = sn;
    }
    // Bind from store data
    setAssetMeta(
      type: item.criticality,
      description: item.description ?? '',
    );
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

  // ───────── Validation (ALL required, including media)
  List<String> _validate() {
    final missing = <String>[];

    if (selectedIssueTypeId.value.isEmpty) missing.add('Issue Type');
    if (selectedImpactId.value.isEmpty) missing.add('Impact');

    if (assetsCtrl.text.trim().isEmpty) missing.add('Assets Number');
    if (problemCtrl.text.trim().isEmpty) missing.add('Problem Description');

    // Require at least 1 photo
    if (photos.isEmpty) missing.add('At least one Photo');

    // Require a voice note
    if (voiceNotePath.value.isEmpty) missing.add('Voice Note');

    return missing;
  }

  // ───────── Validate & Navigate
  void goToWorkOrderDetailScreen() {
    final missing = _validate();
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

  // ───────── Asset picker using STORE (search by serial no.)
  Future<void> openAssetPickerFromStore(BuildContext context) async {
    _rebuildAssetSerialIndex(); // refresh index in case store changed

    final picked = await showModalBottomSheet<AssetItem>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AssetSerialSearchSheet(items: _storeAssets),
    );

    if (picked != null) {
      _applyAssetFromItem(picked);
    }
  }

  // helper (local)
  T? _firstWhereOrNull<T>(Iterable<T> it, bool Function(T) test) {
    for (final e in it) {
      if (test(e)) return e;
    }
    return null;
  }
}

/* -------------------------- ASSET PICKER UI -------------------------- */

class _AssetSerialSearchSheet extends StatefulWidget {
  const _AssetSerialSearchSheet({required this.items});
  final List<AssetItem> items;

  @override
  State<_AssetSerialSearchSheet> createState() =>
      _AssetSerialSearchSheetState();
}

class _AssetSerialSearchSheetState extends State<_AssetSerialSearchSheet> {
  final _searchCtrl = TextEditingController();
  late List<AssetItem> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _sorted(widget.items);
    _searchCtrl.addListener(_onQuery);
  }

  @override
  void dispose() {
    _searchCtrl
      ..removeListener(_onQuery)
      ..dispose();
    super.dispose();
  }

  void _onQuery() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _sorted(widget.items);
      } else {
        _filtered = _sorted(
          widget.items.where((e) {
            final sn = (e.serialNumber ?? '').toLowerCase();
            final nm = e.name.toLowerCase();
            return sn.contains(q) || nm.contains(q);
          }).toList(),
        );
      }
    });
  }

  List<AssetItem> _sorted(List<AssetItem> list) {
    final copy = List<AssetItem>.from(list);
    copy.sort((a, b) {
      final asn = (a.serialNumber ?? '').toLowerCase();
      final bsn = (b.serialNumber ?? '').toLowerCase();
      final by = asn.compareTo(bsn);
      return by != 0
          ? by
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + viewInsets),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const Text('Select Asset by Serial No.',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Search by serial no. or name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: _filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No matching assets'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final it = _filtered[i];
                        final sn = it.serialNumber ?? '-';
                        return ListTile(
                          title: Text(sn,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(it.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => Navigator.of(context).pop(it),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ------------------------------ DUMMY CONFIG (for initial text only) ------------------------------ */

class WorkOrderConfig {
  final String operatorName;
  final String operatorMobileNumber;
  final String operatorInfo;
  final String typeText;
  final String descriptionText;

  const WorkOrderConfig({
    required this.operatorName,
    required this.operatorMobileNumber,
    required this.operatorInfo,
    required this.typeText,
    required this.descriptionText,
  });

  static const demo = WorkOrderConfig(
    operatorName: 'Ajay Kumar (MP18292)',
    operatorMobileNumber: '9876543211',
    operatorInfo: 'Assets Shop | 12:20 | 03 Sept | A',
    typeText: '—', // replaced when asset selected
    descriptionText: '—', // replaced when asset selected
  );
}
