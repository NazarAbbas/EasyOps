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

// ===== Utils on your existing Shift model =====

extension ShiftTimeOps on Shift {
  /// "HH:mm:ss" -> seconds since midnight (0..86399). Null if bad.
  int? get _startSec => _toSec(startTime);
  int? get _endSec => _toSec(endTime);

  bool get crossesMidnight {
    final s = _startSec, e = _endSec;
    if (s == null || e == null) return false;
    return e <= s; // e==s means full-day or zero-length; treat as wrap
  }

  /// Does [tSec] (seconds since midnight, local) fall inside this shift?
  bool containsSecond(int tSec) {
    final s = _startSec, e = _endSec;
    if (s == null || e == null) return false;

    if (!crossesMidnight) {
      // Normal case: s < e, interval [s, e)
      return tSec >= s && tSec < e;
    } else {
      // Wraps midnight: [s, 86400) ∪ [0, e)
      return tSec >= s || tSec < e;
    }
  }

  /// "HH:mm:ss" -> seconds since midnight
  static int? _toSec(String v) {
    final p = v.split(':');
    if (p.length != 3) return null;
    final h = int.tryParse(p[0]),
        m = int.tryParse(p[1]),
        s = int.tryParse(p[2]);
    if (h == null || m == null || s == null) return null;
    return (h * 3600) + (m * 60) + s;
  }
}

/// Convert a local DateTime to seconds since local midnight (0..86399)
int _localSecondsSinceMidnight(DateTime dt) {
  final local = dt.toLocal();
  return local.hour * 3600 + local.minute * 60 + local.second;
}

/// Pick the shift active at `at` (local). Returns null if none match.
Shift? selectShiftFor(List<Shift> shifts, {DateTime? at}) {
  final now = at ?? DateTime.now();
  final tSec = _localSecondsSinceMidnight(now);

  // Filter only those that contain the current second.
  final matches = shifts.where((s) => s.containsSecond(tSec)).toList();
  if (matches.isEmpty) return null;

  // If multiple match (rare, but e.g., a full-day shift plus another),
  // prefer the *shortest* window (most specific).
  matches.sort((a, b) {
    int lenA = _lengthSec(a);
    int lenB = _lengthSec(b);
    return lenA.compareTo(lenB);
  });
  return matches.first;
}

/// Duration of a shift in seconds (handles midnight-crossing).
int _lengthSec(Shift s) {
  final st = s._startSec, en = s._endSec;
  if (st == null || en == null) return 86400; // treat invalid as full day
  return s.crossesMidnight ? (86400 - st + en) : (en - st);
}

/// Optional: next shift start after `at` (helpful if nothing active).
Shift? nextShiftAfter(List<Shift> shifts, {DateTime? after}) {
  final base = after ?? DateTime.now();
  final sec = _localSecondsSinceMidnight(base);

  Shift? best;
  int bestDelta = 1 << 30;

  for (final s in shifts) {
    final st = s._startSec;
    if (st == null) continue;
    // delta forward in circular day space
    final delta = (st - sec + 86400) % 86400;
    if (delta > 0 && delta < bestDelta) {
      bestDelta = delta;
      best = s;
    }
  }
  return best;
}
