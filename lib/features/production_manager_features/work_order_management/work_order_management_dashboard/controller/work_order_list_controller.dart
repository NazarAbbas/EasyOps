import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/utils/share_preference.dart'
    show SharePreferences, engineerRole;
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart'
    show WorkOrders, Tenant, Client, Asset;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkOrdersController extends GetxController {
  var userRole = ''.obs;

  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  // ---------------- UI state ----------------
  final loading = true.obs; // first-load spinner
  final isRefreshing = false.obs; // pull-to-refresh spinner
  final selectedDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  static const Color _critical = Color(0xFFED3B40); // red
  static const Color _high = Color(0xFFF59E0B); // amber
  static const Color _open = Color(0xFF2F6BFF); // blue

  // whether the calendar date filter is active
  final dateFilterEnabled = false.obs;

  // Activate date filter from calendar
  void setSelectedCalendarDay(DateTime d) {
    selectedDay.value = d;
    focusedDay.value = d;
    dateFilterEnabled.value = true;
    _recomputeVisible();
  }

  // Optional: clear date filter (use Today/Open/Escalated/Critical logic only)
  void clearDateFilter() {
    dateFilterEnabled.value = false;
    _recomputeVisible();
  }

  String _tagFor(WorkOrders wo) {
    final pri =
        (wo.priority ?? '').toUpperCase().trim(); // e.g., 'CRITICAL','HIGH'
    if (pri == 'CRITICAL') return 'CRITICAL';
    if (pri == 'HIGH') return 'HIGH';

    final st = (wo.status ?? '').toUpperCase().trim(); // e.g., 'OPEN','PENDING'
    if (st == 'OPEN' || st == 'PENDING') return 'OPEN';

    return 'OPEN'; // default tag
  }

  Color _colorForTag(String tag) {
    switch (tag) {
      case 'CRITICAL':
        return _critical;
      case 'HIGH':
        return _high;
      default:
        return _open; // OPEN (and others)
    }
  }

  /// TableCalendar event loader (bind this to `eventLoader:`)
  /// You can either:
  ///   A) return one dot per WO (lots of dots), or
  ///   B) return at most one dot per tag for that day (cleaner).
  /// Below is (B): unique tags → max 3 dots (Critical, High, Open).
  List<MarkerEvent> eventsFor(DateTime day) {
    // choose which date field to anchor on
    Iterable<WorkOrders> todays = orders.where((wo) {
      final d = wo.scheduledStart ?? wo.createdAt;
      return d != null && isSameDay(d, day);
    });

    // dedupe by tag so you get at most one dot per status severity
    final byTag = <String, MarkerEvent>{};
    for (final wo in todays) {
      final tag = _tagFor(wo); // 'CRITICAL' | 'HIGH' | 'OPEN'
      byTag.putIfAbsent(tag, () => MarkerEvent(_colorForTag(tag), tag));
    }

    // Order: CRITICAL → HIGH → OPEN, then take top 4 if you like
    const order = ['CRITICAL', 'HIGH', 'OPEN'];
    final list = byTag.values.toList()
      ..sort((a, b) => order.indexOf(a.tag).compareTo(order.indexOf(b.tag)));

    return list; // markerBuilder will paint e.color
  }

  DateTime _startOfDayLocal(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _nextDayLocal(DateTime d) =>
      _startOfDayLocal(d).add(const Duration(days: 1));

  // Tabs / search
  final tabs = const ['Today', 'Open', 'Escalated', 'Critical'];
  final selectedTab = 0.obs;
  final query = ''.obs;

  // Data
  final orders = <WorkOrders>[].obs; // full dataset
  final visibleOrders = <WorkOrders>[].obs; // filtered for UI

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();

    // Recompute visible list whenever any of these change
    everAll([orders, query, selectedTab], (_) => _recomputeVisible());
    _loadInitial();
  }

  @override
  void onReady() async {
    super.onReady();
    await _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    // use typed helper + default (no cast!)
    userRole.value =
        await SharePreferences.get<String>(SharePreferences.userRole) as String;
  }

  // ---------------- API / Initial Load ----------------
  Future<void> _loadInitial() async {
    loading.value = true;
    //await Future.delayed(const Duration(milliseconds: 900));

    try {
      final res = await repositoryImpl.workOrderList();
      final list = res.data?.content ?? const <WorkOrders>[];
      orders.assignAll(list);
      //  orders.assignAll(mockWorkOrders);
    } catch (e) {
      String mess = e.toString();
      // Fallback to mock data on error
      //orders.assignAll(mockWorkOrders);
    }

    loading.value = false;
    _recomputeVisible();
  }

  /// Pull-to-refresh handler used by the UI (RefreshIndicator, etc).
  Future<void> refreshOrders() async {
    isRefreshing.value = true;
    await Future.delayed(const Duration(milliseconds: 900));

    try {
      final res = await repositoryImpl.workOrderList();
      final list = res.data?.content ?? const <WorkOrders>[];
      orders.assignAll(list);
    } catch (e) {
      // For demo: shuffle mock data to simulate change
      final shuffled = orders.toList()..shuffle();
      orders.assignAll(shuffled);
    }

    isRefreshing.value = false;
    _recomputeVisible();
  }

  // ---------------- Filters ----------------
  void setSelectedTab(int i) => selectedTab.value = i;
  void setQuery(String v) => query.value = v;

  void _recomputeVisible() {
    List<WorkOrders> src = orders;

    // 0) Calendar date window by createdAt -> applied if user picked a day
    DateTime? start;
    DateTime? end;
    if (dateFilterEnabled.value) {
      final d = selectedDay.value;
      start = _startOfDayLocal(d);
      end = _nextDayLocal(d);
    }

    // 1) Filter by tab
    switch (selectedTab.value) {
      case 0: // Today
        final now = DateTime.now();
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        src = src.where((w) {
          final t =
              w.createdAt.toLocal(); // "2025-10-12T11:15:32.075737Z" -> local
          return !t.isBefore(start) && t.isBefore(end);
        }).toList();
        break;
      case 1: // Open
        src = src.where((w) => w.status.toLowerCase() == 'open').toList();
        break;
      case 2: // Escalated
        src = src.where((w) => w.escalated > 0).toList();
        break;
      case 3: // Critical
        src = src.where((w) => w.priority.toLowerCase() == 'high').toList();
        break;
    }

// 2) Apply date window if we have one (either calendar-picked or Today)
    if (start != null && end != null) {
      src = src.where((w) {
        final t = w.createdAt.toLocal();
        return !t.isBefore(start!) && t.isBefore(end!);
      }).toList();
    }

    // 3) Filter by search query (title)
    final q = query.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      src = src.where((w) => w.title.toLowerCase().contains(q)).toList();
    }

    visibleOrders.assignAll(src);
  }

  // ---------------- Calendar helpers (TableCalendar) ----------------
  DateTime _d(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  final Map<DateTime, List<MarkerEvent>> eventMap = {
    DateTime.utc(2025, 8, 25): [
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red)
    ],
    DateTime.utc(2025, 9, 6): [MarkerEvent(Colors.amber)],
    DateTime.utc(2025, 9, 10): [MarkerEvent(Colors.blue)],
    DateTime.utc(2025, 9, 14): [
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red),
    ],
    DateTime.utc(2025, 9, 26): [
      MarkerEvent(Colors.red),
      MarkerEvent(Colors.red)
    ],
  };

  //List<MarkerEvent> eventsFor(DateTime day) => eventMap[_d(day)] ?? [];
}

