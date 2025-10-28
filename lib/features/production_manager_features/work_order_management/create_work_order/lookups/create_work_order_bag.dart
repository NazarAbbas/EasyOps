import 'package:get/get.dart';
// Use explicit rx types so we can unwrap without relying on RxInterface.value
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WorkOrderBag extends GetxService {
  final RxMap<String, dynamic> _bag = <String, dynamic>{}.obs;

  /// Merge data into the bag, unwrapping any Rx containers.
  void merge(Map<String, dynamic> data) =>
      _bag.addAll(data.map((k, v) => MapEntry(k, _toPlain(v))));

  /// Snapshot of current values as plain Dart types.
  Map<String, dynamic> snapshot() =>
      _bag.map((k, v) => MapEntry(k, _toPlain(v)));

  /// Typed getter that returns [fallback] if key missing, null, or type-mismatch.
  T get<T>(String key, T fallback) {
    if (!_bag.containsKey(key)) return fallback;
    final plain = _toPlain(_bag[key]);

    // Handle nulls explicitly
    if (plain == null) return fallback;

    // Exact match
    if (plain is T) return plain;

    // Gentle coercions for common cases
    // 1) List<dynamic> → List<String>
    if (plain is List && T.toString() == 'List<String>') {
      return plain.map((e) => e?.toString() ?? '').cast<String>().toList() as T;
    }

    // 2) bool → String (rare, but shields accidental mis-saves)
    if (plain is bool && T == String) {
      return (plain ? 'true' : 'false') as T;
    }

    // 3) num → String
    if (plain is num && T == String) {
      return plain.toString() as T;
    }

    // Type mismatch → fallback
    return fallback;
  }

  void clear() => _bag.clear();

  /// Read ALL values as plain types and return (non-destructive).
  Map<String, dynamic> takeAll() => snapshot();

  // ─────────── Internals ───────────

  dynamic _toPlain(dynamic v) {
    // Unwrap concrete Rx containers first
    if (v is RxList) return v.toList();
    if (v is RxMap) return Map<String, dynamic>.from(v);
    if (v is RxSet) return Set.from(v);

    // Unwrap generic Rx<T> and Rxn<T>
    if (v is Rx) return _toPlain(v.value);
    if (v is Rxn) return _toPlain(v.value);

    // Normalize collections to plain Dart counterparts
    if (v is Map) return Map<String, dynamic>.from(v);
    if (v is Iterable && v is! String) return List.from(v);

    // Already plain (String, num, bool, DateTime, etc.)
    return v;
  }
}

abstract class WOKeys {
  // ---------- Work Order Info (WorkorderInfoController)
  static const issueTypeId = 'issueTypeId';
  static const impactId = 'impactId';
  static const assetsId = 'assetsId';

  static const plantId = 'plantId';
  static const departmentId = 'departmentId';
  static const reportedAt = 'reportedAt';
  static const reportedOn = 'reportedOn';
  static const shiftId = 'shiftId';

  static const issueType = 'issueType';
  static const impact = 'impact';
  static const assetsNumber = 'assetsNumber';
  static const problemDescription = 'problemDescription';
  static const title = 'title';
  static const typeText = 'typeText';
  static const descriptionText = 'descriptionText';

  static const photos = 'photos';
  static const voiceNotePath = 'voiceNotePath';

  // ---------- Reporter Info tab (OperatorInfoController)
  static const String reporterName = 'reporterName';
  static const String reporterPhoneNumber = 'reporterPhoneNumber';
  static const String reporterId = 'reporterId';

  // ---------- Operator Info tab (OperatorInfoController)
  static const String operatorName = 'operatorName';
  static const String operatorPhoneNumber = 'operatorPhoneNumber';
  static const String operatorInfo = 'operatorInfo';
  static const String operatorId = 'operatorId';

  static const String location = 'location';
  static const String plant = 'plant';
  static const String shift = 'shift';

  static const String sameAsOperator = 'sameAsOperator'; // bool

  // Stored as strings for portability
  static const String reportedTime = 'reportedTime'; // "HH:mm" or null
  static const String reportedDate = 'reportedDate'; // ISO-8601 or null

  static const String locations = 'locations';
  static const String plantsOpt = 'plantsOpt';
  static const String shiftsOpt = 'shiftsOpt';
}
