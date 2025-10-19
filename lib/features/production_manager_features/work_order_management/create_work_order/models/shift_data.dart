import 'dart:convert';
import 'package:flutter/material.dart';

/// Top-level wrapper
class ShiftData {
  final List<Shift> content;
  final ShiftMeta page;

  const ShiftData({
    required this.content,
    required this.page,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    return ShiftData(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => Shift.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: ShiftMeta.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content.map((e) => e.toJson()).toList(),
        'page': page.toJson(),
      };

  /// Convenience
  static ShiftData fromJsonString(String s) =>
      ShiftData.fromJson(json.decode(s) as Map<String, dynamic>);
  String toJsonString() => json.encode(toJson());
}

/// Single shift row
class Shift {
  final String id;
  final String name;
  final String description;

  /// Stored as "HH:mm:ss" from API
  final String startTime;

  /// Stored as "HH:mm:ss" from API
  final String endTime;
  final int recordStatus;
  final DateTime updatedAt;
  final String tenantId;
  final String clientId;

  const Shift({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.recordStatus,
    required this.updatedAt,
    required this.tenantId,
    required this.clientId,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      recordStatus: (json['recordStatus'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tenantId: json['tenantId'] as String,
      clientId: json['clientId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'startTime': startTime,
        'endTime': endTime,
        'recordStatus': recordStatus,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        'tenantId': tenantId,
        'clientId': clientId,
      };

  Shift copyWith({
    String? id,
    String? name,
    String? description,
    String? startTime,
    String? endTime,
    int? recordStatus,
    DateTime? updatedAt,
    String? tenantId,
    String? clientId,
  }) {
    return Shift(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      recordStatus: recordStatus ?? this.recordStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      tenantId: tenantId ?? this.tenantId,
      clientId: clientId ?? this.clientId,
    );
  }

  // -------- Helpers --------

  /// Parse "HH:mm:ss" -> TimeOfDay (24h). Returns null if invalid.
  TimeOfDay? get startAsTimeOfDay => _parseHms(startTime);
  TimeOfDay? get endAsTimeOfDay => _parseHms(endTime);

  /// True if the shift crosses midnight (e.g., 22:00:00 -> 06:00:00).
  bool get crossesMidnight {
    final s = _parseSeconds(startTime);
    final e = _parseSeconds(endTime);
    if (s == null || e == null) return false;
    return e <= s; // end earlier or equal means next day
    // (Equal endTime like 23:59:59 considered same-day long shift)
  }

  static TimeOfDay? _parseHms(String v) {
    final parts = v.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  static int? _parseSeconds(String v) {
    final parts = v.split(':');
    if (parts.length != 3) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final s = int.tryParse(parts[2]);
    if (h == null || m == null || s == null) return null;
    return h * 3600 + m * 60 + s;
  }
}

/// Pagination metadata
class ShiftMeta {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  const ShiftMeta({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory ShiftMeta.fromJson(Map<String, dynamic> json) => ShiftMeta(
        size: (json['size'] as num).toInt(),
        number: (json['number'] as num).toInt(),
        totalElements: (json['totalElements'] as num).toInt(),
        totalPages: (json['totalPages'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'number': number,
        'totalElements': totalElements,
        'totalPages': totalPages,
      };
}
