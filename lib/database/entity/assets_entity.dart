// lib/database/entity/asset_entity.dart
import 'package:easy_ops/database/converter/converters.dart';
import 'package:easy_ops/database/converter/criticality_converter.dart';
import 'package:floor/floor.dart';

@TypeConverters(
    [CriticalityConverter, AssetStatusConverter, DateTimeIsoConverter])
@Entity(
  tableName: 'assets',
  indices: [
    Index(value: ['tenantId', 'clientId', 'serialNumber'], unique: true),
    Index(value: ['tenantId', 'clientId', 'plantId']),
    Index(value: ['tenantId', 'clientId', 'departmentId']),
    Index(value: ['tenantId', 'clientId', 'status']),
    Index(value: ['updatedAt']),
  ],
)
class AssetEntity {
  @primaryKey
  final String id; // "AST-24Sep2025130416546006"

  final String name;
  final Criticality criticality; // "HIGH"
  final String? description;

  final String serialNumber; // "PS-2024-001"

  final String? manufacturer;
  final String? manufacturerPhone;
  final String? manufacturerEmail;
  final String? manufacturerAddress;

  final AssetStatus status; // "ACTIVE"
  final int recordStatus; // 1=active, 2=inactive, 0=deleted
  final DateTime updatedAt; // ISO

  final String tenantId;
  final String clientId;

  final String plantId;
  final String departmentId;

  final String? plantName;
  final String? departmentName;

  const AssetEntity({
    required this.id,
    required this.name,
    required this.criticality,
    required this.description,
    required this.serialNumber,
    required this.manufacturer,
    required this.manufacturerPhone,
    required this.manufacturerEmail,
    required this.manufacturerAddress,
    required this.status,
    required this.recordStatus,
    required this.updatedAt,
    required this.tenantId,
    required this.clientId,
    required this.plantId,
    required this.departmentId,
    required this.plantName,
    required this.departmentName,
  });
}
