import 'dart:ui';

import 'package:flutter/material.dart';

enum StatusPill { high, resolved }

enum RightStatus { inProgress, none }

extension RightStatusX on RightStatus {
  String get text => switch (this) {
    RightStatus.inProgress => 'In Progress',
    _ => '',
  };
  Color get color => switch (this) {
    RightStatus.inProgress => const Color(0xFF2F6BFF),
    _ => Colors.transparent,
  };
}

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
  final String footerTag;

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
