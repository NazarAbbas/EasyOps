import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:floor/floor.dart';
import '../../features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';

/// Stores DateTime as epoch millis (nullable-safe).
class EpochDateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) => databaseValue == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(databaseValue, isUtc: true);

  @override
  int? encode(DateTime? value) => value?.toUtc().millisecondsSinceEpoch;
}

class LookupTypeConverter extends TypeConverter<LookupType, String> {
  @override
  LookupType decode(String databaseValue) {
    return LookupTypeX.fromString(databaseValue);
  }

  @override
  String encode(LookupType value) {
    return value.name.toUpperCase();
  }
}

class DateTimeIsoConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) => DateTime.parse(databaseValue);

  @override
  String encode(DateTime? value) => value?.toUtc().toIso8601String() ?? '';
}

enum Criticality { LOW, MEDIUM, HIGH }

enum AssetStatus { ACTIVE, INACTIVE }

class CriticalityConverter extends TypeConverter<Criticality, String> {
  @override
  Criticality decode(String databaseValue) => Criticality.values.firstWhere(
        (e) => e.name.toUpperCase() == databaseValue.toUpperCase(),
        orElse: () => Criticality.MEDIUM,
      );

  @override
  String encode(Criticality value) => value.name;
}

class AssetStatusConverter extends TypeConverter<AssetStatus, String> {
  @override
  AssetStatus decode(String databaseValue) => AssetStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == databaseValue.toUpperCase(),
        orElse: () => AssetStatus.ACTIVE,
      );

  @override
  String encode(AssetStatus value) => value.name;
}

class _DateTimeIsoHelper {
  static String toIso(DateTime d) => d.toUtc().toIso8601String();
  static DateTime fromIso(String s) => DateTime.parse(s);
}

class _UserTypeHelper {
  static String toDb(UserType t) => t.label; // store the label
  static UserType fromDb(String? s) => UserTypeX.fromString(s);
}

/// DateTime <-> String (ISO-8601)
class DateTimeConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) =>
      _DateTimeIsoHelper.fromIso(databaseValue);

  @override
  String encode(DateTime value) => _DateTimeIsoHelper.toIso(value);
}

/// UserType <-> String (label)
class UserTypeConverter extends TypeConverter<UserType, String> {
  @override
  UserType decode(String databaseValue) =>
      _UserTypeHelper.fromDb(databaseValue);

  @override
  String encode(UserType value) => _UserTypeHelper.toDb(value);
}
