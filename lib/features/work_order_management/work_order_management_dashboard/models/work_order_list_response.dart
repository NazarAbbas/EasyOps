import 'dart:convert';

WorkOrderListResponse workOrderPageResponseFromJson(String s) =>
    WorkOrderListResponse.fromJson(json.decode(s) as Map<String, dynamic>);

String workOrderPageResponseToJson(WorkOrderListResponse r) =>
    json.encode(r.toJson());

class WorkOrderListResponse {
  final List<WorkOrder> content;
  final PageMeta page;

  const WorkOrderListResponse({
    required this.content,
    required this.page,
  });

  factory WorkOrderListResponse.fromJson(Map<String, dynamic> json) {
    final items = (json['content'] as List<dynamic>? ?? [])
        .map((e) => WorkOrder.fromJson(e as Map<String, dynamic>))
        .toList();

    return WorkOrderListResponse(
      content: items,
      page: PageMeta.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };
}

class PageMeta {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  const PageMeta({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
        size: (json['size'] as num?)?.toInt() ?? 0,
        number: (json['number'] as num?)?.toInt() ?? 0,
        totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
        totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}

class WorkOrder {
  final String id;
  final String type; // e.g. "Breakdown Management", "Other"
  final String? plantId;
  final String? plantName;
  final String? departmentId;
  final String? departmentName;
  final String priority; // "HIGH" | "MEDIUM" | "LOW"
  final String status; // "OPEN" | ...
  final String title;
  final String description;
  final String remark;
  final DateTime? scheduledStart; // ISO8601 Z
  final DateTime? scheduledEnd; // ISO8601 Z
  final int recordStatus;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final TenantRef? tenant;
  final ClientRef? client;
  final AssetRef? asset;

  final String? reportedBy; // null in sample
  final String? createdBy; // null in sample
  final String? updatedBy; // null in sample

  final List<MediaFileItem> mediaFiles;

  const WorkOrder({
    required this.id,
    required this.type,
    required this.plantId,
    required this.plantName,
    required this.departmentId,
    required this.departmentName,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    required this.remark,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.tenant,
    required this.client,
    required this.asset,
    required this.reportedBy,
    required this.createdBy,
    required this.updatedBy,
    required this.mediaFiles,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
        id: json['id'] as String,
        type: json['type'] as String,
        plantId: json['plantId'] as String?,
        plantName: json['plantName'] as String?,
        departmentId: json['departmentId'] as String?,
        departmentName: json['departmentName'] as String?,
        priority: json['priority'] as String? ?? 'MEDIUM',
        status: json['status'] as String? ?? 'OPEN',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        remark: json['remark'] as String? ?? '',
        scheduledStart: _dt(json['scheduledStart']),
        scheduledEnd: _dt(json['scheduledEnd']),
        recordStatus: (json['recordStatus'] as num?)?.toInt() ?? 0,
        createdAt: _dt(json['createdAt']),
        updatedAt: _dt(json['updatedAt']),
        tenant: json['tenant'] == null
            ? null
            : TenantRef.fromJson(json['tenant'] as Map<String, dynamic>),
        client: json['client'] == null
            ? null
            : ClientRef.fromJson(json['client'] as Map<String, dynamic>),
        asset: json['asset'] == null
            ? null
            : AssetRef.fromJson(json['asset'] as Map<String, dynamic>),
        reportedBy: json['reportedBy'] as String?,
        createdBy: json['createdBy'] as String?,
        updatedBy: json['updatedBy'] as String?,
        mediaFiles: (json['mediaFiles'] as List<dynamic>? ?? [])
            .map((e) => MediaFileItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'plantId': plantId,
        'plantName': plantName,
        'departmentId': departmentId,
        'departmentName': departmentName,
        'priority': priority,
        'status': status,
        'title': title,
        'description': description,
        'remark': remark,
        'scheduledStart': scheduledStart?.toUtc().toIso8601String(),
        'scheduledEnd': scheduledEnd?.toUtc().toIso8601String(),
        'recordStatus': recordStatus,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
        'tenant': tenant?.toJson(),
        'client': client?.toJson(),
        'asset': asset?.toJson(),
        'reportedBy': reportedBy,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'mediaFiles': mediaFiles.map((e) => e.toJson()).toList(),
      };

  static DateTime? _dt(Object? v) {
    if (v == null) return null;
    final s = v.toString();
    return DateTime.tryParse(s);
  }
}

class TenantRef {
  final String id;
  final String name;

  const TenantRef({required this.id, required this.name});

  factory TenantRef.fromJson(Map<String, dynamic> json) => TenantRef(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ClientRef {
  final String id;
  final String name;

  const ClientRef({required this.id, required this.name});

  factory ClientRef.fromJson(Map<String, dynamic> json) => ClientRef(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AssetRef {
  final String id;
  final String name;
  final String? serialNumber;
  final String status;

  const AssetRef({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.status,
  });

  factory AssetRef.fromJson(Map<String, dynamic> json) => AssetRef(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        serialNumber: json['serialNumber'] as String?,
        status: json['status'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'serialNumber': serialNumber,
        'status': status,
      };
}

class MediaFileItem {
  final String id;
  final String filePath;
  final String fileName;
  final String fileType;
  final int? fileSize; // null in sample
  final DateTime? createdAt;

  const MediaFileItem({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.createdAt,
  });

  factory MediaFileItem.fromJson(Map<String, dynamic> json) => MediaFileItem(
        id: json['id'] as String? ?? '',
        filePath: json['filePath'] as String? ?? '',
        fileName: json['fileName'] as String? ?? '',
        fileType: json['fileType'] as String? ?? '',
        fileSize: (json['fileSize'] as num?)?.toInt(),
        createdAt: WorkOrder._dt(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'filePath': filePath,
        'fileName': fileName,
        'fileType': fileType,
        'fileSize': fileSize,
        'createdAt': createdAt?.toUtc().toIso8601String(),
      };
}
