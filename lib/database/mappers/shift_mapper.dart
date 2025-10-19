// lib/database/mappers/shift_mappers.dart
import 'package:easy_ops/database/entity/shift_entity.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/shift_data.dart';
// ^ shift_data.dart contains ShiftData (page) AND Shift (row).
// We will map entity <-> Shift (row). Do NOT import/return ShiftData here.

extension ShiftEntityDomainX on ShiftEntity {
  Shift toDomain() => Shift(
        id: id,
        name: name,
        description: description ?? '',
        startTime: startTime,
        endTime: endTime,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}

extension ShiftDomainEntityX on Shift {
  ShiftEntity toEntity() => ShiftEntity(
        id: id,
        name: name,
        description:
            description, // entity allows nullable; your model has non-null
        startTime: startTime,
        endTime: endTime,
        recordStatus: recordStatus,
        updatedAt: updatedAt,
        tenantId: tenantId,
        clientId: clientId,
      );
}
