import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/get_plants_org.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/organization_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OperatorInfoController extends GetxController {
  // ─────────────────────────────────────────────────────────────────────────
  // DI
  // ─────────────────────────────────────────────────────────────────────────
  final DBRepository repository = Get.find<DBRepository>();

  WorkOrderBag get _bag => Get.find<WorkOrderBag>();

  // ─────────────────────────────────────────────────────────────────────────
  // Text fields
  // ─────────────────────────────────────────────────────────────────────────
  final TextEditingController operatorCtrl = TextEditingController();
  final TextEditingController reporterCtrl = TextEditingController();

  // ─────────────────────────────────────────────────────────────────────────
  // Reactive scalar fields
  // ─────────────────────────────────────────────────────────────────────────
  final sameAsOperator = false.obs;

  final RxString reporterId = ''.obs;
  final RxString employeeCode = ''.obs;
  final RxString reporterPhoneNumber = ''.obs;

  final RxString operatorId = ''.obs;
  final RxString operatorPhoneNumber = ''.obs;

  // Display names currently selected in UI
  final RxString plant = 'Select'.obs; // PLANT name
  final RxString location = 'Select'.obs; // DEPARTMENT name
  final RxString shift = 'Select'.obs; // SHIFT name

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
  final RxList<PlantsOrgItem> locationTypeOptions = <PlantsOrgItem>[].obs;
  final RxList<PlantsOrgItem> plantTypeOptions = <PlantsOrgItem>[].obs;

  final RxList<String> locationOptions = <String>[].obs;
  final RxList<String> plantOptions = <String>[].obs;
  final RxList<String> shiftOptions = <String>[].obs;

  // Shifts cache to evaluate reported time
  final RxList<Shift> _shifts = <Shift>[].obs;
  final RxList<PlantsOrgItem> _locations = <PlantsOrgItem>[].obs;

  // Convenience getters
  List<String> get locations => locationOptions;

  List<String> get plantsOpt => plantOptions;

  List<String> get shiftsOpt => shiftOptions;

  // Filtered (exclude placeholder)
  static const String _placeholder = 'Select';

  bool _isPlaceholder(String v) => v.trim().isEmpty || v.trim() == _placeholder;

  List<String> get locationsForPicker =>
      locationOptions.where((e) => e != _placeholder).toList();

  List<String> get plantsForPicker =>
      plantOptions.where((e) => e != _placeholder).toList();

  List<String> get shiftsForPicker =>
      shiftOptions.where((e) => e != _placeholder).toList();

  final selectedLocationType = ''.obs;
  final selectedImpactId = ''.obs;
  final assetsId = ''.obs;

  // legacy labels (kept for compatibility with existing bag keys & UI mirrors)
  final locationype = ''.obs;
  final impact = ''.obs;

  // ─────────────────────────────────────────────────────────────────────────
  // Name → ID maps
  // ─────────────────────────────────────────────────────────────────────────
  final Map<String, String> _plantNameToId = {};
  final Map<String, String> _locationNameToId = {};
  final Map<String, String> _shiftNameToId = {};

  // ─────────────────────────────────────────────────────────────────────────
  // Operators list + selection
  // ─────────────────────────────────────────────────────────────────────────
  final RxList<OperatosDetails> _operators = <OperatosDetails>[].obs;
  final RxList<OperatosDetails> _filteredOperators = <OperatosDetails>[].obs;

  OperatosDetails? _selectedOperator; // for operatorCtrl
  OperatosDetails? _selectedReporter; // for reporterCtrl

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
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() async {
    super.onInit();
    _initAsync();

    reportedTime.value = TimeOfDay.now();
    reportedDate.value = DateTime.now();
    await _setLoggedInPersonAsReporter();

    final prefs = await SharedPreferences.getInstance();
    final loginPersonId = prefs.getString(Constant.loginPersonId);
    final details = await repository.getPersonById(loginPersonId!);
    if (details != null) {
      employeeCode.value = details.code;
    }
  }

  @override
  void onClose() {
    operatorCtrl.dispose();
    reporterCtrl.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────
  String _s(String? v) => v?.trim() ?? '';

  String _fullName(String? first, String? last) =>
      [_s(first), _s(last)].where((e) => e.isNotEmpty).join(' ');

  Organization _placeholderOrg(String label) => Organization(
        id: '',
        displayName: label,
        recordStatus: 1,
        tenantId: '',
        clientId: '',
      );

  PlantsOrgItem _placeholderPlants(String label) => PlantsOrgItem(
    id: 'PLANT_PLACEHOLDER',
    displayName: 'Select Plant',
    orgTypeId: '',
    orgTypeName: '',
    addressLine1: '',
    addressLine2: '',
    zip: '',
    recordStatus: 1, // or 0, depending on your convention
    tenantId: '',
    tenantName: '',
    clientId: '',
    clientName: '',
    parentOrgId: null,
    parentOrgName: null,
    countryId: '',
    countryName: '',
    stateId: '',
    stateName: '',
    districtId: '',
    districtName: '',
    timezoneId: '',
    timezoneName: '',
    dateFormatId: '',
    languageId: '',
    languageName: '',
    currencyId: '',
    currencyName: '',
    taxProfileId: null,
  );

  DateTime? _parseIso(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);

  String? _encodeTime(TimeOfDay? t) => t == null
      ? null
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String? _encodeDate(DateTime? d) => d?.toIso8601String();

  TimeOfDay? _decodeTime(String? s) {
    if (s == null || s.isEmpty) return null;
    if (s.contains('T') || s.contains('-')) {
      final dt = DateTime.tryParse(s);
      if (dt == null) return null;
      final local = dt.toLocal();
      return TimeOfDay(hour: local.hour, minute: local.minute);
    }
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]), m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  DateTime? _decodeDate(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);

  // ─────────────────────────────────────────────────────────────────────────
  // Shift evaluation based on a local *time-only* anchor
  // ─────────────────────────────────────────────────────────────────────────
  int _toSecHms(String hms) {
    final p = hms.split(':');
    final h = int.parse(p[0]);
    final m = int.parse(p[1]);
    final s = (p.length > 2) ? int.parse(p[2]) : 0;
    return h * 3600 + m * 60 + s;
  }

  bool _shiftCrossesMidnight(Shift s) {
    final st = _toSecHms(s.startTime);
    final en = _toSecHms(s.endTime);
    return en <= st; // e.g. 22:00 → 06:00
  }

  bool _shiftContains(Shift s, int tSec) {
    final st = _toSecHms(s.startTime);
    final en = _toSecHms(s.endTime);
    if (!_shiftCrossesMidnight(s)) {
      return tSec >= st && tSec < en; // [st, en)
    } else {
      return tSec >= st || tSec < en; // overnight
    }
  }

  int _lengthSec(Shift s) {
    final st = _toSecHms(s.startTime);
    final en = _toSecHms(s.endTime);
    return _shiftCrossesMidnight(s) ? (86400 - st + en) : (en - st);
  }

  /// Build an anchor DateTime using only the reported time.
  /// If the user hasn't chosen a date, we use *today* — but date has no effect on shift logic.
  DateTime? _combineReportedLocalTimeOnly() {
    final t = reportedTime.value;
    if (t == null) return null;
    final now = DateTime.now();
    final d = reportedDate.value ?? now; // date ignored for logic; time matters
    return DateTime(d.year, d.month, d.day, t.hour, t.minute, 0);
  }

  /// Returns the shift covering [whenLocal]; if multiple match, picks the shortest window.
  Shift? _selectShiftFor(DateTime whenLocal) {
    if (_shifts.isEmpty) return null;
    final tSec =
        whenLocal.hour * 3600 + whenLocal.minute * 60 + whenLocal.second;
    final matches = _shifts.where((s) => _shiftContains(s, tSec)).toList();
    if (matches.isEmpty) return null;
    matches.sort((a, b) => _lengthSec(a).compareTo(_lengthSec(b)));
    return matches.first;
  }

  /// If no current shift covers the time, pick the next starting shift after [whenLocal].
  Shift? _nextShiftAfter(DateTime whenLocal) {
    if (_shifts.isEmpty) return null;
    final tSec =
        whenLocal.hour * 3600 + whenLocal.minute * 60 + whenLocal.second;
    Shift? best;
    int bestDelta = 1 << 30;
    for (final s in _shifts) {
      final st = _toSecHms(s.startTime);
      final delta = (st - tSec + 86400) % 86400;
      if (delta > 0 && delta < bestDelta) {
        bestDelta = delta;
        best = s;
      }
    }
    return best;
  }

  /// Recompute shift using *only* the reported clock time.
  /// If time isn't set yet, do a one-time best guess with now().
  void _recomputeShiftFromReported({bool persist = true}) {
    final anchor = _combineReportedLocalTimeOnly() ?? DateTime.now();
    final chosen = _selectShiftFor(anchor) ?? _nextShiftAfter(anchor);
    if (chosen != null) {
      shift.value = chosen.name;
      shiftId.value = chosen.id;
    } else {
      shift.value = _placeholder;
      shiftId.value = '';
    }
    if (persist) saveToBag();
  }

  /// Returns (time, date) and sets observables (+ optional persist) — also recomputes shift.
  (TimeOfDay, DateTime)? setReportedFromIso(String? iso,
      {bool persistToBag = true}) {
    final dt = _parseIso(iso);
    if (dt == null) return null;

    final local = dt.toLocal();
    final time = TimeOfDay(hour: local.hour, minute: local.minute);
    final date = DateTime(local.year, local.month, local.day);

    reportedTime.value = time;
    reportedDate.value = date;

    if (persistToBag) {
      _bag.merge({
        WOKeys.reportedTime: _encodeTime(time),
        WOKeys.reportedDate: _encodeDate(date),
      });
    }

    _recomputeShiftFromReported(persist: persistToBag);
    return (time, date);
  }

  /// Call these from UI pickers to keep shift in sync.
  void setReportedTime(TimeOfDay t, {bool persistToBag = true}) {
    reportedTime.value = t;
    if (persistToBag) {
      _bag.merge({WOKeys.reportedTime: _encodeTime(t)});
    }
    _recomputeShiftFromReported(persist: persistToBag);
  }

  void setReportedDate(DateTime d, {bool persistToBag = true}) {
    // Keep storing date for backend, but shift logic ignores it
    final dateOnly = DateTime(d.year, d.month, d.day);
    reportedDate.value = dateOnly;
    if (persistToBag) {
      _bag.merge({WOKeys.reportedDate: _encodeDate(dateOnly)});
    }
    _recomputeShiftFromReported(persist: persistToBag);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build bag from an existing WorkOrder
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _putWorkOrderIntoBag(WorkOrders wo) async {
    // Split ISO reportedTime -> (TimeOfDay, DateTime) and recompute shift afterwards
    TimeOfDay? reportedAt;
    DateTime? reportedOn;
    final res = setReportedFromIso(wo.reportedTime, persistToBag: false);
    if (res != null) {
      (reportedAt, reportedOn) = res;
    }

    _bag.merge({
      WOKeys.reporterName:
          _fullName(wo.reportedBy?.firstName, wo.reportedBy?.lastName),
      WOKeys.reporterId: _s(wo.reportedBy?.id),
      WOKeys.reporterPhoneNumber: _s(wo.reportedBy?.phone),

      WOKeys.locationId: _s(wo.locationId),
      WOKeys.location: _s(wo.locationName),

      WOKeys.plantId: _s(wo.plantId),
      WOKeys.plant: _s(wo.plantName ?? plant.value),

      WOKeys.shiftId: _s(wo.shiftId),
      WOKeys.shift: _s(wo.shiftName),

      // people
      WOKeys.operatorName:
          _fullName(wo.operator?.firstName, wo.operator?.lastName),
      WOKeys.operatorId: _s(wo.operator?.id),
      WOKeys.operatorPhoneNumber: _s(wo.operator?.phone),

      // boolean
      WOKeys.sameAsOperator:
          (wo.reportedBy?.id != null && wo.reportedBy?.id == wo.operator?.id),

      // time/date — encode (prefer parsed; else current observables)
      WOKeys.reportedTime: _encodeTime(reportedAt ?? reportedTime.value),
      WOKeys.reportedDate: _encodeDate(reportedOn ?? reportedDate.value),
    });

    _recomputeShiftFromReported(persist: false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Init async: load lookups/operators/shifts; hydrate from bag
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _initAsync() async {
    // If a work order was stored, put it into the bag first (may set reported time/date)
    final workOrderInfo = await SharePreferences.getObject(
      Constant.workOrder,
      WorkOrders.fromJson,
    );
    if (workOrderInfo != null) {
      await _putWorkOrderIntoBag(workOrderInfo);
    }

    // Fetch lists
    final operatorsList = await repository.getAllOperator();
    final shiftList = await repository.getAllShift(); // List<Shift>
   /* final deptList =
        await repository.getPlantsByParentOrgID();*/ // List<Organization>
    final plantsList =
        await repository.getActivePlants(); // List<Organization>

    _shifts.assignAll(shiftList);

    // Keep operators for picker
    _operators.assignAll(operatorsList);
    _filteredOperators.assignAll(operatorsList);

    // Typed option lists (with placeholder rows)
    locationTypeOptions
        .assignAll([_placeholderPlants('Select location'), ...locationTypeOptions]);
    plantTypeOptions
        .assignAll([_placeholderPlants('Select plant'), ...plantsList]);

    // Names lists for simpler dropdowns
    locationOptions
      ..clear()
      ..addAll([_placeholder, ...locationTypeOptions.map((e) => e.displayName)]);
    plantOptions
      ..clear()
      ..addAll([_placeholder, ...plantsList.map((e) => e.displayName)]);
    shiftOptions
      ..clear()
      ..addAll([_placeholder, ...shiftList.map((e) => e.name)]);

    // name → id maps
    _plantNameToId
      ..clear()
      ..addEntries(plantsList.map((e) => MapEntry(e.displayName, e.id)));
    _locationNameToId
      ..clear()
      ..addEntries(locationTypeOptions.map((e) => MapEntry(e.displayName, e.id)));
    _shiftNameToId
      ..clear()
      ..addEntries(shiftList.map((s) => MapEntry(s.name, s.id)));

    // Defaults in UI
    location.value = _placeholder;
    plant.value = _placeholder;
    shift.value = _placeholder;

    // Hydrate from bag (also restores operator/reporter text and any saved ids)
    _hydrateFromBag();

    // If reported time is present after hydration, recompute shift from it (date ignored).
    final hasReported = reportedTime.value != null;
    _recomputeShiftFromReported(persist: !hasReported);

    // Share lists with other tabs
    _bag.merge({
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // People binding & picker
  // ─────────────────────────────────────────────────────────────────────────
  String _displayFor(OperatosDetails p) => p.name;

  void _applySelectedPerson({
    required OperatosDetails person,
    required bool setAsOperator,
  }) {
    if (setAsOperator) {
      _selectedOperator = person;
      operatorCtrl.text = _displayFor(person);
      operatorId.value = person.id;
      employeeCode.value = person.code ?? '';
      operatorPhoneNumber.value = person.userPhone;


      if (sameAsOperator.value) {
        _selectedReporter = person;
        reporterCtrl.text = _displayFor(person);
        reporterId.value = person.id;
        employeeCode.value = person.code ?? '';
        reporterPhoneNumber.value = person.userPhone;
      }
    } else {
      _selectedReporter = person;
      reporterCtrl.text = _displayFor(person);
      reporterId.value = person.id;
      employeeCode.value = person.code ??'';
      reporterPhoneNumber.value = person.userPhone;
    }

    saveToBag();
  }

  Future<void> openPeoplePicker({required bool setOperatorField}) async {
    _filteredOperators.assignAll(_operators);
    final searchCtrl = TextEditingController();

    final ctx = Get.context ?? Get.overlayContext;
    if (ctx == null) return;

    await Get.bottomSheet<void>(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 12,
          ),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  setOperatorField ? 'Choose Operator' : 'Choose Reporter',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by name or ID...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (q) {
                    final qq = q.trim().toLowerCase();
                    if (qq.isEmpty) {
                      _filteredOperators.assignAll(_operators);
                    } else {
                      _filteredOperators.assignAll(
                        _operators.where((p) {
                          final name = (p.name).toLowerCase();
                          final id = (p.id).toLowerCase();
                          return name.contains(qq) || id.contains(qq);
                        }),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    if (_filteredOperators.isEmpty) {
                      return const Center(child: Text('No matches found'));
                    }
                    return ListView.separated(
                      itemCount: _filteredOperators.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final person = _filteredOperators[i];
                        final email = person.userEmail ?? '';
                        return ListTile(
                          title: Text(_displayFor(person)),
                          subtitle: email.isNotEmpty ? Text(email) : null,
                          onTap: () {
                            _applySelectedPerson(
                              person: person,
                              setAsOperator: setOperatorField,
                            );
                            Get.back();
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  // Public methods for UI bindings
  void onTapChooseOperator() => openPeoplePicker(setOperatorField: true);

  void onTapChooseReporter() => openPeoplePicker(setOperatorField: false);

  void onSameAsOperatorChanged(bool v) {
    sameAsOperator.value = v;
    if (v) {
      if (_selectedOperator != null) {
        _selectedReporter = _selectedOperator;
        reporterCtrl.text = _displayFor(_selectedOperator!);
        reporterId.value = _selectedOperator!.id;
        employeeCode.value = _selectedOperator!.code ?? '';
        reporterPhoneNumber.value = _selectedOperator!.userPhone;
      } else {
        reporterCtrl.text = operatorCtrl.text;
      }
    }
    saveToBag();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hydration & Save
  // ─────────────────────────────────────────────────────────────────────────
  void _hydrateFromBag() {
    operatorCtrl.text =
        _bag.get<String>(WOKeys.operatorName, operatorCtrl.text);
    operatorId.value = _bag.get<String>(WOKeys.operatorId, operatorId.value);
    operatorPhoneNumber.value =
        _bag.get<String>(WOKeys.operatorPhoneNumber, operatorPhoneNumber.value);

    reporterCtrl.text =
        _bag.get<String>(WOKeys.reporterName, reporterCtrl.text);
    reporterId.value = _bag.get<String>(WOKeys.reporterId, reporterId.value);
    reporterPhoneNumber.value =
        _bag.get<String>(WOKeys.reporterPhoneNumber, reporterPhoneNumber.value);

    // Prefer IDs from bag; fallback to names
    final bagLocationId = _bag.get<String>(WOKeys.locationId, '');
    final bagPlantId = _bag.get<String>(WOKeys.plantId, '');
    final bagShiftId = _bag.get<String>(WOKeys.shiftId, '');

    final bagLocationName = _bag.get<String>(WOKeys.location, '');
    final bagPlantName = _bag.get<String>(WOKeys.plant, '');
    final bagShiftName = _bag.get<String>(WOKeys.shift, '');

    // LOCATION
    if (bagLocationId.isNotEmpty) {
      locationId.value = bagLocationId;
      final foundName = _locationNameToId.entries
          .firstWhere(
            (e) => e.value == bagLocationId,
            orElse: () => const MapEntry<String, String>('', ''),
          )
          .key;
      location.value = locations.contains(foundName) ? foundName : _placeholder;
    } else {
      location.value =
          (bagLocationName.isNotEmpty && locations.contains(bagLocationName))
              ? bagLocationName
              : _placeholder;
      locationId.value = _locationNameToId[location.value] ?? '';
    }

    // PLANT
    if (bagPlantId.isNotEmpty) {
      plantId.value = bagPlantId;
      final foundName = _plantNameToId.entries
          .firstWhere(
            (e) => e.value == bagPlantId,
            orElse: () => const MapEntry<String, String>('', ''),
          )
          .key;
      plant.value = plantsOpt.contains(foundName) ? foundName : _placeholder;
    } else {
      plant.value =
          (bagPlantName.isNotEmpty && plantsOpt.contains(bagPlantName))
              ? bagPlantName
              : _placeholder;
      plantId.value = _plantNameToId[plant.value] ?? '';
    }

    // SHIFT (just restore names/ids; actual correctness will be recomputed from reported time)
    if (bagShiftId.isNotEmpty) {
      shiftId.value = bagShiftId;
      final foundName = _shiftNameToId.entries
          .firstWhere(
            (e) => e.value == bagShiftId,
            orElse: () => const MapEntry<String, String>('', ''),
          )
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
        _bag.get<bool>(WOKeys.sameAsOperator, sameAsOperator.value);

    reportedTime.value = _decodeTime(
      _bag.get<String?>(WOKeys.reportedTime, _encodeTime(reportedTime.value)),
    );
    reportedDate.value = _decodeDate(
      _bag.get<String?>(WOKeys.reportedDate, _encodeDate(reportedDate.value)),
    );
  }

  void saveToBag() {
    _bag.merge({
      // IDs for API
      WOKeys.locationId: locationId.value,
      WOKeys.plantId: plantId.value,
      WOKeys.shiftId: shiftId.value,

      // Names
      WOKeys.location: location.value,
      WOKeys.plant: plant.value,
      WOKeys.shift: shift.value,

      // People (strings)
      WOKeys.operatorName: operatorCtrl.text,
      WOKeys.operatorId: operatorId.value,
      WOKeys.operatorPhoneNumber: operatorPhoneNumber.value,

      WOKeys.reporterName: reporterCtrl.text,
      WOKeys.reporterPhoneNumber: reporterPhoneNumber.value,
      WOKeys.reporterId: reporterId.value,

      // Others
      WOKeys.sameAsOperator: sameAsOperator.value,
      WOKeys.reportedTime: _encodeTime(reportedTime.value),
      WOKeys.reportedDate: _encodeDate(reportedDate.value),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdown change handlers
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> onPlantChanged(String name) async {
    plant.value = name;
    plantId.value = _plantNameToId[name] ?? '';
    locationTypeOptions.value = await repository.getPlantsByParentOrgID(plantId.value);
    locationOptions
      ..clear()
      ..addAll([_placeholder, ...locationTypeOptions.map((e) => e.displayName)]);
    _locationNameToId
      ..clear()
      ..addEntries(locationTypeOptions.map((e) => MapEntry(e.displayName, e.id)));
    saveToBag();
  }

  void onLocationChanged(String name) {
    location.value = name;
    locationId.value = _locationNameToId[name] ?? '';
    saveToBag();
  }

  void onShiftChanged(String name) {
    shift.value = name;
    shiftId.value = _shiftNameToId[name] ?? '';
    saveToBag();
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

    if (reporterId.value.trim().isEmpty) errors.add('Employee ID');

    final phone = reporterPhoneNumber.value.trim();
    final phoneOk = RegExp(r'^\d{10,15}$').hasMatch(phone);
    if (phone.isEmpty || !phoneOk) errors.add('Phone Number (10–15 digits)');

    if (_isPlaceholder(location.value) || locationId.value.isEmpty) {
      errors.add('Location');
    }
    if (_isPlaceholder(plant.value) || plantId.value.isEmpty) {
      errors.add('Plant');
    }
    if (_isPlaceholder(shift.value) || shiftId.value.isEmpty) {
      errors.add('Shift');
    }

    if (reportedTime.value == null) errors.add('Reported At (Time)');
    // If backend doesn't require date, you can comment the next line:
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
    reporterId.value = '';
    reporterPhoneNumber.value = '';
    location.value = _placeholder;
    plant.value = _placeholder;
    shift.value = _placeholder;

    plantId.value = '';
    locationId.value = '';
    shiftId.value = '';

    sameAsOperator.value = false;
    reportedTime.value = null;
    reportedDate.value = null;

    _selectedOperator = null;
    _selectedReporter = null;

    _bag.merge({
      WOKeys.operatorName: '',
      WOKeys.reporterName: '',
      WOKeys.operatorId: '',
      WOKeys.reporterId: '',
      'employeeId': '',
      'phoneNumber': '',
      WOKeys.location: '',
      WOKeys.plant: '',
      WOKeys.shift: '',
      WOKeys.locationId: '',
      WOKeys.plantId: '',
      WOKeys.shiftId: '',
      WOKeys.sameAsOperator: false,
      WOKeys.reportedTime: null,
      WOKeys.reportedDate: null,
    });
  }

  Future<void> _setLoggedInPersonAsReporter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginPersonId = prefs.getString(Constant.loginPersonId);

      if (loginPersonId != null && loginPersonId.isNotEmpty) {
        final details = await repository.getPersonById(loginPersonId);

        if (details != null) {
          // Set the user's actual name
          reporterCtrl.text = details.name ?? "Current User";
          reporterId.value = loginPersonId;
          reporterPhoneNumber.value = details.userPhone ?? "";

          // Also set as operator
          sameAsOperator.value = true;
          operatorCtrl.text = details.name ?? "Current User";
          operatorId.value = loginPersonId;
          operatorPhoneNumber.value = details.userPhone ?? "";

          saveToBag();
        }
      }
    } catch (e) {
      print('Error setting default reporter: $e');
    }
  }
}
