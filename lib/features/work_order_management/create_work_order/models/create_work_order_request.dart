// work_order_request.dart

class MediaFile {
  final String filePath;
  final String fileType;

  const MediaFile({
    required this.filePath,
    required this.fileType,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        filePath: (json['filePath'] ?? '').toString(),
        fileType: (json['fileType'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'fileType': fileType,
      };
}

class CreateWorkOrderRequest {
  final String type; // e.g. "Breakdown Management"
  final String priority; // e.g. "HIGH"
  final String status; // e.g. "OPEN"
  final String title;
  final String description;
  final String? remark;

  final DateTime scheduledStart; // parses "2025-02-01T07:00:00Z"
  final DateTime scheduledEnd;

  final String assetId; // "AST-456789"
  final String reportedById; // "USR-456789"
  final int plantId; // 1
  final int departmentId; // 2

  final List<MediaFile> mediaFiles;

  CreateWorkOrderRequest({
    required this.type,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    this.remark,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    required this.assetId,
    required this.reportedById,
    required this.plantId,
    required this.departmentId,
    this.mediaFiles = const [],
  })  : scheduledStart = scheduledStart.toUtc(),
        scheduledEnd = scheduledEnd.toUtc();

  factory CreateWorkOrderRequest.fromJson(Map<String, dynamic> json) =>
      CreateWorkOrderRequest(
        type: (json['type'] ?? '').toString(),
        priority: (json['priority'] ?? '').toString(),
        status: (json['status'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        remark: (json['remark'] as String?),
        scheduledStart: DateTime.parse(json['scheduledStart'].toString()),
        scheduledEnd: DateTime.parse(json['scheduledEnd'].toString()),
        assetId: (json['assetId'] ?? '').toString(),
        reportedById: (json['reportedById'] ?? '').toString(),
        plantId: json['plantId'] is int
            ? json['plantId'] as int
            : int.tryParse(json['plantId'].toString()) ?? 0,
        departmentId: json['departmentId'] is int
            ? json['departmentId'] as int
            : int.tryParse(json['departmentId'].toString()) ?? 0,
        mediaFiles: (json['mediaFiles'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(MediaFile.fromJson)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'priority': priority,
        'status': status,
        'title': title,
        'description': description,
        if (remark != null) 'remark': remark,
        'scheduledStart': scheduledStart.toIso8601String(),
        'scheduledEnd': scheduledEnd.toIso8601String(),
        'assetId': assetId,
        'reportedById': reportedById,
        'plantId': plantId,
        'departmentId': departmentId,
        'mediaFiles': mediaFiles.map((m) => m.toJson()).toList(),
      };
}
