import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/database/db_repository/shift_repositoty.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoController extends GetxController {
  // ─────────────────────────────────────────────────────────────────────────
  // Config & DI
  // ─────────────────────────────────────────────────────────────────────────
  final LookupRepository lookupRepository = Get.find<LookupRepository>();
  final ShiftRepository shiftRepository = Get.find<ShiftRepository>();
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  // ─────────────────────────────────────────────────────────────────────────
  // Text fields
  // ─────────────────────────────────────────────────────────────────────────
  final TextEditingController operatorCtrl = TextEditingController();
  final TextEditingController reporterCtrl = TextEditingController();

  // ─────────────────────────────────────────────────────────────────────────
  // Reactive scalar fields (names)
  // ─────────────────────────────────────────────────────────────────────────
  final sameAsOperator = false.obs;
  RxString employeeId = '-'.obs;
  RxString phoneNumber = '-'.obs;

  // Display names currently selected in UI
  RxString plant = '-'.obs; // PLANT name
  RxString location = '-'.obs; // DEPARTMENT name
  RxString shift = '-'.obs; // SHIFT name

  final reportedTime = Rxn<TimeOfDay>();
  final reportedDate = Rxn<DateTime>();

  // ─────────────────────────────────────────────────────────────────────────
  // Selected IDs (backend identifiers)
  // ─────────────────────────────────────────────────────────────────────────
  final RxString plantId = ''.obs;
  final RxString locationId = ''.obs; // department id
  final RxString shiftId = ''.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdown data sources (typed) + names
  // ─────────────────────────────────────────────────────────────────────────
  final RxList<LookupValues> locationTypeOptions = <LookupValues>[].obs;
  final RxList<LookupValues> plantTypeOptions = <LookupValues>[].obs;

  final RxList<String> locationOptions = <String>[].obs; // DEPARTMENT names
  final RxList<String> plantOptions = <String>[].obs; // PLANT names
  final RxList<String> shiftOptions = <String>[].obs; // SHIFT names

  // Shorthand getters for UI
  List<String> get locations => locationOptions;
  List<String> get plantsOpt => plantOptions;
  List<String> get shiftsOpt => shiftOptions;

  // Filtered (exclude placeholder)
  List<String> get locationsForPicker =>
      locationOptions.where((e) => e != _placeholder).toList();
  List<String> get plantsForPicker =>
      plantOptions.where((e) => e != _placeholder).toList();
  List<String> get shiftsForPicker =>
      shiftOptions.where((e) => e != _placeholder).toList();

  // ─────────────────────────────────────────────────────────────────────────
  // Name → ID maps for quick lookup
  // ─────────────────────────────────────────────────────────────────────────
  final Map<String, String> _plantNameToId = {};
  final Map<String, String> _deptNameToId = {};
  final Map<String, String> _shiftNameToId = {};

  // ─────────────────────────────────────────────────────────────────────────
  // Placeholder helpers
  // ─────────────────────────────────────────────────────────────────────────
  static const String _placeholder = 'Select';
  bool _isPlaceholder(String v) => v.trim().isEmpty || v.trim() == _placeholder;
  String _valueOf(String v) => _isPlaceholder(v) ? '' : v;

  // ─────────────────────────────────────────────────────────────────────────
  // UI helpers
  // ─────────────────────────────────────────────────────────────────────────
  String get timeText {
    final t = reportedTime.value;
    if (t == null) return 'hh:mm';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get dateText {
    final d = reportedDate.value;
    if (d == null) return 'dd/mm/yyyy';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    // Initial text (example defaults)
    operatorCtrl.text = 'Ajay Kumar (MP18292)';
    reporterCtrl.text = 'Ajay Kumar (MP18292)';

    // Scalars
    employeeId.value = 'MP18292';
    phoneNumber.value = '8860700947';
    sameAsOperator.value = true;
    reportedTime.value = _decodeTime('12:20');
    reportedDate.value = _decodeDate('2025-09-23');

    _initAsync();
  }

  @override
  void onClose() {
    operatorCtrl.dispose();
    reporterCtrl.dispose();
    super.onClose();
  }

  Future<void> _initAsync() async {
    // Fetch lists
    final List<Shift> shiftList = await shiftRepository.getAllShift();

    final List<LookupValues> deptList =
        await lookupRepository.getLookupByType(LookupType.department);

    final List<LookupValues> plantsList =
        await lookupRepository.getLookupByType(LookupType.plant);

    // Build typed option lists (with placeholders)
    locationTypeOptions.assignAll([
      LookupValues(
        id: '',
        code: '',
        displayName: 'Select location',
        description: '',
        lookupType: LookupType.department,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      ),
      ...deptList,
    ]);

    plantTypeOptions.assignAll([
      LookupValues(
        id: '',
        code: '',
        displayName: 'Select plant',
        description: '',
        lookupType: LookupType.plant,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      ),
      ...plantsList,
    ]);

    // Names lists for simpler dropdowns
    locationOptions
      ..clear()
      ..addAll([_placeholder, ...deptList.map((e) => e.displayName)]);

    plantOptions
      ..clear()
      ..addAll([_placeholder, ...plantsList.map((e) => e.displayName)]);

    shiftOptions
      ..clear()
      ..addAll([_placeholder, ...shiftList.map((e) => e.name)]);

    // Build name → id maps
    _plantNameToId
      ..clear()
      ..addEntries(plantsList.map((e) => MapEntry(e.displayName, e.id)));

    _deptNameToId
      ..clear()
      ..addEntries(deptList.map((e) => MapEntry(e.displayName, e.id)));

    _shiftNameToId
      ..clear()
      ..addEntries(shiftList.map((s) => MapEntry(s.name, s.id)));

    // Defaults in UI
    location.value = _placeholder;
    plant.value = _placeholder;
    shift.value = _placeholder;

    // Hydrate from bag (sets both names and ids)
    _hydrateFromBag();

    // (Optional) share lists with other tabs
    _bag.merge({
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hydration & Save
  // ─────────────────────────────────────────────────────────────────────────
  void _hydrateFromBag() {
    operatorCtrl.text = _bag.get<String>('operatorName', operatorCtrl.text);
    reporterCtrl.text = _bag.get<String>('reporter', reporterCtrl.text);

    employeeId.value = _bag.get<String>('employeeId', employeeId.value);
    phoneNumber.value = _bag.get<String>('phoneNumber', phoneNumber.value);

    // Prefer IDs from bag; fallback to names
    final bagLocationId = _bag.get<String>('locationId', '');
    final bagPlantId = _bag.get<String>('plantId', '');
    final bagShiftId = _bag.get<String>('shiftId', '');

    final bagLocationName = _bag.get<String>('location', '');
    final bagPlantName = _bag.get<String>('plant', '');
    final bagShiftName = _bag.get<String>('shift', '');

    // LOCATION (Department)
    if (bagLocationId.isNotEmpty) {
      locationId.value = bagLocationId;
      final foundName = _deptNameToId.entries
          .firstWhere((e) => e.value == bagLocationId,
              orElse: () => const MapEntry('', ''))
          .key;
      location.value = locations.contains(foundName) ? foundName : _placeholder;
    } else {
      location.value =
          (bagLocationName.isNotEmpty && locations.contains(bagLocationName))
              ? bagLocationName
              : _placeholder;
      locationId.value = _deptNameToId[location.value] ?? '';
    }

    // PLANT
    if (bagPlantId.isNotEmpty) {
      plantId.value = bagPlantId;
      final foundName = _plantNameToId.entries
          .firstWhere((e) => e.value == bagPlantId,
              orElse: () => const MapEntry('', ''))
          .key;
      plant.value = plantsOpt.contains(foundName) ? foundName : _placeholder;
    } else {
      plant.value =
          (bagPlantName.isNotEmpty && plantsOpt.contains(bagPlantName))
              ? bagPlantName
              : _placeholder;
      plantId.value = _plantNameToId[plant.value] ?? '';
    }

    // SHIFT
    if (bagShiftId.isNotEmpty) {
      shiftId.value = bagShiftId;
      final foundName = _shiftNameToId.entries
          .firstWhere((e) => e.value == bagShiftId,
              orElse: () => const MapEntry('', ''))
          .key;
      shift.value = shiftsOpt.contains(foundName) ? foundName : _placeholder;
    } else {
      shift.value =
          (bagShiftName.isNotEmpty && shiftsOpt.contains(bagShiftName))
              ? bagShiftName
              : _placeholder;
      shiftId.value = _shiftNameToId[shift.value] ?? '';
    }

    sameAsOperator.value =
        _bag.get<bool>('sameAsOperator', sameAsOperator.value);

    reportedTime.value = _decodeTime(
      _bag.get<String?>('reportedTime', _encodeTime(reportedTime.value)),
    );
    reportedDate.value = _decodeDate(
      _bag.get<String?>('reportedDate', _encodeDate(reportedDate.value)),
    );
  }

  void saveToBag() {
    final reporterFinal =
        sameAsOperator.value ? operatorCtrl.text : reporterCtrl.text;

    _bag.merge({
      // IDs for API
      WOKeys.departmentId: locationId.value,
      WOKeys.plantId: plantId.value,
      WOKeys.shiftId: shiftId.value,
      WOKeys.location: location.value,
      WOKeys.plant: plant.value,

      WOKeys.shift: shift.value,
      WOKeys.operatorName: operatorCtrl.text,
      WOKeys.reporter: reporterFinal,
      WOKeys.employeeId: employeeId.value,
      WOKeys.phoneNumber: phoneNumber.value,
      WOKeys.sameAsOperator: sameAsOperator.value,
      WOKeys.reportedTime: _encodeTime(reportedTime.value),
      WOKeys.reportedDate: _encodeDate(reportedDate.value),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdown change handlers (call from UI onChanged)
  // ─────────────────────────────────────────────────────────────────────────
  void onPlantChanged(String name) {
    plant.value = name;
    plantId.value = _plantNameToId[name] ?? '';
  }

  void onLocationChanged(String name) {
    location.value = name;
    locationId.value = _deptNameToId[name] ?? '';
  }

  void onShiftChanged(String name) {
    shift.value = name;
    shiftId.value = _shiftNameToId[name] ?? '';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Validation & Navigation
  // ─────────────────────────────────────────────────────────────────────────
  List<String> validateAll() {
    final errors = <String>[];

    if (reporterCtrl.text.trim().isEmpty) errors.add('Reporter');
    if (!sameAsOperator.value && operatorCtrl.text.trim().isEmpty) {
      errors.add('Operator');
    }

    if (employeeId.value.trim().isEmpty) errors.add('Employee ID');

    final phone = phoneNumber.value.trim();
    final phoneOk = RegExp(r'^\d{10,15}$').hasMatch(phone);
    if (phone.isEmpty || !phoneOk) errors.add('Phone Number (10–15 digits)');

    if (_isPlaceholder(location.value) || locationId.value.isEmpty)
      errors.add('Location');
    if (_isPlaceholder(plant.value) || plantId.value.isEmpty)
      errors.add('Plant');
    if (_isPlaceholder(shift.value) || shiftId.value.isEmpty)
      errors.add('Shift');

    if (reportedTime.value == null) errors.add('Reported At (Time)');
    if (reportedDate.value == null) errors.add('Reported On (Date)');
    return errors;
  }

  void _showValidationErrors(List<String> errors) {
    if (errors.isEmpty) return;
    Get.snackbar(
      'Missing / Invalid',
      'Please fill: ${errors.join(', ')}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
    );
  }

  void saveAndBack() {
    final errors = validateAll();
    if (errors.isNotEmpty) {
      _showValidationErrors(errors);
      return;
    }
    beforeNavigate(() => Get.find<WorkTabsController>().goTo(0));
  }

  void beforeNavigate(VoidCallback go) {
    saveToBag();
    go();
  }

  void discard() {
    operatorCtrl.clear();
    reporterCtrl.clear();
    employeeId.value = '';
    phoneNumber.value = '';
    location.value = _placeholder;
    plant.value = _placeholder;
    shift.value = _placeholder;

    plantId.value = '';
    locationId.value = '';
    shiftId.value = '';

    sameAsOperator.value = false;
    reportedTime.value = null;
    reportedDate.value = null;

    _bag.merge({
      'operatorName': '',
      'reporter': '',
      'employeeId': '',
      'phoneNumber': '',
      'location': '',
      'plant': '',
      'shift': '',
      'locationId': '',
      'plantId': '',
      'shiftId': '',
      'sameAsOperator': false,
      'reportedTime': null,
      'reportedDate': null,
    });
  }

  void onSameAsOperatorChanged(bool v) {
    sameAsOperator.value = v;
    if (v) reporterCtrl.text = operatorCtrl.text;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Encode/Decode
  // ─────────────────────────────────────────────────────────────────────────
  String? _encodeTime(TimeOfDay? t) => t == null
      ? null
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  TimeOfDay? _decodeTime(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]), m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String? _encodeDate(DateTime? d) => d?.toIso8601String();
  DateTime? _decodeDate(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);
}
