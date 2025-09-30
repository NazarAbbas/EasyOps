// lib/database/converter/date_time_iso_converter.dart
import 'package:floor/floor.dart';

class DateTimeIsoConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String v) => DateTime.parse(v);
  @override
  String encode(DateTime v) => v.toIso8601String();
}
