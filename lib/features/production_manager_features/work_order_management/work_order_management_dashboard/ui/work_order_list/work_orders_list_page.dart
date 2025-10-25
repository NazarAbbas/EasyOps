// ignore_for_file: deprecated_member_use

import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/controller/work_order_list_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart'
    show WorkOrders, Status, Priority;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkOrdersListPage extends GetView<WorkOrdersController> {
  const WorkOrdersListPage({super.key});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double headerH = isTablet ? 148 : 120;
    final double hPad = isTablet ? 16 : 12;
    final double btnH = isTablet ? 56 : 52;
    final double btnFs = isTablet ? 18 : 16;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(headerH),
        child: const _GradientHeader(),
      ),
      body: Column(
        children: [
          _Tabs(),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              // 1) First-load spinner driven by controller.loading
              if (controller.loading.value) {
                return const _InitialLoading();
              }

              // 2) Use controller.visibleOrders (already filtered by tab + query)
              final List<WorkOrders> data = controller.visibleOrders;

              if (data.isEmpty) {
                return _EmptyState(
                  onCreate: () => Get.toNamed(Routes.workOrderTabShellScreen),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshOrders,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 24),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _WorkOrderCard(order: data[i]),
                ),
              );
            }),
          ),
          // Show "Create Work Order" only for Production Manager
          Obx(() {
            final isPm = controller.userRole.value ==
                SharePreferences.productionManagerRole;
            return isPm
                ? SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 12),
                      child: SizedBox(
                        height: btnH,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Background: gradient + soft outline + shadow
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2F6BFF),
                                      Color(0xFF3F84FF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.18),
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x332F6BFF),
                                      blurRadius: 16,
                                      offset: Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: Color(0x1A000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Subtle gloss highlight
                            Positioned.fill(
                              child: IgnorePointer(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withOpacity(0.10),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Tap layer with ripple
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => Get.toNamed(
                                      Routes.workOrderTabShellScreen),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.add_circled_solid,
                                        color: Colors.white,
                                        size: btnFs + 4,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Create Work Order',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: btnFs,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
      // bottomNavigationBar: const BottomBar(currentIndex: 2),
    );
  }
}

/* ───────────────────────── Header ───────────────────────── */

