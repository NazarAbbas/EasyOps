import 'package:easy_ops/database/entity/lookup_entity.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';

extension LookupEntityDomain on LookupEntity {
  LookupValues toDomain() => LookupValues(
        id: id,
        code: code,
        displayName: displayName,
        description: description,
        lookupType: lookupType,
        sortOrder: sortOrder,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}

extension LookupEntityMapper on LookupValues {
  LookupEntity toEntity() => LookupEntity(
        id: id,
        code: code,
        displayName: displayName,
        description: description,
        lookupType: lookupType,
        sortOrder: sortOrder,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}
