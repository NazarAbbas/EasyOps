import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/domain/work_order_list_repository_impl.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart'
    show WorkOrder, Tenant, Client, Asset;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrdersController extends GetxController {
  final WorkOrderListRepositoryImpl repositoryImpl =
      WorkOrderListRepositoryImpl();

  // ---------------- UI state ----------------
  final loading = true.obs; // first-load spinner
  final isRefreshing = false.obs; // pull-to-refresh spinner
  final selectedDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  // Tabs / search
  final tabs = const ['Today', 'Open', 'Escalated', 'Critical'];
  final selectedTab = 0.obs;
  final query = ''.obs;

  // Data
  final orders = <WorkOrder>[].obs; // full dataset
  final visibleOrders = <WorkOrder>[].obs; // filtered for UI

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    // Recompute visible list whenever any of these change
    everAll([orders, query, selectedTab], (_) => _recomputeVisible());
    _loadInitial();
  }

  // ---------------- API / Initial Load ----------------
  Future<void> _loadInitial() async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));

    try {
      final res = await repositoryImpl.workOrderList();
      final list = res.data?.content ?? const <WorkOrder>[];
      orders.assignAll(list.isEmpty ? mockWorkOrders : list);
    } catch (e) {
      // Fallback to mock data on error
      orders.assignAll(mockWorkOrders);
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
      final list = res.data?.content ?? const <WorkOrder>[];
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
    List<WorkOrder> src = orders;

    // 1) Filter by tab
    switch (selectedTab.value) {
      case 0: // Today
        src = src.where((w) {
          final d = DateTime.now();
          return w.scheduledStart.year == d.year &&
              w.scheduledStart.month == d.month &&
              w.scheduledStart.day == d.day;
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

    // 2) Filter by search query (title)
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

  List<MarkerEvent> eventsFor(DateTime day) => eventMap[_d(day)] ?? [];
}

// Simple event marker for the calendar
class MarkerEvent {
  final Color color;
  final String tag;
  MarkerEvent(this.color, [this.tag = '']);
}

// ---------------- Mock data ----------------
final mockWorkOrders = <WorkOrder>[
  WorkOrder(
    id: 'WO-0001',
    type: 'Breakdown Management',
    plantId: 'PLANT-001',
    plantName: 'Main Plant',
    departmentId: 'DEPT-001',
    departmentName: 'Mechanical',
    impactId: null,
    impactName: null,
    priority: 'High',
    status: 'Open',
    title: 'Conveyor Belt Stopped Abruptly During Operation',
    description: 'The conveyor belt unexpectedly stopped during operation.',
    remark: 'Needs immediate attention',
    comment: null,
    scheduledStart: DateTime.parse('2025-08-09T18:08:00Z'),
    scheduledEnd: DateTime.parse('2025-08-09T21:28:00Z'),
    recordStatus: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    escalated: 1,
    timeLeft: '3h 20m',
    tenant: Tenant(id: 'TEN-001', name: 'Hawkeye'),
    client: Client(id: 'CLT-001', name: 'Kingfisher Airlines'),
    asset: Asset(
      id: 'AST-001',
      name: 'CNC - 1',
      serialNumber: 'SN-001',
      status: 'ACTIVE',
    ),
    reportedBy: null,
    createdBy: null,
    updatedBy: null,
    mediaFiles: const [],
  ),
  WorkOrder(
    id: 'WO-0002',
    type: 'Breakdown Management',
    plantId: 'PLANT-001',
    plantName: 'Main Plant',
    departmentId: 'DEPT-002',
    departmentName: 'Electrical',
    impactId: null,
    impactName: null,
    priority: 'High',
    status: 'Resolved',
    title:
        'Hydraulic Press Not Generating Adequate Force and Conveyor Belt Stopped Abruptly',
    description: 'Multiple machine issues observed in line CNC - 7.',
    remark: 'Fixed after diagnostics',
    comment: null,
    scheduledStart: DateTime.parse('2025-08-10T14:12:00Z'),
    scheduledEnd: DateTime.parse('2025-08-10T15:32:00Z'),
    recordStatus: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    escalated: 0,
    timeLeft: '1h 20m',
    tenant: Tenant(id: 'TEN-001', name: 'Hawkeye'),
    client: Client(id: 'CLT-001', name: 'Kingfisher Airlines'),
    asset: Asset(
      id: 'AST-002',
      name: 'CNC - 7',
      serialNumber: 'SN-002',
      status: 'ACTIVE',
    ),
    reportedBy: null,
    createdBy: null,
    updatedBy: null,
    mediaFiles: const [],
  ),
  WorkOrder(
    id: 'WO-0002',
    type: 'Breakdown Management',
    plantId: 'PLANT-001',
    plantName: 'Main Plant',
    departmentId: 'DEPT-002',
    departmentName: 'Electrical',
    impactId: null,
    impactName: null,
    priority: 'High',
    status: 'Inprogress',
    title:
        'Hydraulic Press Not Generating Adequate Force and Conveyor Belt Stopped Abruptly',
    description: 'Multiple machine issues observed in line CNC - 7.',
    remark: 'Fixed after diagnostics',
    comment: null,
    scheduledStart: DateTime.parse('2025-08-10T14:12:00Z'),
    scheduledEnd: DateTime.parse('2025-08-10T15:32:00Z'),
    recordStatus: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    escalated: 0,
    timeLeft: '1h 20m',
    tenant: Tenant(id: 'TEN-001', name: 'Hawkeye'),
    client: Client(id: 'CLT-001', name: 'Kingfisher Airlines'),
    asset: Asset(
      id: 'AST-002',
      name: 'CNC - 7',
      serialNumber: 'SN-002',
      status: 'ACTIVE',
    ),
    reportedBy: null,
    createdBy: null,
    updatedBy: null,
    mediaFiles: const [],
  ),
];
