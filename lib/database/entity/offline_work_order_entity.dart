import 'package:floor/floor.dart';

@Entity(tableName: 'offline_workorders')
class OfflineWorkOrderEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String operatorName;
  final String operatorId;
  final String operatorPhoneNumber;

  final String categoryId;
  final String categoryName;

  final String reporterId;
  final String reporterName;
  final String reporterPhoneNumber;

  // Core fields
  final String type;
  final String priority;
  final String status;

  final String title;
  final String description;
  final String remark;

  // Time fields (store as ISO string)
  final String scheduledStart;
  final String scheduledEnd;

  // Foreign IDs
  final String assetId;
  final String plantId;
  final String locationId;
  final String departmentId;
  final String issueTypeId;
  final String impactId;
  final String shiftId;

  // Media (save as JSON string to keep multiple items)
  final String mediaFilesJson;

  // Audit fields
  final String createdAt;
  final String synced; // "false" if offline, "true" if already synced

  OfflineWorkOrderEntity({
    this.id,
    required this.operatorId,
    required this.operatorName,
    required this.operatorPhoneNumber,
    required this.categoryId,
    required this.categoryName,
    required this.reporterId,
    required this.reporterName,
    required this.reporterPhoneNumber,
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
    required this.locationId,
    required this.departmentId,
    required this.issueTypeId,
    required this.impactId,
    required this.shiftId,
    required this.mediaFilesJson,
    required this.createdAt,
    this.synced = "false",
  });
}
