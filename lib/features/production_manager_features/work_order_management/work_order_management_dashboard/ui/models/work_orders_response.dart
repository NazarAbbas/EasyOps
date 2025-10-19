// models/work_orders_response.dart
class WorkOrdersResponse {
  final List<WorkOrderDto> content;
  final PageMeta page;

  WorkOrdersResponse({
    required this.content,
    required this.page,
  });

  factory WorkOrdersResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrdersResponse(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => WorkOrderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
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

  PageMeta({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
        size: (json['size'] ?? 0) as int,
        number: (json['number'] ?? 0) as int,
        totalElements: (json['totalElements'] ?? 0) as int,
        totalPages: (json['totalPages'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}

class WorkOrderDto {
  final String id;
  final String type;

  final String? plantId;
  final String? plantName;

  final String? departmentId;
  final String? departmentName;

  final String? priority; // e.g. "HIGH"
  final String? status; // e.g. "OPEN"

  final String? title;
  final String? description;
  final String? remark;

  final DateTime? scheduledStart; // ISO
  final DateTime? scheduledEnd; // ISO

  final int? recordStatus;
  final DateTime? createdAt; // ISO
  final DateTime? updatedAt; // ISO

  // UI-oriented fields present in payload
  final String? code;
  final String? time;
  final String? date;
  final String? department; // duplicate concept of departmentName
  final String? line;
  final String? duration;
  final String? footerTag;

  final SimpleRef? tenant;
  final SimpleRef? client;
  final AssetRef? asset;

  final String? reportedBy;
  final String? createdBy;
  final String? updatedBy;

  final List<MediaFile> mediaFiles;

  WorkOrderDto({
    required this.id,
    required this.type,
    this.plantId,
    this.plantName,
    this.departmentId,
    this.departmentName,
    this.priority,
    this.status,
    this.title,
    this.description,
    this.remark,
    this.scheduledStart,
    this.scheduledEnd,
    this.recordStatus,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.time,
    this.date,
    this.department,
    this.line,
    this.duration,
    this.footerTag,
    this.tenant,
    this.client,
    this.asset,
    this.reportedBy,
    this.createdBy,
    this.updatedBy,
    this.mediaFiles = const [],
  });

  factory WorkOrderDto.fromJson(Map<String, dynamic> json) => WorkOrderDto(
        id: json['id'] as String,
        type: json['type'] as String,
        plantId: json['plantId'] as String?,
        plantName: json['plantName'] as String?,
        departmentId: json['departmentId'] as String?,
        departmentName: json['departmentName'] as String?,
        priority: json['priority'] as String?,
        status: json['status'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        remark: json['remark'] as String?,
        scheduledStart: _parseDate(json['scheduledStart']),
        scheduledEnd: _parseDate(json['scheduledEnd']),
        recordStatus: (json['recordStatus'] as num?)?.toInt(),
        createdAt: _parseDate(json['createdAt']),
        updatedAt: _parseDate(json['updatedAt']),
        code: json['code'] as String?,
        time: json['time'] as String?,
        date: json['date'] as String?,
        department: json['department'] as String?,
        line: json['line'] as String?,
        duration: json['duration'] as String?,
        footerTag: json['footerTag'] as String?,
        tenant: _mapIfPresent(json['tenant'], (m) => SimpleRef.fromJson(m)),
        client: _mapIfPresent(json['client'], (m) => SimpleRef.fromJson(m)),
        asset: _mapIfPresent(json['asset'], (m) => AssetRef.fromJson(m)),
        reportedBy: json['reportedBy'] as String?,
        createdBy: json['createdBy'] as String?,
        updatedBy: json['updatedBy'] as String?,
        mediaFiles: (json['mediaFiles'] as List<dynamic>? ?? [])
            .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
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
        'scheduledStart': scheduledStart?.toIso8601String(),
        'scheduledEnd': scheduledEnd?.toIso8601String(),
        'recordStatus': recordStatus,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'code': code,
        'time': time,
        'date': date,
        'department': department,
        'line': line,
        'duration': duration,
        'footerTag': footerTag,
        'tenant': tenant?.toJson(),
        'client': client?.toJson(),
        'asset': asset?.toJson(),
        'reportedBy': reportedBy,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'mediaFiles': mediaFiles.map((e) => e.toJson()).toList(),
      };
}

class SimpleRef {
  final String id;
  final String name;

  SimpleRef({required this.id, required this.name});

  factory SimpleRef.fromJson(Map<String, dynamic> json) =>
      SimpleRef(id: json['id'] as String, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AssetRef {
  final String id;
  final String name;
  final String? serialNumber;
  final String? status;

  AssetRef({
    required this.id,
    required this.name,
    this.serialNumber,
    this.status,
  });

  factory AssetRef.fromJson(Map<String, dynamic> json) => AssetRef(
        id: json['id'] as String,
        name: json['name'] as String,
        serialNumber: json['serialNumber'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'serialNumber': serialNumber,
        'status': status,
      };
}

class MediaFile {
  final String id;
  final String filePath;
  final String fileName;
  final String fileType;
  final int? fileSize;
  final DateTime? createdAt;

  MediaFile({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    this.fileSize,
    this.createdAt,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        id: json['id'] as String,
        filePath: json['filePath'] as String,
        fileName: json['fileName'] as String,
        fileType: json['fileType'] as String,
        fileSize: (json['fileSize'] as num?)?.toInt(),
        createdAt: _parseDate(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'filePath': filePath,
        'fileName': fileName,
        'fileType': fileType,
        'fileSize': fileSize,
        'createdAt': createdAt?.toIso8601String(),
      };
}

// --------- small helpers ---------
DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String && v.trim().isNotEmpty) return DateTime.parse(v);
  return null;
}

T? _mapIfPresent<T>(
  dynamic v,
  T Function(Map<String, dynamic>) build,
) {
  if (v is Map<String, dynamic>) return build(v);
  return null;
}
