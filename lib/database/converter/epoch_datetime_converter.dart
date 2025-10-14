// lib/database/converter/date_time_converter.dart
import 'package:floor/floor.dart';

/// Stores DateTime as epoch millis (nullable-safe).
class EpochDateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) => databaseValue == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(databaseValue, isUtc: true);

  @override
  int? encode(DateTime? value) => value?.toUtc().millisecondsSinceEpoch;
}
