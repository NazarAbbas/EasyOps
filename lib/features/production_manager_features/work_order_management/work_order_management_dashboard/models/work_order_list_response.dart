// lib/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart
// Defensive JSON parsing for WorkOrder list

import 'dart:convert';
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

WorkOrderListResponse workOrderListResponseFromJson(String source) =>
    WorkOrderListResponse.fromJson(json.decode(source) as Map<String, dynamic>);

String workOrderListResponseToJson(WorkOrderListResponse data) =>
    json.encode(data.toJson());

class WorkOrderListResponse {
  final List<WorkOrders> content;
  final Page page;

  WorkOrderListResponse({
    required this.content,
    required this.page,
  });

  factory WorkOrderListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['content'];
    final list = (raw is List ? raw : const <dynamic>[]);
    return WorkOrderListResponse(
      content: list
          .map((e) => WorkOrders.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      page: Page.fromJson((json['page'] as Map).cast<String, dynamic>()),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };

  static WorkOrderListResponse fromJsonString(String source) =>
      WorkOrderListResponse.fromJson(
          json.decode(source) as Map<String, dynamic>);

  String toJsonString() => json.encode(toJson());
}

class WorkOrders {
  final String id;
  final String reportedTime;
  // final String type;
  final String issueNo;
  final String shiftId;
  final String shiftName;

  // Nullable in API -> nullable in model
  final String? plantId;
  final String? plantName;

  final String? issueTypeId;
  final String? issueTypeName;

  final String locationId;
  final String locationName;

  final String? impactId;
  final String? impactName;

  final String priority;
  final String status;
  final String title;
  final String description;

  final String? remark;
  final String? comment;

  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  final int recordStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int escalated;
  final String estimatedTimeToFix; // <-- non-nullable, defaults to "0" on parse

  final Tenant tenant;
  final Client client;
  final Asset asset;

  final Person? reportedBy;
  final Person? operator;
  final dynamic createdBy;
  final dynamic updatedBy;

  final List<MediaFile> mediaFiles;

  WorkOrders({
    required this.id,
    required this.reportedTime,
    required this.issueNo,
    //required this.type,
    required this.shiftId,
    required this.shiftName,
    required this.issueTypeId,
    required this.issueTypeName,
    required this.plantId,
    required this.plantName,
    required this.locationId,
    required this.locationName,
    required this.impactId,
    required this.impactName,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    required this.remark,
    required this.comment,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.escalated,
    required this.estimatedTimeToFix,
    required this.tenant,
    required this.client,
    required this.asset,
    required this.reportedBy,
    required this.operator,
    required this.createdBy,
    required this.updatedBy,
    required this.mediaFiles,
  });

