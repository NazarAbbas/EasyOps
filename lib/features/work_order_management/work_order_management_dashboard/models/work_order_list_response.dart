// lib/features/work_order_management/models/work_orders_response.dart
import 'dart:convert';
import 'dart:ui';

import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WorkOrderListResponse {
  final List<WorkOrder> content;
  final Page page;

  WorkOrderListResponse({
    required this.content,
    required this.page,
  });

  factory WorkOrderListResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderListResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => WorkOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: Page.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((e) => e.toJson()).toList(),
      'page': page.toJson(),
    };
  }

  static WorkOrderListResponse fromJsonString(String source) =>
      WorkOrderListResponse.fromJson(
          json.decode(source) as Map<String, dynamic>);

  String toJsonString() => json.encode(toJson());
}

class WorkOrder {
  final String id;
  final String type;
  final String plantId;
  final String plantName;
  final String departmentId;
  final String departmentName;
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
  final String? timeLeft;
  final Tenant tenant;
  final Client client;
  final Asset asset;
  final dynamic reportedBy;
  final dynamic createdBy;
  final dynamic updatedBy;
  final List<MediaFile> mediaFiles;

  WorkOrder({
    required this.id,
    required this.type,
    required this.plantId,
    required this.plantName,
    required this.departmentId,
    required this.departmentName,
    this.impactId,
    this.impactName,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    this.remark,
    this.comment,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.recordStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.escalated,
    this.timeLeft,
    required this.tenant,
    required this.client,
    required this.asset,
    this.reportedBy,
    this.createdBy,
    this.updatedBy,
    required this.mediaFiles,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      id: json['id'] as String,
      type: json['type'] as String,
      plantId: json['plantId'] as String,
      plantName: json['plantName'] as String,
      departmentId: json['departmentId'] as String,
      departmentName: json['departmentName'] as String,
      impactId: json['impactId'] as String?,
      impactName: json['impactName'] as String?,
      priority: json['priority'] as String,
      status: json['status'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      remark: json['remark'] as String?,
      comment: json['comment'] as String?,
      scheduledStart: DateTime.parse(json['scheduledStart'] as String),
      scheduledEnd: DateTime.parse(json['scheduledEnd'] as String),
      recordStatus: json['recordStatus'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      escalated: json['escalated'] as int,
      timeLeft: json['timeLeft'] as String?,
      tenant: Tenant.fromJson(json['tenant'] as Map<String, dynamic>),
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      asset: Asset.fromJson(json['asset'] as Map<String, dynamic>),
      reportedBy: json['reportedBy'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      mediaFiles: (json['mediaFiles'] as List<dynamic>)
          .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'plantId': plantId,
      'plantName': plantName,
      'departmentId': departmentId,
      'departmentName': departmentName,
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
      'timeLeft': timeLeft,
      'tenant': tenant.toJson(),
      'client': client.toJson(),
      'asset': asset.toJson(),
      'reportedBy': reportedBy,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'mediaFiles': mediaFiles.map((e) => e.toJson()).toList(),
    };
  }
}

class Tenant {
  final String id;
  final String name;

  Tenant({
    required this.id,
    required this.name,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Client {
  final String id;
  final String name;

  Client({
    required this.id,
    required this.name,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Asset {
  final String id;
  final String name;
  final String serialNumber;
  final String status;

  Asset({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      serialNumber: json['serialNumber'] as String,
      status: json['status'] as String,
    );
  }

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
  final DateTime createdAt;

  MediaFile({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    this.fileSize,
    required this.createdAt,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
    };
  }
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

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      size: json['size'] as int,
      number: json['number'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'number': number,
      'totalElements': totalElements,
      'totalPages': totalPages,
    };
  }
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
