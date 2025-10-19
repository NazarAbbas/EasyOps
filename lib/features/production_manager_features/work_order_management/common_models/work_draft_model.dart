// lib/services/work_order_draft.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WD {
  // Common keys used by ALL tabs/controllers
  static const operatorName = 'operatorName';
  static const operatorMobileNumber = 'operatorMobileNumber';
  static const operatorInfo = 'operatorInfo';

  static const issueType = 'issueType';
  static const impact = 'impact';
  static const assetsNumber = 'assetsNumber';
  static const problemDescription = 'problemDescription';
  static const typeText = 'typeText';
  static const descriptionText = 'descriptionText';

  static const photos = 'photos';
  static const voiceNotePath = 'voiceNotePath';

  // OperatorInfoController keys
  static const reporter = 'reporter';
  static const employeeId = 'employeeId';
  static const phoneNumber = 'phoneNumber';
  static const location = 'location';
  static const plant = 'plant';
  static const reportedTime = 'reportedTime'; // "HH:mm"
  static const reportedDate = 'reportedDate'; // ISO 8601
  static const shift = 'shift';
  static const sameAsOperator = 'sameAsOperator';
}

class WorkOrderDraft extends GetxService {
  static const _storageKey = 'work_order_draft_single_map_v1';

  final _box = GetStorage();
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  late final Worker _debounceWorker;

  Future<WorkOrderDraft> init() async {
    final raw = _box.read(_storageKey);
    if (raw is Map) data.assignAll(Map<String, dynamic>.from(raw));

    _debounceWorker = debounce<Map<String, dynamic>>(
      data,
      (_) => _box.write(_storageKey, data),
      time: const Duration(milliseconds: 250),
    );
    return this;
  }

  // Generic accessors
  T get<T>(String key, T fallback) {
    final v = data[key];
    return v is T ? v : fallback;
  }

  void set(String key, dynamic value) {
    data[key] = value;
  }

  void merge(Map<String, dynamic> patch) {
    data.addAll(patch);
  }

  List<String> getList(String key) {
    final v = data[key];
    if (v is List) return v.map((e) => e.toString()).toList();
    return const <String>[];
  }

  void clearAll() => data.clear();

  @override
  void onClose() {
    _debounceWorker.dispose();
    super.onClose();
  }
}
