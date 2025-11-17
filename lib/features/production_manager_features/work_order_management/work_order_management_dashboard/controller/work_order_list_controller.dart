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
    everAll(
      [orders, query, selectedTab, dateFilterEnabled, selectedDay],
      (_) => _recomputeVisible(),
    );
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
    // start from full dataset
    List<WorkOrders> src = orders;

    // calendar date window (applied after query/tab logic below)
    DateTime? start;
    DateTime? end;
    if (dateFilterEnabled.value) {
      final d = selectedDay.value;
      start = _startOfDayLocal(d);
      end = _nextDayLocal(d);
    }

    // If there's a search query -> search across ALL orders (ignore selectedTab)
    final q = query.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      src = src.where((w) {
        // guard against null fields
        final issueNo = (w.issueNo ?? '').toLowerCase();
        final title = (w.title ?? '').toLowerCase();
        final desc = (w.description ?? '').toLowerCase();
        final assetName = (w.asset?.name ?? '').toLowerCase();
        final operatorName =
            ('${w.operator?.firstName ?? ''} ${w.operator?.lastName ?? ''}')
                .toLowerCase();
        final reportedBy =
            ('${w.reportedBy?.firstName ?? ''} ${w.reportedBy?.lastName ?? ''}')
                .toLowerCase();
        final priority = (w.priority ?? '').toLowerCase();
        final status = (w.status ?? '').toLowerCase();

        return issueNo.contains(q) ||
            title.contains(q) ||
            desc.contains(q) ||
            assetName.contains(q) ||
            operatorName.contains(q) ||
            reportedBy.contains(q) ||
            priority.contains(q) ||
            status.contains(q);
      }).toList();
    } else {
      // No query: apply selected tab filter as before
      switch (selectedTab.value) {
        case 0: // Today
          final now = DateTime.now();
          final startDay = DateTime(now.year, now.month, now.day);
          final endDay = startDay.add(const Duration(days: 1));
          src = src.where((w) {
            final t = w.createdAt.toLocal();
            return !t.isBefore(startDay) && t.isBefore(endDay);
          }).toList();
          break;
        case 1: // Open
          src = src
              .where((w) => (w.status ?? '').toLowerCase() == 'open')
              .toList();
          break;
        case 2: // Escalated
          src = src.where((w) => (w.escalated ?? 0) > 0).toList();
          break;
        case 3: // Critical
          src = src
              .where((w) => (w.priority ?? '').toLowerCase() == 'high')
              .toList();
          break;
        default:
          break;
      }
    }

    //  Apply calendar date window (if user picked a day) — this will further restrict
    //  results even when searching. Remove this block if search should ignore date.
    if (start != null && end != null) {
      src = src.where((w) {
        final t = w.createdAt.toLocal();
        return !t.isBefore(start!) && t.isBefore(end!);
      }).toList();
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
