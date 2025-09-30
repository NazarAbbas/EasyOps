import 'package:floor/floor.dart';
import '../../features/work_order_management/create_work_order/models/lookup_data.dart';

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
  String encode(DateTime value) => value.toUtc().toIso8601String();
}
