import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/common_models/work_draft_model.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef Json = Map<String, dynamic>;

class EditOperatorInfoController extends GetxController {
  final draft = Get.find<WorkOrderDraft>();

  // Debounced autosave trigger (kept tiny)
  final _saveSignal = 0.obs;
  late final Worker _saveWorker;
  late final List<Worker> _workers;

  // Fields
  final sameAsOperator = false.obs;

  final operatorCtrl = TextEditingController();
  final reporterCtrl = TextEditingController();
  final employeeId = '-'.obs;
  final phoneNumber = '-'.obs;

  final location = ''.obs;
  final plant = ''.obs;
  final reportedTime = Rxn<TimeOfDay>();
  final reportedDate = Rxn<DateTime>();
  final shift = ''.obs;

  // Options
  final locations = const ['Assets Shop', 'Assembly', 'Bay 1', 'Bay 3'];
  final plantsOpt = const ['Plant A', 'Plant B', 'Plant C'];
  final shiftsOpt = const ['A', 'B', 'C'];

  String get timeText {
    final t = reportedTime.value;
    if (t == null) return 'hh:mm';
    final h = t.hourOfPeriod.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  String get dateText {
    final d = reportedDate.value;
    if (d == null) return 'dd/mm/yyyy';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  void onInit() {
    super.onInit();
    _hydrateFromDraft();
    _bindAutosave();
  }

  @override
  void onClose() {
    for (final w in _workers) {
      w.dispose();
    }
    _saveWorker.dispose();
    reporterCtrl.dispose();
    operatorCtrl.dispose();
    super.onClose();
  }

  // -------- Draft <-> Rx wiring ----------
  void _hydrateFromDraft() {
    reporterCtrl.text = draft.get<String>(WD.reporter, '');
    operatorCtrl.text = draft.get<String>(
      WD.operatorName,
      '',
    ); // mirrors operator name if you want
    employeeId.value = draft.get<String>(WD.employeeId, '-');
    phoneNumber.value = draft.get<String>(WD.phoneNumber, '-');

    location.value = draft.get<String>(WD.location, '');
    plant.value = draft.get<String>(WD.plant, '');
    shift.value = draft.get<String>(WD.shift, '');
    sameAsOperator.value = draft.get<bool>(WD.sameAsOperator, false);

    final rt = draft.get<String?>(WD.reportedTime, null);
    final rd = draft.get<String?>(WD.reportedDate, null);
    reportedTime.value = _decodeTime(rt);
    reportedDate.value = _decodeDate(rd);
  }

  void _bindAutosave() {
    _saveWorker = debounce<int>(
      _saveSignal,
      (_) => _saveNow(),
      time: const Duration(milliseconds: 250),
    );

    _workers = [
      ever<String>(employeeId, _nudge),
      ever<String>(phoneNumber, _nudge),
      ever<String>(location, _nudge),
      ever<String>(plant, _nudge),
      ever<TimeOfDay?>(reportedTime, _nudge),
      ever<DateTime?>(reportedDate, _nudge),
      ever<String>(shift, _nudge),
      ever<bool>(sameAsOperator, _onSameAsOperatorChanged),
    ];

    reporterCtrl.addListener(_nudge);
    operatorCtrl.addListener(_nudge);
  }

  void _nudge([dynamic _]) => _saveSignal.value++;

  void _saveNow() {
    draft.merge({
      WD.reporter: reporterCtrl.text,

      // Persist operator name here only if you intend this tab to control it:
      // WD.operatorName: operatorCtrl.text,
      WD.employeeId: employeeId.value,
      WD.phoneNumber: phoneNumber.value,

      WD.location: location.value,
      WD.plant: plant.value,
      WD.shift: shift.value,
      WD.sameAsOperator: sameAsOperator.value,

      WD.reportedTime: _encodeTime(reportedTime.value),
      WD.reportedDate: _encodeDate(reportedDate.value),
    });
  }

  // Actions
  void discard() {
    reporterCtrl.clear();
    // operatorCtrl.clear(); // uncomment if this tab owns operator name
    employeeId.value = '-';
    phoneNumber.value = '-';
    location.value = '';
    plant.value = '';
    reportedTime.value = null;
    reportedDate.value = null;
    shift.value = '';
    sameAsOperator.value = false;

    // Clear only this tab’s fields from the map (non-destructive to other tabs)
    draft.merge({
      WD.reporter: '',
      WD.employeeId: '-',
      WD.phoneNumber: '-',
      WD.location: '',
      WD.plant: '',
      WD.reportedTime: null,
      WD.reportedDate: null,
      WD.shift: '',
      WD.sameAsOperator: false,
    });

    Get.snackbar(
      'Discarded',
      'All fields cleared.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryBlue,
      colorText: AppColors.white,
    );
  }

  void saveAndBack() {
    _saveNow();
    Get.snackbar(
      'Saved',
      'Operator info saved.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: AppColors.text,
    );
    Get.find<WorkTabsController>().goTo(0);
  }

  // If toggled, mirror operator name to reporter; untoggle keeps values as-is.
  void _onSameAsOperatorChanged(bool v) {
    if (v) {
      reporterCtrl.text = operatorCtrl.text;
    }
    _nudge();
  }

  // Encode/Decode
  String? _encodeTime(TimeOfDay? t) => t == null
      ? null
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  TimeOfDay? _decodeTime(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String? _encodeDate(DateTime? d) => d?.toIso8601String();
  DateTime? _decodeDate(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);
}