  factory WorkOrders.fromJson(Map<String, dynamic> json) {
    List<dynamic> mf = [];
    final rawMf = json['mediaFiles'];
    if (rawMf is List) mf = rawMf;

    return WorkOrders(
      id: _string(json['id'])!, // non-nullable: throw if truly missing
      reportedTime: _string(json['reportedTime']) ?? '', // no
      issueNo: _string(json['issueNo']) ?? '', // no
      shiftId: _string(json['shiftId']) ?? '', // could be null
      shiftName: _string(json['shiftName']) ?? '',
      // type: _string(json['type'])!,
      plantId: _string(json['plantId']), // could be null
      plantName: _string(json['plantName']),
      issueTypeId: _string(json['issueTypeId']), // could be null
      issueTypeName: _string(json['issueTypeName']),
      locationId: _string(json['locationId']) ?? '',
      locationName: _string(json['locationName']) ?? '',
      impactId: _string(json['impactId']),
      impactName: _string(json['impactName']),
      priority: _string(json['priority']) ?? '',
      status: _string(json['status']) ?? '',
      title: _string(json['title']) ?? '',
      description: _string(json['description'])!,
      remark: _string(json['remark']),
      comment: _string(json['comment']),
      scheduledStart: _date(json['scheduledStart'] as String?) ??
          DateTime(1970, 1, 1).toUtc(),
      scheduledEnd: _date(json['scheduledEnd'] as String?) ??
          DateTime(1970, 1, 1).toUtc(),
      recordStatus: _int(json['recordStatus']) ?? 0,
      createdAt:
          _date(json['createdAt'] as String?) ?? DateTime(1970, 1, 1).toUtc(),
      updatedAt:
          _date(json['updatedAt'] as String?) ?? DateTime(1970, 1, 1).toUtc(),
      escalated: _int(json['escalated']) ?? 0,
      estimatedTimeToFix:
          _string(json['estimatedTimeToFix']) ?? '', // <-- default to "0"
      tenant: Tenant.fromJson((json['tenant'] as Map).cast<String, dynamic>()),
      client: Client.fromJson((json['client'] as Map).cast<String, dynamic>()),
      asset: Asset.fromJson((json['asset'] as Map).cast<String, dynamic>()),
      reportedBy: json['reportedBy'] != null
          ? Person.fromJson(json['reportedBy'])
          : null,
      operator:
          json['operator'] != null ? Person.fromJson(json['operator']) : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      mediaFiles: mf
          .map((e) => MediaFile.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reportedTime': reportedTime,
        'issueNo': issueNo,
        // 'type': type,
        'shiftId': shiftId,
        'shiftName': shiftName,
        'plantId': plantId,
        'plantName': plantName,
        'issueTypeId': issueTypeId,
        'issueTypeName': issueTypeName,
        'locationId': locationId,
        'locationName': locationName,
        'impactId': impactId,
        'impactName': impactName,
        'priority': priority,
        'status': status,
        'title': title,
        'description': description,
        'remark': remark,
        'comment': comment,
        'scheduledStart': scheduledStart.toIso8601String(),
        'scheduledEnd': scheduledEnd.toIso8601String(),
        'recordStatus': recordStatus,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'escalated': escalated,
        'estimatedTimeToFix': estimatedTimeToFix,
        'tenant': tenant.toJson(),
        'client': client.toJson(),
        'asset': asset.toJson(),
        'reportedBy': reportedBy?.toJson(),
        'operator': operator?.toJson(),
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'mediaFiles': mediaFiles.map((e) => e.toJson()).toList(),
      };
}

class Person {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? managerName;
  final String? managerContact;

  Person({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.managerName,
    this.managerContact,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json['id'] ?? '',
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phone: json['phone'],
        managerName: json['managerName'],
        managerContact: json['managerContact'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'managerContact': managerContact,
        'managerName': managerName,
      };
}

class Tenant {
  final String id;
  final String name;

  Tenant({required this.id, required this.name});

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
        id: _string(json['id'])!,
        name: _string(json['name'])!,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Client {
  final String id;
  final String name;

  Client({required this.id, required this.name});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: _string(json['id'])!,
        name: _string(json['name'])!,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Asset {
  final String id;
  final String name;
  final String assetNo;
  final String serialNumber;
  final String status;
  final String criticality;
  final String description;

  Asset({
    required this.id,
    required this.name,
    required this.assetNo,
    required this.serialNumber,
    required this.status,
    required this.criticality,
    required this.description,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: _string(json['id']) ?? '',
        name: _string(json['name']) ?? '',
        assetNo: _string(json['assetNo']) ?? '',
        serialNumber: _string(json['serialNumber']) ?? '',
        status: _string(json['status']) ?? '',
        criticality: _string(json['criticality']) ?? '',
        description: _string(json['description']) ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'assetNo': assetNo,
        'serialNumber': serialNumber,
        'status': status,
        'criticality': criticality,
        'description': description,
      };
}

class MediaFile {
  final String id;
  final String filePath;
  final String fileName;
  final String fileType;
  final int? fileSize;
  final DateTime createdAt;

  MediaFile({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    this.fileSize,
    required this.createdAt,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        id: _string(json['id'])!,
        filePath: _string(json['filePath'])!,
        fileName: _string(json['fileName'])!,
        fileType: _string(json['fileType'])!,
        fileSize: _int(json['fileSize']),
        createdAt: _date(json['createdAt'])!,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'filePath': filePath,
        'fileName': fileName,
        'fileType': fileType,
        'fileSize': fileSize,
        'createdAt': createdAt.toIso8601String(),
      };
}

class Page {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  Page({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        size: _int(json['size']) ?? 0,
        number: _int(json['number']) ?? 0,
        totalElements: _int(json['totalElements']) ?? 0,
        totalPages: _int(json['totalPages']) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}

/// Left colored pill on the card
enum Priority { high } // high == Critical

/// Right-side status text
enum Status { inProgress, resolved, open, none }

extension RightStatusX on Status {
  String get text => switch (this) {
        Status.inProgress => 'In Progress',
        Status.none => '',
        Status.resolved => 'Resolved',
        Status.open => 'Open',
      };

  Color get color => switch (this) {
        Status.inProgress => AppColors.primary,
        Status.none => Colors.transparent,
        Status.resolved => AppColors.successGreen,
        Status.open => AppColors.red,
      };
}

/// ===== Helpers =====

String? _string(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

int? _int(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

DateTime? _date(dynamic v) {
  final s = _string(v);
  if (s == null || s.isEmpty) return null;
  return DateTime.parse(s);
}

extension WorkOrderX on WorkOrders {
  int get timeLeftMinutes => int.tryParse(estimatedTimeToFix) ?? 0;

  String get timeLeftHm {
    final m = timeLeftMinutes;
    final h = m ~/ 60;
    final mm = m % 60;
    return '${h}h:${mm.toString().padLeft(2, '0')}m';
  }
}

extension WorkOrderY on WorkOrders {
  String get escalatedLabel => escalated > 0 ? 'Escalated' : 'No escalated';
}
