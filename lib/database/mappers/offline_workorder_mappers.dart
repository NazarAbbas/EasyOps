import 'dart:convert';

import 'package:easy_ops/database/entity/offline_work_order_entity.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/offline_work_order.dart';

/// ------------------ ENTITY -> DOMAIN ------------------
extension OfflineWorkOrderEntityX on OfflineWorkOrderEntity {
  OfflineWorkOrder toDomain() => OfflineWorkOrder(
        id: id,
        operatorId: operatorId,
        operatorName: operatorName,
        operatorPhoneNumber: operatorPhoneNumber,
        reporterId: reporterId,
        reporterName: reporterName,
        reporterPhoneNumber: reporterPhoneNumber,
        type: type,
        priority: priority,
        status: status,
        title: title,
        description: description,
        remark: remark,
        scheduledStart: DateTime.parse(scheduledStart),
        scheduledEnd: DateTime.parse(scheduledEnd),
        assetId: assetId,
        plantId: plantId,
        departmentId: departmentId,
        issueTypeId: issueTypeId,
        impactId: impactId,
        shiftId: shiftId,
        mediaFiles: (jsonDecode(mediaFilesJson) as List<dynamic>)
            .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(createdAt),
        synced: synced == "true",
      );
}

/// ------------------ DOMAIN -> ENTITY ------------------
extension OfflineWorkOrderDomainX on OfflineWorkOrder {
  OfflineWorkOrderEntity toEntity() => OfflineWorkOrderEntity(
        id: id,
        operatorId: operatorId,
        operatorName: operatorName,
        operatorPhoneNumber: operatorPhoneNumber,
        reporterId: reporterId,
        reporterName: reporterName,
        reporterPhoneNumber: reporterPhoneNumber,
        type: type,
        priority: priority,
        status: status,
        title: title,
        description: description,
        remark: remark,
        scheduledStart: scheduledStart.toIso8601String(),
        scheduledEnd: scheduledEnd.toIso8601String(),
        assetId: assetId,
        plantId: plantId,
        departmentId: departmentId,
        issueTypeId: issueTypeId,
        impactId: impactId,
        shiftId: shiftId,
        mediaFilesJson: jsonEncode(mediaFiles
            .map((m) => m.toJson())
            .toList()), // ✅ proper serialization
        createdAt: createdAt.toIso8601String(),
        synced: synced ? "true" : "false",
      );
}

/// ------------------ DOMAIN -> API REQUEST ------------------
extension OfflineWorkOrderApiMapper on OfflineWorkOrder {
  CreateWorkOrderRequest toApiRequest() {
    return CreateWorkOrderRequest(
      operatorId: operatorId,
      operatorName: operatorName,
      operatorPhoneNumber: operatorPhoneNumber,
      reporterId: reporterId,
      reporterName: reporterName,
      reporterPhoneNumber: reporterPhoneNumber,

      type: WorkType.values.byName(type),
      priority: PriorityX.fromApi(priority),
      status: WorkStatus.values.byName(status),
      title: title,
      description: description,
      remark: remark,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      assetId: assetId,
      plantId: plantId,
      departmentId: departmentId,
      issueTypeId: issueTypeId,
      impactId: impactId,
      shiftId: shiftId,
      mediaFiles: mediaFiles, // ✅ keep your MediaFile list for API
    );
  }
}
