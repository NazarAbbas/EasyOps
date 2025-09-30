// lib/database/mappers/asset_mappers.dart
import 'package:easy_ops/database/converter/criticality_converter.dart';
import 'package:easy_ops/database/entity/assets_entity.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';

extension AssetEntityDomainX on AssetEntity {
  AssetItem toDomain() => AssetItem(
        id: id,
        name: name,
        criticality: criticality.name,
        description: description,
        serialNumber: serialNumber,
        manufacturer: manufacturer,
        manufacturerPhone: manufacturerPhone,
        manufacturerEmail: manufacturerEmail,
        manufacturerAddress: manufacturerAddress,
        status: status.name,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
        plantId: plantId,
        departmentId: departmentId,
        plantName: plantName,
        departmentName: departmentName,
      );
}

extension AssetDomainEntityX on AssetItem {
  AssetEntity toEntity() => AssetEntity(
        id: id,
        name: name,
        criticality: Criticality.values.firstWhere(
          (e) => e.name.toUpperCase() == criticality.toUpperCase(),
          orElse: () => Criticality.MEDIUM,
        ),
        description: description,
        // If your AssetItem.serialNumber is non-nullable, drop the !.
        serialNumber: serialNumber!,
        manufacturer: manufacturer,
        manufacturerPhone: manufacturerPhone,
        manufacturerEmail: manufacturerEmail,
        manufacturerAddress: manufacturerAddress,
        status: AssetStatus.values.firstWhere(
          (e) => e.name.toUpperCase() == status.toUpperCase(),
          orElse: () => AssetStatus.ACTIVE,
        ),
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
        plantId: plantId,
        departmentId: departmentId,
        plantName: plantName,
        departmentName: departmentName,
      );
}
