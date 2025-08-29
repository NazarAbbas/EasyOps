import 'package:easy_ops/ui/modules/work_order_management/dashboard/controller/work_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
// ^ adjust the import path to your controller

class CalendarCard extends GetView<WorkOrdersController> {
  const CalendarCard({super.key});

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double rowH = isTablet ? 40 : 34;
    final double dowH = isTablet ? 22 : 20;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // only as tall as the calendar
          children: [
            Obx(() {
              return TableCalendar<MarkerEvent>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: controller.focusedDay.value,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                shouldFillViewport: false,
                rowHeight: rowH,
                daysOfWeekHeight: dowH,

                // selection
                selectedDayPredicate: (d) =>
                    isSameDay(d, controller.selectedDay.value),
                onDaySelected: (sel, foc) {
                  controller.selectedDay.value = sel;
                  controller.focusedDay.value = foc;
                  Get.back(); // close after pick (optional)
                },
                onPageChanged: (foc) => controller.focusedDay.value = foc,

                // 🔗 your events
                eventLoader: controller.eventsFor,

                // header like the mock
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF345E9E),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xFF345E9E),
                  ),
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
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: const TextStyle(color: Color(0xFF2D2F39)),
                  weekendTextStyle: const TextStyle(color: Color(0xFF2D2F39)),
                  todayDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Color(0xFF2F6BFF),
                    fontWeight: FontWeight.w600,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFFE8F0FF),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Color(0xFF2F6BFF),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // colored dots under the date
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
          ],
        ),
      ),
    );
  }
}
