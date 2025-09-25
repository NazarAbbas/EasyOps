import 'package:easy_ops/features/login/store/drop_down_store.dart';
import 'package:easy_ops/features/login/store/shift_data_store.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/drop_down_data.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoController extends GetxController {
  // Defaults (scalar only; lists come from stores)
  final OperatorInfoConfig cfg = OperatorInfoConfig.demo;

  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  // Text fields
  late final TextEditingController operatorCtrl;
  late final TextEditingController reporterCtrl;

  // Reactive fields
  final sameAsOperator = false.obs;
  late final RxString employeeId, phoneNumber, location, plant, shift;
  final reportedTime = Rxn<TimeOfDay>();
  final reportedDate = Rxn<DateTime>();

  // Options from stores (reactive)
  final RxList<String> locationOptions = <String>[].obs; // DEPARTMENT names
  final RxList<String> plantOptions = <String>[].obs; // PLANT names
  final RxList<String> shiftOptions = <String>[].obs; // Shift names

  // Shorthand getters used by UI fields
  List<String> get locations => locationOptions;
  List<String> get plantsOpt => plantOptions;
  List<String> get shiftsOpt => shiftOptions;

  // Filtered lists for pickers (exclude placeholder)
  List<String> get locationsForPicker =>
      locationOptions.where((e) => e != _placeholder).toList();
  List<String> get plantsForPicker =>
      plantOptions.where((e) => e != _placeholder).toList();
  List<String> get shiftsForPicker =>
      shiftOptions.where((e) => e != _placeholder).toList();

  // Placeholder helpers
  static const String _placeholder = 'Select';
  bool _isPlaceholder(String v) => v.trim().isEmpty || v.trim() == _placeholder;
  String _valueOf(String v) =>
      _isPlaceholder(v) ? '' : v; // what we save to bag

  // UI helpers
  String get timeText {
    final t = reportedTime.value;
    if (t == null) return 'hh:mm';
    final h = t.hourOfPeriod.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  String get dateText {
    final d = reportedDate.value;
    if (d == null) return 'dd/mm/yyyy';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  void onInit() {
    super.onInit();

    // Stores
    final dropDownStore = Get.find<DropDownStore>();
    final shiftStore = Get.find<ShiftDataStore>();

    // ---------- Build option lists from stores (NO hardcode) ----------
    locationOptions.assignAll(
      dropDownStore.ofType(LookupType.department).map((e) => e.displayName),
    );
    plantOptions.assignAll(
      dropDownStore.ofType(LookupType.plant).map((e) => e.displayName),
    );
    shiftOptions.assignAll(
      shiftStore.sorted().map((s) => s.name),
    );

    // Prepend "Select" for field placeholders
    locationOptions.insert(0, _placeholder);
    plantOptions.insert(0, _placeholder);
    shiftOptions.insert(0, _placeholder);

    // ---------- init from cfg ----------
    operatorCtrl = TextEditingController(text: cfg.operatorName);
    reporterCtrl = TextEditingController(text: cfg.reporter);
    employeeId = cfg.employeeId.obs;
    phoneNumber = cfg.phoneNumber.obs;

    location =
        (locations.contains(cfg.location) && !_isPlaceholder(cfg.location))
            ? cfg.location.obs
            : _placeholder.obs;
    plant = (plantsOpt.contains(cfg.plant) && !_isPlaceholder(cfg.plant))
        ? cfg.plant.obs
        : _placeholder.obs;
    shift = (shiftsOpt.contains(cfg.shift) && !_isPlaceholder(cfg.shift))
        ? cfg.shift.obs
        : _placeholder.obs;

    sameAsOperator.value = cfg.sameAsOperator;
    reportedTime.value = _decodeTime(cfg.reportedTime);
    reportedDate.value = _decodeDate(cfg.reportedDate);

    // Hydrate from bag (may override cfg)
    _hydrateFromBag();

    // Persist current options to bag (optional; for other tabs)
    _bag.merge({
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
  }

  @override
  void onClose() {
    operatorCtrl.dispose();
    reporterCtrl.dispose();
    super.onClose();
  }

  /* ───────────────────────── Hydration & Save ───────────────────────── */

  void _hydrateFromBag() {
    operatorCtrl.text = _bag.get<String>('operatorName', operatorCtrl.text);
    reporterCtrl.text = _bag.get<String>('reporter', reporterCtrl.text);

    employeeId.value = _bag.get<String>('employeeId', employeeId.value);
    phoneNumber.value = _bag.get<String>('phoneNumber', phoneNumber.value);

    final bagLocation = _bag.get<String>('location', _valueOf(location.value));
    final bagPlant = _bag.get<String>('plant', _valueOf(plant.value));
    final bagShift = _bag.get<String>('shift', _valueOf(shift.value));

    location.value = (bagLocation.isNotEmpty && locations.contains(bagLocation))
        ? bagLocation
        : _placeholder;
    plant.value = (bagPlant.isNotEmpty && plantsOpt.contains(bagPlant))
        ? bagPlant
        : _placeholder;
    shift.value = (bagShift.isNotEmpty && shiftsOpt.contains(bagShift))
        ? bagShift
        : _placeholder;

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
      'operatorName': operatorCtrl.text,
      'reporter': reporterFinal,
      'employeeId': employeeId.value,
      'phoneNumber': phoneNumber.value,
      'location': _valueOf(location.value), // '' if placeholder
      'plant': _valueOf(plant.value), // '' if placeholder
      'shift': _valueOf(shift.value), // '' if placeholder
      'sameAsOperator': sameAsOperator.value,
      'reportedTime': _encodeTime(reportedTime.value),
      'reportedDate': _encodeDate(reportedDate.value),

      // Option lists exposed for other readers (optional)
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
  }

  /* ───────────────────────── Validation ───────────────────────── */

  /// Returns a list of human-readable error messages (empty = valid).
  List<String> validateAll() {
    final errors = <String>[];

    // Reporter required
    if (reporterCtrl.text.trim().isEmpty) {
      errors.add('Reporter');
    }

    // Operator required only when not sameAsOperator
    if (!sameAsOperator.value && operatorCtrl.text.trim().isEmpty) {
      errors.add('Operator');
    }

    // Employee ID required
    if (employeeId.value.trim().isEmpty) {
      errors.add('Employee ID');
    }

    // Phone number: required & digits 10–15 (tweak as needed)
    final phone = phoneNumber.value.trim();
    final phoneOk = RegExp(r'^\d{10,15}$').hasMatch(phone);
    if (phone.isEmpty || !phoneOk) {
      errors.add('Phone Number (10–15 digits)');
    }

    // Dropdowns cannot be placeholder
    if (_isPlaceholder(location.value)) errors.add('Location');
    if (_isPlaceholder(plant.value)) errors.add('Plant');
    if (_isPlaceholder(shift.value)) errors.add('Shift');

    // Reported time/date required
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

  /// Validate, save, and navigate back to tab 0 if valid.
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

  /* ───────────────────────── Actions ───────────────────────── */

  void discard() {
    operatorCtrl.clear();
    reporterCtrl.clear();
    employeeId.value = '';
    phoneNumber.value = '';
    location.value = _placeholder;
    plant.value = _placeholder;
    shift.value = _placeholder;
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
      'sameAsOperator': false,
      'reportedTime': null,
      'reportedDate': null,
    });
  }

  void onSameAsOperatorChanged(bool v) {
    sameAsOperator.value = v;
    if (v) reporterCtrl.text = operatorCtrl.text;
  }

  /* ───────────────────────── Encode/Decode ───────────────────────── */

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

/// Scalar defaults only (no hardcoded option lists)
class OperatorInfoConfig {
  final String operatorName;
  final String reporter;
  final String employeeId;
  final String phoneNumber;
  final String location; // initial selection name
  final String plant; // initial selection name
  final String shift; // initial selection name
  final bool sameAsOperator;
  final String? reportedTime; // "HH:mm"
  final String? reportedDate; // ISO-8601

  const OperatorInfoConfig({
    required this.operatorName,
    required this.reporter,
    required this.employeeId,
    required this.phoneNumber,
    required this.location,
    required this.plant,
    required this.shift,
    required this.sameAsOperator,
    required this.reportedTime,
    required this.reportedDate,
  });

  static const demo = OperatorInfoConfig(
    operatorName: 'Ajay Kumar (MP18292)',
    reporter: 'Ajay Kumar (MP18292)',
    employeeId: 'MP18292',
    phoneNumber: '9876543211',
    location: '', // validated against store; shows "Select" if not found
    plant: '',
    shift: '',
    sameAsOperator: true,
    reportedTime: '12:20',
    reportedDate: '2025-09-23',
  );
}
