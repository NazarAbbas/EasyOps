// lib/database/entity/asset_entity.dart
import 'package:easy_ops/database/converter/converters.dart';
import 'package:easy_ops/database/converter/criticality_converter.dart';
import 'package:floor/floor.dart';

@TypeConverters(
    [CriticalityConverter, AssetStatusConverter, DateTimeIsoConverter])
@Entity(
  tableName: 'assets',
  indices: [
    Index(value: ['tenantId', 'clientId', 'plantId']),
    Index(value: ['tenantId', 'clientId', 'serialNumber']),
    Index(value: ['tenantId', 'clientId', 'status']),
    Index(value: ['updatedAt']),
  ],
)

//{
//             "id": "AST-24Sep2025130416546006",
//             "assetNo": "AS-3333",
//             "name": "Industrial Pump Station A",
//             "criticality": "HIGH",
//             "description": "Main water pump station for building A - handles primary water distribution",
//             "serialNumber": "PS-2024-001",
//             "status": "ACTIVE",
//             "recordStatus": 1,
//             "updatedAt": "2025-09-24T13:04:16.551608Z",
//             "tenantId": "TEN-12Jun2025185848699001",
//             "clientId": "CLT-12Jun2025224115635000",
//             "plantId": null,
//             "plantName": null,
//             "assetManufacturerId": null,
//             "assetManufacturerName": null,
//             "technicalSpecifications": null,
//             "commercialSpecifications": null
//         },
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

  final String? plantName;

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
    required this.plantName
  });
}