class _GradientHeader extends GetView<WorkOrdersController>
    implements PreferredSizeWidget {
  const _GradientHeader();

  @override
  Size get preferredSize => const Size.fromHeight(120);

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;

    // compact, mobile-first spacing
    final slotW = isTablet ? 48.0 : 40.0; // fixed left/right slots
    final rowH = isTablet ? 44.0 : 36.0;
    final topPad = isTablet ? 12.0 : 8.0;
    final bottomPad = isTablet ? 12.0 : 10.0;
    final gapV = isTablet ? 10.0 : 8.0;

    final canPop = Navigator.of(context).canPop();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // white icons on blue
      child: Container(
        // Paint BLUE behind the status bar too
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, topPad, 16, bottomPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Equal-width left/right keeps title perfectly centered
                SizedBox(
                  height: rowH,
                  child: Row(
                    children: [
                      // SizedBox(
                      //   width: slotW,
                      //   height: rowH,
                      //   child: canPop
                      //       ? Material(
                      //           color: Colors.white.withOpacity(0.15),
                      //           shape: const CircleBorder(),
                      //           clipBehavior: Clip.antiAlias,
                      //           child: InkWell(
                      //             onTap: Get.back,
                      //             child: const Center(
                      //               child: Icon(
                      //                 CupertinoIcons.chevron_back,
                      //                 color: Colors.white,
                      //                 size: 20,
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       : const SizedBox.shrink(),
                      // ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Breakdown Management',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      // right placeholder mirrors left slot width
                      SizedBox(width: slotW, height: rowH),
                    ],
                  ),
                ),
                SizedBox(height: gapV),

                // Search + calendar
                Row(
                  children: [
                    Expanded(
                      child: _SearchField(onChanged: controller.setQuery),
                    ),
                    const SizedBox(width: 12),
                    _IconSquare(
                      onTap: () {
                        Get.dialog(
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 420,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 8,
                                    clipBehavior: Clip.antiAlias,
                                    child: const _CalendarCard(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.35),
                          useSafeArea: true,
                        );
                      },
                      bg: Colors.white.withOpacity(0.18),
                      outline: const Color(0x66FFFFFF),
                      child: const Icon(
                        CupertinoIcons.calendar,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── Calendar ───────────────────────── */

class _CalendarCard extends GetView<WorkOrdersController> {
  const _CalendarCard();

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double rowH = isTablet ? 40 : 34;
    final double dowH = isTablet ? 22 : 20;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      child: Obx(() {
        return TableCalendar<MarkerEvent>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2035, 12, 31),
          focusedDay: controller.focusedDay.value,
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          shouldFillViewport: false,
          sixWeekMonthsEnforced: false,
          rowHeight: rowH,
          daysOfWeekHeight: dowH,
          selectedDayPredicate: (d) =>
              isSameDay(d, controller.selectedDay.value),
          onDaySelected: (sel, foc) {
            controller.setSelectedCalendarDay(sel);
            Get.back();
          },
          onPageChanged: (foc) => controller.focusedDay.value = foc,
          eventLoader: controller.eventsFor,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF345E9E),
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF345E9E)),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Color(0xFF345E9E),
            ),
            headerMargin: EdgeInsets.only(bottom: 6),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Color(0xFF99A3B0),
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: Color(0xFF99A3B0),
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: TextStyle(color: Color(0xFF2D2F39)),
            weekendTextStyle: TextStyle(color: Color(0xFF2D2F39)),
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
            selectedDecoration: BoxDecoration(
              color: Color(0xFFE8F0FF),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          calendarBuilders: CalendarBuilders<MarkerEvent>(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(4).map((e) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 4.2,
                        height: 4.2,
                        decoration: BoxDecoration(
                          color: e.color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

/* ───────────────────────── List items ───────────────────────── */

class _WorkOrderCard extends StatefulWidget {
  final WorkOrders order;
  const _WorkOrderCard({required this.order});

  @override
  State<_WorkOrderCard> createState() => _WorkOrderCardState();
}

class _WorkOrderCardState extends State<_WorkOrderCard> {
  bool _pressed = false;

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final isTablet = _isTablet(context);

    // Sizing
    final double radius = isTablet ? 16 : 12;
    final double pad = isTablet ? 16 : 14;
    final double titleSize = isTablet ? 16 : 14;
    final double metaSize = isTablet ? 13.5 : 12.5;
    final double labelSize = isTablet ? 14.5 : 13.5;

    // Colors
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF6B7280);
    const borderSoft = Color(0xFFE9EEF5);

    //final statusBg = _statusColorSoft(order.status);
    //final statusFg = _statusTextColor(order.status);

    final statusBg = _statusColorSoft(order.status);
    final statusFg =
        _statusTextColor(order.status); // <- single source of truth

    final accent = statusFg;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..translate(0.0, _pressed ? 1.0 : 0.0)
        ..scale(_pressed ? 0.9975 : 1.0),
      child: Material(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: _pressed ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: borderSoft, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: () async {
            final userRole =
                await SharePreferences.get<String>(SharePreferences.userRole)
                    as String;
            // final status = (order.status).toUpperCase();
            // if (userRole == SharePreferences.engineerRole) {
            //   if (status == "OPEN") {
            //     Get.toNamed(
            //       Routes.maintenanceEngeneerupdateWorkOrderTabScreen,
            //       arguments: {
            //         Constant.workOrderInfo: order,
            //         Constant.workOrderStatus: WorkOrderStatus.open,
            //       },
            //     );
            //   }
            //   if (status == "INPROGRESS") {
            //     Get.toNamed(
            //       Routes.maintenanceEngeneerstartWorkOrderScreen,
            //       arguments: {
            //         Constant.workOrderInfo: order,
            //         Constant.workOrderStatus: WorkOrderStatus.open,
            //       },
            //     );
            //   }
            // } else {
            //   if (status == "RESOLVED") {
            //     Get.toNamed(
            //       Routes.updateWorkOrderTabScreen,
            //       arguments: {
            //         Constant.workOrderInfo: order,
            //         Constant.workOrderStatus: WorkOrderStatus.resolved,
            //       },
            //     );
            //   }
            //   if (status == "OPEN") {
            //     Get.toNamed(
            //       Routes.workOrderTabShellScreen,
            //       arguments: {
            //         Constant.workOrderInfo: order,
            //         Constant.workOrderStatus: WorkOrderStatus.open,
            //       },
            //     );
            //   }
            // }

            Get.toNamed(
              Routes.maintenanceEngeneerstartWorkOrderScreen,
              arguments: {
                Constant.workOrderInfo: order,
                Constant.workOrderStatus: WorkOrderStatus.open,
              },
            );

            // Get.toNamed(
            //   Routes.maintenanceEngeneerstartWorkOrderScreen,
            //   arguments: {
            //     Constant.workOrderInfo: order,
            //     Constant.workOrderStatus: WorkOrderStatus.open,
            //   },
            // );

            // Get.toNamed(
            //   Routes.maintenanceEngeneerupdateWorkOrderTabScreen,
            //   arguments: {
            //     Constant.workOrderInfo: order,
            //     Constant.workOrderStatus: WorkOrderStatus.open,
            //   },
            // );

            // Get.toNamed(
            //   Routes.updateWorkOrderTabScreen,
            //   arguments: {
            //     Constant.workOrderInfo: order,
            //     Constant.workOrderStatus: WorkOrderStatus.resolved,
            //   },
            // );
            // Get.toNamed(
            //   Routes.workOrderTabShellScreen,
            //   arguments: {
            //     Constant.workOrderInfo: order,
            //     Constant.workOrderStatus: WorkOrderStatus.open,
            //   },
            // );

            // final s = (order.status).toUpperCase();
            // if (s == 'RESOLVED') {
            //   //if (s == 'OPEN') {
            //   Get.toNamed(
            //     Routes.updateWorkOrderTabScreen,
            //     arguments: {
            //       Constant.workOrderInfo: order,
            //       Constant.workOrderStatus: WorkOrderStatus.resolved,
            //     },
            //   );
            // } else if (s == 'OPEN') {
            //   if (userRole == SharePreferences.engineerRole) {
            //     Get.toNamed(
            //       Routes.maintenanceEngeneerupdateWorkOrderTabScreen,
            //       arguments: {
            //         Constant.workOrderInfo: order,
            //         Constant.workOrderStatus: WorkOrderStatus.open,
            //       },
            //     );
            //   } else {
            //     Get.toNamed(
            //       Routes.workOrderTabShellScreen,
            //       arguments: {
            //         Constant.workOrderInfo: order,
            //         Constant.workOrderStatus: WorkOrderStatus.open,
            //       },
            //     );
            //   }
            // } else {
            //   Get.toNamed(Routes.workOrderDetailScreen, arguments: order);
            // }
          },
          child: Stack(
            children: [
              // Accent stripe with gradient
              // Accent stripe (currently using status color)
              // 1) right above the Stack, derive the color from priority

// 2) in the Stack, replace the stripe with priorityColor
              Positioned.fill(
                left: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _priorityCfg(order.priority).color,
                          _priorityCfg(order.priority).color,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.fromLTRB(pad + 4, pad, pad, pad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Title + priority chip
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            order.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _StatusPill(pill: order.priority),
                      ],
                    ),

                    const SizedBox(height: 10),

// Meta stack (code, date, right status)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // left: code + date
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MetaChip(
                                  icon: CupertinoIcons.number,
                                  label: order.issueNo),
                              const SizedBox(width: 8),
                              _MetaChip(
                                  icon: null,
                                  label: _formatDate(order.createdAt)),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Text(
                            (order.status).toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: labelSize,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: borderSoft),
                    const SizedBox(height: 12),

                    // Bottom info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Department
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.square_grid_2x2_fill,
                                    size: 14,
                                    color: textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      order.type,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: labelSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Asset
                              Row(
                                children: [
                                  if ((order.criticality ?? '').toLowerCase() ==
                                      'high')
                                    const Icon(
                                      CupertinoIcons
                                          .exclamationmark_triangle_fill,
                                      size: 14,
                                      color: Color(0xFFE25555),
                                    ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      order.asset.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textSecondary,
                                        fontSize: metaSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // RIGHT
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (order.estimatedTimeToFix != null &&
                                order.estimatedTimeToFix != '')
                              _MetaChip(
                                icon: CupertinoIcons.clock,
                                label: order.estimatedTimeToFix ?? '—',
                                dense: true,
                              ),
                            const SizedBox(height: 10),
                            if (order.escalated > 0)
                              _MetaChip(
                                  icon: CupertinoIcons.flag_fill,
                                  label: 'Escalated',
                                  dense: true)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isNone(String? s) {
  if (s == null) return true;
  final v = s.trim().toUpperCase();
  return v.isEmpty || v == 'NONE';
}

Color? _statusColor(String? s) {
  final v = (s ?? '').trim().toUpperCase();
  switch (v) {
    case 'IN_PROGRESS':
      return AppColors.primary;
    case 'RESOLVED':
      return AppColors.successGreen;
    case 'OPEN':
      return AppColors.red;
    default:
      return null; // fallback to default text color
  }
}

String _formatDate(DateTime dt) {
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final day = dt.day.toString().padLeft(2, '0');
  final month = months[dt.month - 1];

  return '$hh:$mm | $day $month';
}

// String _formatDate(DateTime date) {
//   return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
// }
/* ============================ Bits ============================ */

class _MetaChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool dense;

  const _MetaChip({this.icon, required this.label, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final padH = dense ? 8.0 : 10.0;
    final padV = dense ? 4.0 : 6.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF6F8FC), Color(0xFFF2F5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6ECF5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: dense ? 12 : 14, color: const Color(0xFF7C8698)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w800,
                fontSize: dense ? 11.5 : 12.5,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String pill;
  final double fontSize;
  final bool uppercase;
  final bool showDot;

  const _StatusPill({
    required this.pill,
    this.fontSize = 12.5,
    this.uppercase = true,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = _priorityCfg(pill);
    final label = uppercase ? cfg.label.toUpperCase() : cfg.label;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cfg.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              _Dot(color: Colors.white, size: fontSize * 0.5),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: fontSize,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, this.size = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/* ───────────────────────── Top Tabs ───────────────────────── */

class _Tabs extends GetView<WorkOrdersController> {
  const _Tabs();

  @override
  WorkOrdersController get controller => Get.find<WorkOrdersController>();

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double tabH = isTablet ? 28 : 18;
    final double fs = isTablet ? 15 : 13.5;
    final double uThick = isTablet ? 3.5 : 3;
    final double uSide = isTablet ? 12 : 10;
    final double uGap = isTablet ? 8 : 6;
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;
    return Container(
      color: primary,
      padding: const EdgeInsets.only(bottom: 10),
      child: LayoutBuilder(
        builder: (context, c) {
          final count = controller.tabs.length;
          final segW = c.maxWidth / count;

          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: uGap + uThick),
                child: Row(
                  children: List.generate(count, (i) {
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.setSelectedTab(i), // <- setter
                        child: SizedBox(
                          height: tabH,
                          child: Center(
                            child: Obx(() {
                              final active = controller.selectedTab.value == i;
                              return Text(
                                controller.tabs[i],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fs,
                                  fontWeight: active
                                      ? FontWeight.w900
                                      : FontWeight.w500,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Obx(() {
                final left = uSide + controller.selectedTab.value * segW;
                final width = segW - uSide * 2;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  left: left,
                  bottom: 0,
                  width: width,
                  height: uThick,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

/* ───────────────────────── Reusable bits ───────────────────────── */
class _InitialLoading extends StatefulWidget {
  const _InitialLoading();

  @override
  State<_InitialLoading> createState() => _InitialLoadingState();
}

class _InitialLoadingState extends State<_InitialLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const base = Color(0xFFEFF3FA);
    const highlight = Color(0xFFF7F9FD);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 6,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            return Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE9EEF5)),
                gradient: LinearGradient(
                  begin: Alignment(-1.0 + 2.0 * _c.value, -0.2),
                  end: Alignment(1.0 + 2.0 * _c.value, 0.2),
                  colors: const [base, highlight, base],
                  stops: const [0.20, 0.50, 0.80],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color _statusColorSoft(String? s) {
  switch ((s ?? '').trim().toUpperCase()) {
    case 'OPEN':
      return const Color(0xFFFFE4E4);
    case 'IN_PROGRESS':
      return const Color(0xFFFFF3CD);
    case 'RESOLVED':
      return const Color(0xFFEAF7EE);
    case 'CANCEL':
      return const Color(0xFFEDEEF2);
    default:
      return const Color(0xFFEDEEF2);
  }
}

Color _statusTextColor(String? s) {
  switch ((s ?? '').trim().toUpperCase()) {
    case 'OPEN':
      return AppColors.red;
    case 'IN_PROGRESS':
      return const Color(0xFF8A6D3B);
    case 'RESOLVED':
      return AppColors.successGreen;
    case 'CANCEL':
      return const Color(0xFF6B7280);
    default:
      return const Color(0xFF374151);
  }
}

({String label, Color color}) _priorityCfg(String p) {
  switch (p.trim().toUpperCase()) {
    case 'HIGH':
      // light red
      return (
        label: 'HIGH',
        color: const Color.fromARGB(255, 243, 59, 74)
      ); // rose-100
    case 'MEDIUM':
      // light amber
      return (
        label: 'MED',
        color: const Color.fromARGB(255, 211, 173, 22)
      ); // amber-100
    case 'LOW':
      // light green (replaces blue)
      return (
        label: 'LOW',
        color: const Color.fromARGB(255, 9, 168, 62)
      ); // emerald-100
    default:
      // light slate/neutral
      return (
        label: p.toUpperCase(),
        color: const Color(0xFFE2E8F0)
      ); // slate-200
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const _SearchField({this.onChanged});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    final double h = isTablet ? 52 : 44;
    final double r = isTablet ? 12 : 10;
    final double pad = isTablet ? 16 : 12;
    final double fs = isTablet ? 16 : 14;
    final double icon = isTablet ? 20 : 18;

    return Container(
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: Colors.white, fontSize: fs),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search Work Orders',
          hintStyle: TextStyle(color: Colors.white70, fontSize: fs),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: pad, vertical: 10),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              CupertinoIcons.search,
              color: Colors.white70,
              size: icon,
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: h,
            minWidth: isTablet ? 48 : 40,
          ),
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? bg;
  final Color? outline;
  const _IconSquare({
    required this.child,
    required this.onTap,
    this.bg,
    this.outline,
  });

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double size = isTablet ? 52 : 44;
    final double radius = isTablet ? 10 : 8;

    return Material(
      color: bg ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: outline ?? const Color(0xFFDFE5F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.doc_on_clipboard,
              size: 48,
              color: Color(0xFFB7C1D6),
            ),
            const SizedBox(height: 12),
            const Text(
              'No work orders found',
              style: TextStyle(
                color: Color(0xFF2D2F39),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int currentIndex;
  const BottomBar({super.key, required this.currentIndex});

  static const Color _blue = AppColors.primaryBlue;
  static const Color _grey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: _blue.withOpacity(0.10),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? _blue : _grey);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? _blue : _grey,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w500,
          );
        }),
      ),
      child: NavigationBar(
        height: 70,
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.cube_box),
            label: 'Assets',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.doc_on_clipboard),
            label: 'Work Orders',
          ),
        ],
        onDestinationSelected: (i) {
          if (i == currentIndex) return;
          switch (i) {
            case 0:
              Get.offAllNamed(Routes.homeDashboardScreen);
              break;
            case 1:
              Get.offAllNamed(Routes.assetsManagementDashboardScreen);
              break;
            case 2:
              Get.offAllNamed(Routes.workOrderScreen);
              break;
          }
        },
      ),
    );
  }
}
