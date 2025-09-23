import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoController extends GetxController {
  // Defaults (can be replaced later with server JSON)
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

  // Lookups (bag override, else cfg)
  List<String> get locations =>
      _bag.get<List<String>>('locations', cfg.locations);
  List<String> get plantsOpt =>
      _bag.get<List<String>>('plantsOpt', cfg.plantsOpt);
  List<String> get shiftsOpt =>
      _bag.get<List<String>>('shiftsOpt', cfg.shiftsOpt);

  // UI helpers
  String get timeText {
    final t = reportedTime.value;
    if (t == null) return 'hh:mm';
    final h = (t.hourOfPeriod).toString().padLeft(2, '0');
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

    // init from cfg
    operatorCtrl = TextEditingController(text: cfg.operatorName);
    reporterCtrl = TextEditingController(text: cfg.reporter);
    employeeId = cfg.employeeId.obs;
    phoneNumber = cfg.phoneNumber.obs;
    location = cfg.location.obs;
    plant = cfg.plant.obs;
    shift = cfg.shift.obs;
    sameAsOperator.value = cfg.sameAsOperator;
    reportedTime.value = _decodeTime(cfg.reportedTime);
    reportedDate.value = _decodeDate(cfg.reportedDate);

    // hydrate from bag (overwrites cfg values when present)
    _hydrateFromBag();

    // ensure lookups exist in bag for other tabs
    _bag.merge({
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt
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
    location.value = _bag.get<String>('location', location.value);
    plant.value = _bag.get<String>('plant', plant.value);
    shift.value = _bag.get<String>('shift', shift.value);
    sameAsOperator.value =
        _bag.get<bool>('sameAsOperator', sameAsOperator.value);

    reportedTime.value = _decodeTime(
        _bag.get<String?>('reportedTime', _encodeTime(reportedTime.value)));
    reportedDate.value = _decodeDate(
        _bag.get<String?>('reportedDate', _encodeDate(reportedDate.value)));
  }

  void saveToBag() {
    final reporterFinal =
        sameAsOperator.value ? operatorCtrl.text : reporterCtrl.text;

    _bag.merge({
      'operatorName': operatorCtrl.text,
      'reporter': reporterFinal,
      'employeeId': employeeId.value,
      'phoneNumber': phoneNumber.value,
      'location': location.value,
      'plant': plant.value,
      'shift': shift.value,
      'sameAsOperator': sameAsOperator.value,
      'reportedTime': _encodeTime(reportedTime.value),
      'reportedDate': _encodeDate(reportedDate.value),
      // keep lookups in bag for any other readers
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
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
    location.value = '';
    plant.value = '';
    shift.value = '';
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

  void saveAndBack() =>
      beforeNavigate(() => Get.find<WorkTabsController>().goTo(0));

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

// lib/features/work_order_management/create_work_order/models/operator_info_config.dart
class OperatorInfoConfig {
  // Lookups
  final List<String> locations;
  final List<String> plantsOpt;
  final List<String> shiftsOpt;

  // Defaults
  final String operatorName;
  final String reporter;
  final String employeeId;
  final String phoneNumber;
  final String location;
  final String plant;
  final String shift;
  final bool sameAsOperator;
  final String? reportedTime; // "HH:mm"
  final String? reportedDate; // ISO-8601

  const OperatorInfoConfig({
    required this.locations,
    required this.plantsOpt,
    required this.shiftsOpt,
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

  /// Single hard-coded model; replace with parsed JSON later.
  static const demo = OperatorInfoConfig(
    locations: ['Assets Shop', 'Assembly', 'Bay 1', 'Bay 3'],
    plantsOpt: ['Plant A', 'Plant B', 'Plant C'],
    shiftsOpt: ['A', 'B', 'C'],
    operatorName: 'Ajay Kumar (MP18292)',
    reporter: 'Ajay Kumar (MP18292)',
    employeeId: 'MP18292',
    phoneNumber: '9876543211',
    location: 'Assets Shop',
    plant: 'Plant A',
    shift: 'A',
    sameAsOperator: true,
    reportedTime: '12:20',
    reportedDate: '2025-09-23',
  );
}
