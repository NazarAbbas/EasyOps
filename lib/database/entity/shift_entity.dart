// lib/database/entity/shift_entity.dart
import 'package:easy_ops/database/converter/converters.dart';
import 'package:floor/floor.dart';

@TypeConverters([DateTimeIsoConverter])
@Entity(
  tableName: 'shifts',
  indices: [
    Index(value: ['tenantId', 'clientId', 'name'], unique: true),
    Index(value: ['tenantId', 'clientId']),
    Index(value: ['updatedAt']),
  ],
)
class ShiftEntity {
  @primaryKey
  final String id;

  final String name;
  final String? description;

  /// Stored as "HH:mm:ss" (e.g., "06:00:00")
  final String startTime;

  /// Stored as "HH:mm:ss" (e.g., "14:00:00")
  final String endTime;

  /// 1=active, 2=inactive, 0=deleted
  final int recordStatus;

  /// ISO-8601 string via converter
  final DateTime updatedAt;

  final String tenantId;
  final String clientId;

  const ShiftEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.recordStatus,
    required this.updatedAt,
    required this.tenantId,
    required this.clientId,
  });
}
