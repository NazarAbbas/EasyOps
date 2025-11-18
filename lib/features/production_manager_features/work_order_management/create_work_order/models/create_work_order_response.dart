class CreateWorkOrderResponse {
  final String? id;
  final String? issueNo;
  final String? categoryId;
  final String? categoryName;
  final String? issueTypeId;
  final String? issueTypeName;
  final String? plantId;
  final String? plantName;
  final String? locationId;
  final String? locationName;
  final String? shiftId;
  final String? shiftName;
  final String? priority;
  final String? status;
  final String? title;
  final String? description;
  final String? remark;
  final String? comment;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final int? recordStatus;
  final DateTime? updatedAt;
  final String? tenantId;
  final String? clientId;
  final String? assetId;
  final String? reportedById;
  final String? reportedByName;
  final String? operatorId;
  final String? operatorName;
  final String? impactId;
  final int? escalated;
  final DateTime? reportedTime;
  final String? estimatedTimeToFix;
  final String? assignedToId;
  final DateTime? dueDate;

  CreateWorkOrderResponse({
    this.id,
    this.issueNo,
    this.categoryId,
    this.categoryName,
    this.issueTypeId,
    this.issueTypeName,
    this.plantId,
    this.plantName,
    this.locationId,
    this.locationName,
    this.shiftId,
    this.shiftName,
    this.priority,
    this.status,
    this.title,
    this.description,
    this.remark,
    this.comment,
    this.scheduledStart,
    this.scheduledEnd,
    this.recordStatus,
    this.updatedAt,
    this.tenantId,
    this.clientId,
    this.assetId,
    this.reportedById,
    this.reportedByName,
    this.operatorId,
    this.operatorName,
    this.impactId,
    this.escalated,
    this.reportedTime,
    this.estimatedTimeToFix,
    this.assignedToId,
    this.dueDate,
  });

  factory CreateWorkOrderResponse.fromJson(Map<String, dynamic> json) =>
      CreateWorkOrderResponse(
        id: json['id'] as String?,
        issueNo: json['issueNo'] as String?,
        categoryId: json['categoryId'] as String?,
        categoryName: json['categoryName'] as String?,
        issueTypeId: json['issueTypeId'] as String?,
        issueTypeName: json['issueTypeName'] as String?,
        plantId: json['plantId'] as String?,
        plantName: json['plantName'] as String?,
        locationId: json['locationId'] as String?,
        locationName: json['locationName'] as String?,
        shiftId: json['shiftId'] as String?,
        shiftName: json['shiftName'] as String?,
        priority: json['priority'] as String?,
        status: json['status'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        remark: json['remark'] as String?,
        comment: json['comment'] as String?,
        scheduledStart: json['scheduledStart'] != null
            ? DateTime.tryParse(json['scheduledStart'])
            : null,
        scheduledEnd: json['scheduledEnd'] != null
            ? DateTime.tryParse(json['scheduledEnd'])
            : null,
        recordStatus: json['recordStatus'] != null
            ? (json['recordStatus'] as num).toInt()
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : null,
        tenantId: json['tenantId'] as String?,
        clientId: json['clientId'] as String?,
        assetId: json['assetId'] as String?,
        reportedById: json['reportedById'] as String?,
        reportedByName: json['reportedByName'] as String?,
        operatorId: json['operatorId'] as String?,
        operatorName: json['operatorName'] as String?,
        impactId: json['impactId'] as String?,
        escalated: json['escalated'] != null
            ? (json['escalated'] as num?)?.toInt()
            : null,
        reportedTime: json['reportedTime'] != null
            ? DateTime.tryParse(json['reportedTime'])
            : null,
        estimatedTimeToFix: json['estimatedTimeToFix']?.toString(),
        assignedToId: json['assignedToId'] as String?,
        dueDate:
            json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'issueNo': issueNo,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'issueTypeId': issueTypeId,
        'issueTypeName': issueTypeName,
        'plantId': plantId,
        'plantName': plantName,
        'locationId': locationId,
        'locationName': locationName,
        'shiftId': shiftId,
        'shiftName': shiftName,
        'priority': priority,
        'status': status,
        'title': title,
        'description': description,
        'remark': remark,
        'comment': comment,
        'scheduledStart': scheduledStart?.toIso8601String(),
        'scheduledEnd': scheduledEnd?.toIso8601String(),
        'recordStatus': recordStatus,
        'updatedAt': updatedAt?.toIso8601String(),
        'tenantId': tenantId,
        'clientId': clientId,
        'assetId': assetId,
        'reportedById': reportedById,
        'reportedByName': reportedByName,
        'operatorId': operatorId,
        'operatorName': operatorName,
        'impactId': impactId,
        'escalated': escalated,
        'reportedTime': reportedTime?.toIso8601String(),
        'estimatedTimeToFix': estimatedTimeToFix,
        'assignedToId': assignedToId,
        'dueDate': dueDate?.toIso8601String(),
      };
}
