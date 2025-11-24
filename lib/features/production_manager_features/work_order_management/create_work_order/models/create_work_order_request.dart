import 'dart:convert';

class CreateWorkOrderRequest {
  final String operatorName;
  final String operatorId;
  final String operatorPhoneNumber;

  final String categoryId;
  final String categoryName;

  final String reporterById;
  final String reporterName;
  final String reporterPhoneNumber;

  final WorkType type;
  final Priority priority;
  final WorkStatus status;
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

  const CreateWorkOrderRequest({
    required this.operatorId,
    required this.operatorName,
    required this.operatorPhoneNumber,
    required this.categoryId,
    required this.categoryName,
    required this.reporterById,
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
    required this.departmentId,
    required this.mediaFiles,
    required this.issueTypeId,
    required this.impactId,
    required this.shiftId,
  });

  CreateWorkOrderRequest copyWith({
    WorkType? type,
    Priority? priority,
    WorkStatus? status,
    String? title,
    String? description,
    String? remark,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    String? assetId,
    String? plantId,
    String? departmentId,
    String? issueTypeId,
    String? impactId,
    String? shiftId,
    List<MediaFile>? mediaFiles,
  }) {
    return CreateWorkOrderRequest(
      operatorId: operatorId ?? this.operatorId,
      operatorName: operatorName ?? this.operatorName,
      operatorPhoneNumber: operatorPhoneNumber ?? this.operatorPhoneNumber,
      categoryId: categoryId,
      categoryName: categoryName,
      reporterById: reporterById ?? this.reporterById,
      reporterName: reporterName ?? this.reporterName,
      reporterPhoneNumber: reporterPhoneNumber ?? this.reporterPhoneNumber,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      remark: remark ?? this.remark,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      assetId: assetId ?? this.assetId,
      plantId: plantId ?? this.plantId,
      departmentId: departmentId ?? this.departmentId,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      issueTypeId: issueTypeId ?? this.issueTypeId,
      impactId: impactId ?? this.impactId,
      shiftId: shiftId ?? this.shiftId,
    );
  }

  factory CreateWorkOrderRequest.fromJson(Map<String, dynamic> json) {
    return CreateWorkOrderRequest(
      operatorId: json['operatorId'] as String,
      operatorName: json['operatorName'] as String,
      operatorPhoneNumber: json['operatorPhoneNumber'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      reporterById: json['reporterId'] as String,
      reporterName: json['reporterName'] as String,
      reporterPhoneNumber: json['reporterPhoneNumber'] as String,
      type: WorkTypeX.fromApi(json['type'] as String?),
      priority: PriorityX.fromApi(json['priority'] as String?),
      status: WorkStatusX.fromApi(json['status'] as String?),
      title: json['title'] as String,
      description: json['description'] as String,
      remark: json['remark'] as String,
      scheduledStart: DateTime.parse(json['scheduledStart'] as String),
      scheduledEnd: DateTime.parse(json['scheduledEnd'] as String),
      assetId: json['assetId'] as String,
      plantId: json['plantId'] as String,
      departmentId: json['departmentId'] as String,
      issueTypeId: (json['issueTypeId'] as String?) ?? '',
      impactId: (json['impactId'] as String?) ?? '',
      shiftId: (json['shiftId'] as String?) ?? '',
      mediaFiles: (json['mediaFiles'] as List<dynamic>? ?? const [])
          .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  //{
  // "type": "Maintenance",
  // "plantId": "CLU-23Sep2025184636779022",
  // "departmentId": "CLU-23Sep2025184335252018",
  // "priority": "High",
  // "status": "Open",
  // "title": "Equipment Maintenance",
  // "description": "Regular maintenance for production equipment",
  // "remark": "Urgent repair needed",
  // "comment": "Additional notes and comments about the work order",
  // "scheduledStart": "2025-01-15T09:00:00Z",
  // "scheduledEnd": "2025-01-15T17:00:00Z",
  // "assetId": "AST-24Sep2025130416546006",
  // "reportedById": "PER-123456",
  // "operatorId": "PER-789012",
  // "impactId": "CLU-24Sep2025131625261017",
  // "escalated": 0,
  // "reportedTime": "2025-01-15T08:30:00Z",
  // "estimatedTimeToFix": "2 hours",
  // "assignedToId": "PER-123458"
  // }

  Map<String, dynamic> toJson() => {
        'type': issueTypeId,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'plantId': plantId,
        'departmentId': departmentId,
        'priority': priority.toApi(),
        'status': status.toApi(),
        'title': title,
        'description': description,
        'remark': remark,
        // keep schedule in UTC like "Z"
        'scheduledStart': scheduledStart.toUtc().toIso8601String(),
        'scheduledEnd': scheduledEnd.toUtc().toIso8601String(),
        'assetId': assetId,
        'reportedById': reporterById,
        'operatorId': operatorId,
        'issueTypeId': issueTypeId,
        'impactId': impactId,
        'shiftId': shiftId,
        'reportedTime': scheduledStart.toUtc().toIso8601String(),
        'estimatedTimeToFix': scheduledEnd.toUtc().toIso8601String(),
        'mediaFiles': mediaFiles.map((e) => e.toJson()).toList(),
      };

  // Optional helpers
  String toJsonString() => json.encode(toJson());

  static CreateWorkOrderRequest fromJsonString(String s) =>
      CreateWorkOrderRequest.fromJson(json.decode(s) as Map<String, dynamic>);
}

class MediaFile {
  final String filePath;
  final String fileType; // MIME type

  const MediaFile({required this.filePath, required this.fileType});

  MediaFile copyWith({String? filePath, String? fileType}) => MediaFile(
        filePath: filePath ?? this.filePath,
        fileType: fileType ?? this.fileType,
      );

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        filePath: json['filePath'] as String,
        fileType: json['fileType'] as String,
      );

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'fileType': fileType,
      };
}

/// —— Enums & mappers ——

enum Priority { low, medium, high }

extension PriorityX on Priority {
  static Priority fromApi(String? v) {
    switch ((v ?? '').toUpperCase()) {
      case 'LOW':
        return Priority.low;
      case 'MEDIUM':
        return Priority.medium;
      case 'HIGH':
        return Priority.high;
      default:
        return Priority.medium;
    }
  }

