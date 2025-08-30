import 'package:flutter/material.dart';

/// Left colored pill on the card
enum StatusPill { high, resolved } // high == Critical

/// Right-side status text
enum RightStatus { inProgress, none }

extension RightStatusX on RightStatus {
  String get text => switch (this) {
    RightStatus.inProgress => 'In Progress',
    RightStatus.none => '',
  };

  Color get color => switch (this) {
    RightStatus.inProgress => const Color(0xFF2F6BFF),
    RightStatus.none => Colors.transparent,
  };
}

/// UI tabs / filters you care about
enum WorkTab { today, open, escalated, critical }

class WorkOrder {
  final String title;
  final String code;
  final String time;
  final String date;
  final String department;
  final String line;
  final StatusPill statusPill;
  final RightStatus rightStatus;
  final String duration;
  final String footerTag; // e.g. 'Escalated'

  WorkOrder({
    required this.title,
    required this.code,
    required this.time,
    required this.date,
    required this.department,
    required this.line,
    required this.statusPill,
    required this.rightStatus,
    required this.duration,
    required this.footerTag,
  });
}

/// Convenience helpers for filtering
extension WorkOrderX on WorkOrder {
  bool get isInProgress => rightStatus == RightStatus.inProgress;

  /// Per spec: "today means none"
  bool get isToday => rightStatus == RightStatus.none;

  bool get isEscalated => footerTag.toLowerCase() == 'escalated';

  /// Critical maps to the left pill (StatusPill.high)
  bool get isCritical => statusPill == StatusPill.high;

  /// Matches a tab category
  bool matches(WorkTab tab) {
    switch (tab) {
      case WorkTab.today:
        return isToday;
      case WorkTab.open:
        return isInProgress;
      case WorkTab.escalated:
        return isEscalated;
      case WorkTab.critical:
        return isCritical;
    }
  }
}