// Simple event marker for the calendar
class MarkerEvent {
  final Color color;
  final String tag;
  MarkerEvent(this.color, [this.tag = '']);
}

// // ---------------- Mock data ----------------
// final mockWorkOrders = <WorkOrder>[
//   WorkOrder(
//     id: 'WO-0001',
//     type: 'Breakdown Management',
//     plantId: 'PLANT-001',
//     plantName: 'Main Plant',
//     departmentId: 'DEPT-001',
//     departmentName: 'Mechanical',
//     impactId: null,
//     impactName: null,
//     priority: 'High',
//     status: 'Open',
//     title: 'Conveyor Belt Stopped Abruptly During Operation',
//     description: 'The conveyor belt unexpectedly stopped during operation.',
//     remark: 'Needs immediate attention',
//     comment: null,
//     scheduledStart: DateTime.parse('2025-08-09T18:08:00Z'),
//     scheduledEnd: DateTime.parse('2025-08-09T21:28:00Z'),
//     recordStatus: 1,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     escalated: 1,
//     timeLeft: '3h 20m',
//     tenant: Tenant(id: 'TEN-001', name: 'Hawkeye'),
//     client: Client(id: 'CLT-001', name: 'Kingfisher Airlines'),
//     asset: Asset(
//       id: 'AST-001',
//       name: 'CNC - 1',
//       serialNumber: 'SN-001',
//       status: 'ACTIVE',
//     ),
//     reportedBy: null,
//     createdBy: null,
//     updatedBy: null,
//     mediaFiles: const [],
//   ),
//   WorkOrder(
//     id: 'WO-0002',
//     type: 'Breakdown Management',
//     plantId: 'PLANT-001',
//     plantName: 'Main Plant',
//     departmentId: 'DEPT-002',
//     departmentName: 'Electrical',
//     impactId: null,
//     impactName: null,
//     priority: 'High',
//     status: 'Resolved',
//     title:
//         'Hydraulic Press Not Generating Adequate Force and Conveyor Belt Stopped Abruptly',
//     description: 'Multiple machine issues observed in line CNC - 7.',
//     remark: 'Fixed after diagnostics',
//     comment: null,
//     scheduledStart: DateTime.parse('2025-08-10T14:12:00Z'),
//     scheduledEnd: DateTime.parse('2025-08-10T15:32:00Z'),
//     recordStatus: 1,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     escalated: 0,
//     timeLeft: '1h 20m',
//     tenant: Tenant(id: 'TEN-001', name: 'Hawkeye'),
//     client: Client(id: 'CLT-001', name: 'Kingfisher Airlines'),
//     asset: Asset(
//       id: 'AST-002',
//       name: 'CNC - 7',
//       serialNumber: 'SN-002',
//       status: 'ACTIVE',
//     ),
//     reportedBy: null,
//     createdBy: null,
//     updatedBy: null,
//     mediaFiles: const [],
//   ),
//   WorkOrder(
//     id: 'WO-0002',
//     type: 'Breakdown Management',
//     plantId: 'PLANT-001',
//     plantName: 'Main Plant',
//     departmentId: 'DEPT-002',
//     departmentName: 'Electrical',
//     impactId: null,
//     impactName: null,
//     priority: 'High',
//     status: 'Inprogress',
//     title:
//         'Hydraulic Press Not Generating Adequate Force and Conveyor Belt Stopped Abruptly',
//     description: 'Multiple machine issues observed in line CNC - 7.',
//     remark: 'Fixed after diagnostics',
//     comment: null,
//     scheduledStart: DateTime.parse('2025-08-10T14:12:00Z'),
//     scheduledEnd: DateTime.parse('2025-08-10T15:32:00Z'),
//     recordStatus: 1,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     escalated: 0,
//     timeLeft: '1h 20m',
//     tenant: Tenant(id: 'TEN-001', name: 'Hawkeye'),
//     client: Client(id: 'CLT-001', name: 'Kingfisher Airlines'),
//     asset: Asset(
//       id: 'AST-002',
//       name: 'CNC - 7',
//       serialNumber: 'SN-002',
//       status: 'ACTIVE',
//     ),
//     reportedBy: null,
//     createdBy: null,
//     updatedBy: null,
//     mediaFiles: const [],
//   ),
// ];
