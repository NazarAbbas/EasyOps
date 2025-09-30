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
  final OperatorInfoConfig cfg = OperatorInfoConfig.demo;
  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  // ─────────────────────────────────────────────────────────────────────────
  // Text fields (init at declaration to avoid LateInitializationError)
  // ─────────────────────────────────────────────────────────────────────────
  final TextEditingController operatorCtrl = TextEditingController();
  final TextEditingController reporterCtrl = TextEditingController();

  // ─────────────────────────────────────────────────────────────────────────
  // Reactive scalar fields
  // ─────────────────────────────────────────────────────────────────────────
  final sameAsOperator = false.obs;
  RxString employeeId = '-'.obs;
  RxString phoneNumber = '-'.obs;
  RxString plant = '-'.obs;
  RxString shift = '-'.obs;
  RxString location = '-'.obs;

  final reportedTime = Rxn<TimeOfDay>();
  final reportedDate = Rxn<DateTime>();

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdown data sources (full objects for typed pickers)
  // ─────────────────────────────────────────────────────────────────────────
  final RxList<LookupValues> locationTypeOptions = <LookupValues>[].obs;
  final RxList<LookupValues> plantTypeOptions = <LookupValues>[].obs;

  // Names-only lists (useful for simple TextFields/Autocomplete)
  final RxList<String> locationOptions = <String>[].obs; // DEPARTMENT names
  final RxList<String> plantOptions = <String>[].obs; // PLANT names
  final RxList<String> shiftOptions = <String>[].obs; // Shift names

  // Shorthand getters for UI
  List<String> get locations => locationOptions;
  List<String> get plantsOpt => plantOptions;
  List<String> get shiftsOpt => shiftOptions;

  // For pickers (exclude placeholder)
  List<String> get locationsForPicker =>
      locationOptions.where((e) => e != _placeholder).toList();
  List<String> get plantsForPicker =>
      plantOptions.where((e) => e != _placeholder).toList();
  List<String> get shiftsForPicker =>
      shiftOptions.where((e) => e != _placeholder).toList();

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
    final h = t.hourOfPeriod.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
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

    // Set text synchronously so widgets reading controllers are safe
    operatorCtrl.text = cfg.operatorName;
    reporterCtrl.text = cfg.reporter;

    // Scalars from cfg
    employeeId = cfg.employeeId.obs;
    phoneNumber = cfg.phoneNumber.obs;
    sameAsOperator.value = cfg.sameAsOperator;
    reportedTime.value = _decodeTime(cfg.reportedTime);
    reportedDate.value = _decodeDate(cfg.reportedDate);

    // Kick off async data fetch (keeps controllers ready)
    _initAsync();
  }

  Future<void> _initAsync() async {
    //final shiftStore = Get.find<ShiftDataStore>();

    List<Shift> shiftList = await shiftRepository.getAllShift();

    // final List<DropDownValues> deptList =
    //     await lookupRepository.getLookupByType(LookupType.department);

    // Fetch lookup values (no variable shadowing)
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

    // Names-only lists for simpler pickers
    locationOptions
      ..clear()
      ..addAll([_placeholder, ...deptList.map((e) => e.displayName)]);

    plantOptions
      ..clear()
      ..addAll([_placeholder, ...plantsList.map((e) => e.displayName)]);

    shiftOptions
      ..clear()
      ..addAll([_placeholder, ...shiftList.map((e) => e.name)]);

    // ..addAll([_placeholder, ...shiftList.map(toElement).sorted().map((s) => s.name)]);

    // Initialize selected values from cfg (validated against options)
    location.value =
        (locations.contains(cfg.location) && !_isPlaceholder(cfg.location))
            ? cfg.location
            : _placeholder;

    plant.value = (plantsOpt.contains(cfg.plant) && !_isPlaceholder(cfg.plant))
        ? cfg.plant
        : _placeholder;

    shift.value = (shiftsOpt.contains(cfg.shift) && !_isPlaceholder(cfg.shift))
        ? cfg.shift
        : _placeholder;

    // Hydrate from bag (may override cfg)
    _hydrateFromBag();

    // Share option lists (optional) with other tabs via bag
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

  // ─────────────────────────────────────────────────────────────────────────
  // Hydration & Save
  // ─────────────────────────────────────────────────────────────────────────
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
      'location': _valueOf(location.value),
      'plant': _valueOf(plant.value),
      'shift': _valueOf(shift.value),
      'sameAsOperator': sameAsOperator.value,
      'reportedTime': _encodeTime(reportedTime.value),
      'reportedDate': _encodeDate(reportedDate.value),

      // Option lists for other readers (optional)
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
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

    if (_isPlaceholder(location.value)) errors.add('Location');
    if (_isPlaceholder(plant.value)) errors.add('Plant');
    if (_isPlaceholder(shift.value)) errors.add('Shift');

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