  String toApi() {
    switch (this) {
      case Priority.low:
        return 'LOW';
      case Priority.medium:
        return 'MEDIUM';
      case Priority.high:
        return 'HIGH';
    }
  }
}

enum WorkStatus { open, inProgress, onHold, closed, cancelled }

extension WorkStatusX on WorkStatus {
  static WorkStatus fromApi(String? v) {
    switch ((v ?? '').toUpperCase()) {
      case 'OPEN':
        return WorkStatus.open;
      case 'IN_PROGRESS':
        return WorkStatus.inProgress;
      case 'ON_HOLD':
        return WorkStatus.onHold;
      case 'CLOSED':
        return WorkStatus.closed;
      case 'CANCELLED':
        return WorkStatus.cancelled;
      default:
        return WorkStatus.open;
    }
  }

  String toApi() {
    switch (this) {
      case WorkStatus.open:
        return 'OPEN';
      case WorkStatus.inProgress:
        return 'IN_PROGRESS';
      case WorkStatus.onHold:
        return 'ON_HOLD';
      case WorkStatus.closed:
        return 'CLOSED';
      case WorkStatus.cancelled:
        return 'CANCELLED';
    }
  }
}

enum WorkType {
  general,
  breakdownManagement,
  preventiveMaintenance,
  predictiveMaintenance,
  other
}

extension WorkTypeX on WorkType {
  static WorkType fromApi(String? v) {
    final s = (v ?? '').trim().toUpperCase();
    if (s == 'BREAKDOWN MANAGEMENT') return WorkType.breakdownManagement;
    if (s == 'PREVENTIVE MAINTENANCE') return WorkType.preventiveMaintenance;
    if (s == 'PREDICTIVE MAINTENANCE') return WorkType.predictiveMaintenance;
    return WorkType.other;
  }

  String toApi() {
    switch (this) {
      case WorkType.breakdownManagement:
        return 'Breakdown Management';
      case WorkType.preventiveMaintenance:
        return 'Preventive Maintenance';
      case WorkType.predictiveMaintenance:
        return 'Predictive Maintenance';
      case WorkType.general:
        return 'General';
      case WorkType.other:
        return 'Other';
    }
  }

  String toCode() {
    switch (this) {
      case WorkType.breakdownManagement:
        return 'BREAKDOWN';
      case WorkType.preventiveMaintenance:
        return 'PREVENTIVE';
      case WorkType.general:
        return 'GENERAL';
      case WorkType.predictiveMaintenance:
        return 'PREDICTIVE';
      case WorkType.other:
        return 'Other';
    }
  }
}
