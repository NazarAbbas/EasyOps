import 'package:easy_ops/features/work_order_management/create_work_order/models/create_work_order_request.dart';

class OfflineWorkOrder {
  final int? id;

  final String type;
  final String priority;
  final String status;

  final String title;
  final String description;
  final String remark;

  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  final String assetId;
  final String plantId;
  final String departmentId;
  final String issueTypeId;
  final String impactId;
  final String shiftId;

  final List<MediaFile> mediaFiles;

  final DateTime createdAt;
  final bool synced;

  OfflineWorkOrder({
    this.id,
    required this.type,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    required this.remark,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.assetId,
    required this.plantId,
    required this.departmentId,
    required this.issueTypeId,
    required this.impactId,
    required this.shiftId,
    required this.mediaFiles,
    required this.createdAt,
    this.synced = false,
  });
}
