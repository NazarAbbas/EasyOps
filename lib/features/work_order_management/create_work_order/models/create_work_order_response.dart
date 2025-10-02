class CreateWorkOrderResponse {
  final String id;
  final WorkType type;
  final String plantId;
  final String departmentId;
  final Priority priority;
  final WorkStatus status;
  final String title;
  final String description;
  final String remark;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final int recordStatus;
  final DateTime updatedAt;
  final String tenantId;
  final String clientId;
  final String assetId;
  final String? reportedById;

  const CreateWorkOrderResponse({
    required this.id,
    required this.type,
    required this.plantId,
    required this.departmentId,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    required this.remark,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.recordStatus,
    required this.updatedAt,
    required this.tenantId,
    required this.clientId,
    required this.assetId,
    this.reportedById,
  });

  factory CreateWorkOrderResponse.fromJson(Map<String, dynamic> json) =>
      CreateWorkOrderResponse(
        id: json['id'] as String,
        type: WorkTypeX.fromApi(json['type'] as String?),
        plantId: json['plantId'] as String,
        departmentId: json['departmentId'] as String,
        priority: PriorityX.fromApi(json['priority'] as String?),
        status: WorkStatusX.fromApi(json['status'] as String?),
        title: json['title'] as String,
        description: json['description'] as String,
        remark: json['remark'] as String,
        scheduledStart: DateTime.parse(json['scheduledStart'] as String),
        scheduledEnd: DateTime.parse(json['scheduledEnd'] as String),
        recordStatus: (json['recordStatus'] as num).toInt(),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        tenantId: json['tenantId'] as String,
        clientId: json['clientId'] as String,
        assetId: json['assetId'] as String,
        reportedById: json['reportedById'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toApi(),
        'plantId': plantId,
        'departmentId': departmentId,
        'priority': priority.toApi(),
        'status': status.toApi(),
        'title': title,
        'description': description,
        'remark': remark,
        'scheduledStart': scheduledStart.toUtc().toIso8601String(),
        'scheduledEnd': scheduledEnd.toUtc().toIso8601String(),
        'recordStatus': recordStatus,
        'updatedAt': updatedAt.toIso8601String(),
        'tenantId': tenantId,
        'clientId': clientId,
        'assetId': assetId,
        'reportedById': reportedById,
      };

  CreateWorkOrderResponse copyWith({
    String? id,
    WorkType? type,
    String? plantId,
    String? departmentId,
    Priority? priority,
    WorkStatus? status,
    String? title,
    String? description,
    String? remark,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    int? recordStatus,
    DateTime? updatedAt,
    String? tenantId,
    String? clientId,
    String? assetId,
    String? reportedById, // pass null explicitly if you want to null it
  }) =>
      CreateWorkOrderResponse(
        id: id ?? this.id,
        type: type ?? this.type,
        plantId: plantId ?? this.plantId,
        departmentId: departmentId ?? this.departmentId,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        title: title ?? this.title,
        description: description ?? this.description,
        remark: remark ?? this.remark,
        scheduledStart: scheduledStart ?? this.scheduledStart,
        scheduledEnd: scheduledEnd ?? this.scheduledEnd,
        recordStatus: recordStatus ?? this.recordStatus,
        updatedAt: updatedAt ?? this.updatedAt,
        tenantId: tenantId ?? this.tenantId,
        clientId: clientId ?? this.clientId,
        assetId: assetId ?? this.assetId,
        reportedById: reportedById,
      );
}

/* ── Enums + mappers ── */

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
      case WorkType.other:
        return 'Other';
    }
  }
}
