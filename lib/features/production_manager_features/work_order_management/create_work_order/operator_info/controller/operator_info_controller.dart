// lib/features/work_order_management/create_work_order/operator_info/controller/operator_info_controller.dart
// Full controller: binds operatorCtrl / reporterCtrl to operators list
// with a searchable Get.bottomSheet picker and WorkOrderBag sync.

import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/database/db_repository/operators_details_repository.dart';
import 'package:easy_ops/database/db_repository/shift_repositoty.dart';
import 'package:easy_ops/features/common_features/login/models/operators_details.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoController extends GetxController {
  // ─────────────────────────────────────────────────────────────────────────
  // DI
  // ─────────────────────────────────────────────────────────────────────────
  final OperatorDetailsRepository operatorDetailsRepository =
      Get.find<OperatorDetailsRepository>();
  final LookupRepository lookupRepository = Get.find<LookupRepository>();
  final ShiftRepository shiftRepository = Get.find<ShiftRepository>();
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

  final RxString reporterId = '-'.obs;
  final RxString reporterPhoneNumber = '-'.obs;

  final RxString operatorId = '-'.obs;
  final RxString operatorPhoneNumber = '-'.obs;

  // Display names currently selected in UI
  final RxString plant = '-'.obs; // PLANT name
  final RxString location = '-'.obs; // DEPARTMENT name
  final RxString shift = '-'.obs; // SHIFT name

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

  final RxList<String> locationOptions = <String>[].obs;
  final RxList<String> plantOptions = <String>[].obs;
  final RxList<String> shiftOptions = <String>[].obs;

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
  // Name → ID maps
  // ─────────────────────────────────────────────────────────────────────────
  final Map<String, String> _plantNameToId = {};
  final Map<String, String> _deptNameToId = {};
  final Map<String, String> _shiftNameToId = {};

  // ─────────────────────────────────────────────────────────────────────────
  // Operators list + selection
  // ─────────────────────────────────────────────────────────────────────────
  final RxList<OperatosDetails> _operators = <OperatosDetails>[].obs;
  final RxList<OperatosDetails> _filteredOperators = <OperatosDetails>[].obs;

  OperatosDetails? _selectedOperator; // for operatorCtrl
  OperatosDetails? _selectedReporter; // for reporterCtrl

  // ─────────────────────────────────────────────────────────────────────────
  // Placeholder helpers
  // ─────────────────────────────────────────────────────────────────────────
  static const String _placeholder = 'Select';
  bool _isPlaceholder(String v) => v.trim().isEmpty || v.trim() == _placeholder;

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

    // sensible defaults
    sameAsOperator.value = true;
    reportedTime.value = _decodeTime('12:20');
    reportedDate.value = _decodeDate('2025-09-23');

    // Warm the bag with present (possibly empty) values
    final workTabsController = Get.find<WorkTabsController>();
    final workOrderInfo = workTabsController.workOrder;
    final workOrderStatus = workTabsController.workOrderStatus;
    if (workOrderInfo != null && workOrderStatus != null) {
      _bag.merge({
        WOKeys.departmentId: locationId.value,
        WOKeys.plantId: plantId.value,
        WOKeys.shiftId: shiftId.value,
        WOKeys.location: location.value,
        WOKeys.plant: plant.value,
        WOKeys.shift: shift.value,

        WOKeys.operatorName: operatorCtrl.text,
        WOKeys.operatorId: operatorId,
        WOKeys.operatorPhoneNumber: operatorPhoneNumber,

        WOKeys.reporterName: reporterCtrl.text,
        WOKeys.reporterId: reporterId,
        WOKeys.reporterPhoneNumber: reporterPhoneNumber,

        // WOKeys.employeeId: reporterId.value,
        //WOKeys.phoneNumber: reporterPhoneNumber.value,
        WOKeys.sameAsOperator: sameAsOperator.value,
        WOKeys.reportedTime: _encodeTime(reportedTime.value),
        WOKeys.reportedDate: _encodeDate(reportedDate.value),
      });
    }

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
    final List<OperatosDetails> operatorsList =
        await operatorDetailsRepository.getAllOperator();
    final List<Shift> shiftList = await shiftRepository.getAllShift();
    final List<LookupValues> deptList =
        await lookupRepository.getLookupByType(LookupType.department);
    final List<LookupValues> plantsList =
        await lookupRepository.getLookupByType(LookupType.plant);

    // Keep operators for picker
    _operators.assignAll(operatorsList);
    _filteredOperators.assignAll(operatorsList);

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

    // Hydrate from bag (also restores operator/reporter text)
    _hydrateFromBag();

    // Share lists with other tabs
    _bag.merge({
      'locations': locations,
      'plantsOpt': plantsOpt,
      'shiftsOpt': shiftsOpt,
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // People binding & picker (Get.bottomSheet)
  // ─────────────────────────────────────────────────────────────────────────
  // Only name in UI
  String _displayFor(OperatosDetails p) => p.name;

  void _applySelectedPerson({
    required OperatosDetails person,
    required bool setAsOperator,
  }) {
    if (setAsOperator) {
      _selectedOperator = person;
      operatorCtrl.text = _displayFor(person);
      operatorId.value = person.id;
      operatorPhoneNumber.value = person.userPhone;

      if (sameAsOperator.value) {
        _selectedReporter = person;
        reporterCtrl.text = _displayFor(person);
        reporterId.value = person.id;
        reporterPhoneNumber.value = person.userPhone;
      }
    } else {
      _selectedReporter = person;
      reporterCtrl.text = _displayFor(person);
      reporterId.value = person.id;
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
                        return ListTile(
                          title: Text(_displayFor(person)),
                          subtitle: (person.userEmail ?? '').isNotEmpty
                              ? Text(person.userEmail!)
                              : null,
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
    operatorId.value = _bag.get<String>(WOKeys.operatorId, reporterId.value);
    operatorPhoneNumber.value =
        _bag.get<String>(WOKeys.operatorPhoneNumber, reporterPhoneNumber.value);

    reporterCtrl.text =
        _bag.get<String>(WOKeys.reporterName, reporterCtrl.text);
    reporterId.value = _bag.get<String>(WOKeys.reporterId, reporterId.value);
    reporterPhoneNumber.value =
        _bag.get<String>(WOKeys.reporterPhoneNumber, reporterPhoneNumber.value);

    // reporterId.value = _bag.get<String>('reporterId', reporterId.value);
    // reporterPhoneNumber.value =
    //     _bag.get<String>('phoneNumber', reporterPhoneNumber.value);

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
          .firstWhere(
            (e) => e.value == bagLocationId,
            orElse: () => const MapEntry('', ''),
          )
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
          .firstWhere(
            (e) => e.value == bagPlantId,
            orElse: () => const MapEntry('', ''),
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

    // SHIFT
    if (bagShiftId.isNotEmpty) {
      shiftId.value = bagShiftId;
      final foundName = _shiftNameToId.entries
          .firstWhere(
            (e) => e.value == bagShiftId,
            orElse: () => const MapEntry('', ''),
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
        _bag.get<bool>('sameAsOperator', sameAsOperator.value);

    reportedTime.value = _decodeTime(
      _bag.get<String?>('reportedTime', _encodeTime(reportedTime.value)),
    );
    reportedDate.value = _decodeDate(
      _bag.get<String?>('reportedDate', _encodeDate(reportedDate.value)),
    );
  }

  void saveToBag() {
    // final reporterFinal =
    //   sameAsOperator.value ? operatorCtrl.text : reporterCtrl.text;

    _bag.merge({
      // IDs for API
      WOKeys.departmentId: locationId.value,
      WOKeys.plantId: plantId.value,
      WOKeys.shiftId: shiftId.value,
      // Names
      WOKeys.location: location.value,
      WOKeys.plant: plant.value,
      WOKeys.shift: shift.value,
      // People (strings)
      WOKeys.operatorName: operatorCtrl.text,
      WOKeys.operatorId: operatorId,
      WOKeys.operatorPhoneNumber: operatorPhoneNumber,

      WOKeys.reporterName: reporterCtrl.text,
      WOKeys.reporterPhoneNumber: reporterPhoneNumber,
      WOKeys.reporterId: reporterId,
      // Optional: persist IDs if your API needs them
      // 'operatorId': _selectedOperator?.id,
      //'reporterId': _selectedReporter?.id,
      // Other scalars
      //WOKeys.employeeId: reporterId.value,
      //WOKeys.phoneNumber: reporterPhoneNumber.value,
      WOKeys.sameAsOperator: sameAsOperator.value,
      WOKeys.reportedTime: _encodeTime(reportedTime.value),
      WOKeys.reportedDate: _encodeDate(reportedDate.value),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dropdown change handlers
  // ─────────────────────────────────────────────────────────────────────────
  void onPlantChanged(String name) {
    plant.value = name;
    plantId.value = _plantNameToId[name] ?? '';
    saveToBag();
  }

  void onLocationChanged(String name) {
    location.value = name;
    locationId.value = _deptNameToId[name] ?? '';
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
      'operatorName': '',
      'reporter': '',
      'operatorId': null,
      'reporterId': null,
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
