import 'package:get/get.dart';

class WorkOrderBag extends GetxService {
  final RxMap<String, dynamic> _bag = <String, dynamic>{}.obs;

  void merge(Map<String, dynamic> data) => _bag.addAll(data);
  Map<String, dynamic> snapshot() => Map<String, dynamic>.from(_bag);
  T get<T>(String key, T fallback) => (_bag[key] as T?) ?? fallback;

  void clear() => _bag.clear();

  /// Read ALL values and clear the bag in a single call.
  Map<String, dynamic> takeAll() {
    final snap = snapshot();
    // clear();
    return snap;
  }
}

abstract class WOKeys {
  // ---------- Work Order Info (WorkorderInfoController)

  //static const asset = 'asset';

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
  static const typeText = 'typeText';
  static const descriptionText = 'descriptionText';

  static const photos = 'photos';
  static const voiceNotePath = 'voiceNotePath';

  static const operatorName = 'operatorName';
  static const operatorMobileNumber = 'operatorMobileNumber';
  static const operatorInfo = 'operatorInfo';

  // ---------- Operator Info tab (OperatorInfoController)
  static const String reporter = 'reporter';
  static const String employeeId = 'employeeId';
  static const String phoneNumber = 'phoneNumber';

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
