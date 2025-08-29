import 'package:easy_ops/ui/modules/work_order_management/dashboard/models/work_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrdersController extends GetxController {
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;

  // Normalize to date-only (UTC to avoid TZ drift)
  DateTime _d(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  // Example markers; replace with your real data
  final Map<DateTime, List<MarkerEvent>> eventMap = {
    // red / yellow dots like your mock
    DateTime.utc(2025, 8, 25): [
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red),
    ],
    DateTime.utc(2025, 9, 6): [MarkerEvent(Colors.amber)],
    DateTime.utc(2025, 9, 10): [MarkerEvent(Colors.blue)], // maybe “today”
    DateTime.utc(2025, 9, 14): [
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red),
    ],
    DateTime.utc(2025, 9, 26): [
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red),
    ],
  };

  List<MarkerEvent> eventsFor(DateTime day) => eventMap[_d(day)] ?? [];

  final tabs = const ['Today', 'Open', 'Escalated', 'Critical'];
  final selectedTab = 0.obs;

  final query = ''.obs;

  final orders = <WorkOrder>[
    WorkOrder(
      title: 'Conveyor Belt Stopped Abruptly During Operation',
      code: 'BD-102',
      time: '18:08',
      date: '09 Aug',
      department: 'Mechanical',
      line: 'CNC - 1',
      statusPill: StatusPill.high,
      rightStatus: RightStatus.inProgress,
      duration: '3h 20m',
      footerTag: 'Escalated',
    ),
    WorkOrder(
      title: 'Hydraulic Press Not Generating Adequate Force',
      code: 'BD-102',
      time: '18:08',
      date: '09 Aug',
      department: 'Electrical',
      line: 'CNC - 7',
      statusPill: StatusPill.resolved,
      rightStatus: RightStatus.none,
      duration: '1h 20m',
      footerTag: '',
    ),
    WorkOrder(
      title: 'Unusual Grinding Noise from CNC Assets During Cutting',
      code: 'BD-102',
      time: '18:08',
      date: '09 Aug',
      department: 'Mechanical',
      line: 'CNC - 1',
      statusPill: StatusPill.high,
      rightStatus: RightStatus.inProgress,
      duration: '3h 20m',
      footerTag: 'Escalated',
    ),
  ].obs;
}

class MarkerEvent {
  final Color color;
  final String tag; // optional label
  MarkerEvent(this.color, [this.tag = '']);
}
