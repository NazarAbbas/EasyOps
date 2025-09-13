/* ───────────────────────── Page (Unified with Tabs) ───────────────────────── */
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/history/controller/update_history_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

/* ───────────────────────── Single Page (no tabs) ───────────────────────── */
class UpdateHistoryPage extends GetView<UpdateHistoryController> {
  const UpdateHistoryPage({super.key});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double hPad = isTablet ? 20 : 14;

    return Scaffold(
      backgroundColor: _kBg,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //     onPressed: Get.back,
      //   ),
      //   title: const Text('Assets'),
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      //   foregroundColor: Colors.white,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _HeaderCard(),
            // const SizedBox(height: 16),
            _MetricsRow(),
            const SizedBox(height: 10),
            const Divider(color: _kBorder, thickness: 1),
            const SizedBox(height: 10),
            //const _DashboardCharts(),
            // const SizedBox(height: 18),
            const _BreakdownChart(),
            // const _HistoryHeader(),
            const SizedBox(height: 10),
            const _StatsCard(),
            const SizedBox(height: 12),
            _HistoryList(isTablet: isTablet),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
          child: SizedBox(
            height: isTablet ? 56 : 52,
            width: double.infinity,
            child: Row(
              children: [
                // Expanded(
                //   child: OutlinedButton(
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: _kPrimary,
                //       side: const BorderSide(color: _kPrimary, width: 1.5),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     onPressed: controller.goBack,
                //     child: const Text(
                //       'Go Back',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w700,
                //         fontSize: 16,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.goBack,
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================== Dashboard parts ============================== */

class _HeaderCard extends GetView<UpdateHistoryController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final a = controller.asset.value;
      return InkWell(
        onTap: controller.onHeaderTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // ignore: deprecated_member_use
            border: Border.all(color: _kPrimary.withOpacity(.25), width: 1),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black12.withOpacity(.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // left
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: _kText,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          // we can’t do TextSpan variables in const; split dynamically:
                        ],
                      ),
                    ),
                    // Non-const version to include dynamic strings:
                    // We’ll overlay a Row to show code | make
                    Row(
                      children: [
                        Text(
                          a.code,
                          style: const TextStyle(
                            color: _kText,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          '  |  ',
                          style: TextStyle(
                            color: _kText,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          a.make,
                          style: const TextStyle(
                            color: _kText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.description,
                      style: const TextStyle(color: _kText, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: controller.onStatusTap,
                      child: const _StatusText(),
                    ),
                  ],
                ),
              ),
              const _CriticalPill(text: 'Critical'),
            ],
          ),
        ),
      );
    });
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UpdateHistoryController>();
    return Obx(
      () => Text(
        c.asset.value.status,
        style: const TextStyle(color: _kPrimary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MetricsRow extends GetView<UpdateHistoryController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kBorder),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            for (int i = 0; i < controller.metrics.length; i++) ...[
              Expanded(child: _MetricTile(item: controller.metrics[i])),
              if (i != controller.metrics.length - 1)
                Container(width: 1, height: 32, color: _kBorder),
            ],
          ],
        ),
      );
    });
  }
}

class _BreakdownChart extends GetView<UpdateHistoryController> {
  const _BreakdownChart({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => _BarChartCard(
            title: 'Breakdown  HRS',
            points: controller.breakdownHrs.toList(),
            minY: 0,
            maxY: 1000,
            redLineAt: 100,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => _BarChartCard(
            title: 'Spares Consumption  \$',
            points: controller.sparesConsumption.toList(),
            minY: -6000,
            maxY: 6000,
            redLineAt: 0,
            showSignedThousands: true,
          ),
        ),

        // 👇 NEW: Machine-wise Breakdown Hrs (0..20), with rotated labels and values on top
        const SizedBox(height: 16),
        Obx(
          () => _MachineBreakdownChart(
            title: 'Breakdown Hrs',
            points: controller.machineBreakdown.toList(),
            minY: 0,
            maxY: 20,
          ),
        ),
      ],
    );
  }
}

class _MachineBreakdownChart extends StatelessWidget {
  final String title;
  final List<ChartPoint> points;
  final double minY;
  final double maxY;

  const _MachineBreakdownChart({
    super.key,
    required this.title,
    required this.points,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    // Build bar groups & always-on tooltips (index 0 = first/only rod)
    final groups = <BarChartGroupData>[
      for (int i = 0; i < points.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: points[i].y,
              width: 12,
              borderRadius: BorderRadius.circular(3),
              color: _kPrimary,
            ),
          ],
          showingTooltipIndicators: const [0],
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BarChart(
              BarChartData(
                minY: minY,
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barGroups: groups,
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 2,
                    tooltipMargin: 0,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final v = rod.toY;
                      final label = v == v.roundToDouble()
                          ? v.toStringAsFixed(0)
                          : v.toStringAsFixed(1);
                      return BarTooltipItem(
                        label,
                        const TextStyle(color: Colors.black, fontSize: 10),
                      );
                    },
                  ),
                ),

                // draw horizontal grid like screenshot
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) =>
                      const FlLine(color: Color(0xFFE3E7EE), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      // render tooltips ourselves by layering? Instead, we used "always-on" tooltip above.
                      // Keep top titles blank.
                      getTitlesWidget: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 5, // 0,5,10,15,20
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= points.length) {
                          return const SizedBox.shrink();
                        }
                        return Transform.rotate(
                          angle: -math.pi / 2, // vertical
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              points[i].x,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Force tooltips visible by setting initial touch state
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    const label = TextStyle(
      color: Color(0xFF7C8698),
      fontWeight: FontWeight.w400,
    );
    const value = TextStyle(color: _kPrimary, fontWeight: FontWeight.w800);

    Widget cell(String l, String v) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: label.copyWith(fontSize: (label.fontSize ?? 14) - 1)),
        const SizedBox(height: 2),
        Text(v, style: value.copyWith(fontSize: (value.fontSize ?? 14) - 1)),
      ],
    );

    Widget pipe() => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '|',
        style: TextStyle(color: Color(0xFFE1E7F2), fontWeight: FontWeight.w800),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE9EEF6)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: cell('MTBF', '110 Days')),
              pipe(),
              Expanded(child: cell('BD Hours', '17 Hrs')),
              pipe(),
              Expanded(child: cell('MTTR', '2.4 Hrs')),
              pipe(),
              Expanded(child: cell('Criticality', 'Semi')),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE6EBF3)),
        ],
      ),
    );
  }
}

class _HistoryList extends GetView<UpdateHistoryController> {
  const _HistoryList({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.history;
      if (items.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No history yet',
              style: TextStyle(
                color: Color(0xFF7C8698),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 6),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          return _HistoryCard(item: item, isTablet: isTablet);
        },
      );
    });
  }
}

/* ============================== Reused widgets ============================== */

class _CriticalPill extends StatelessWidget {
  final String text;
  const _CriticalPill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFFF4D4F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final MetricItem item;
  const _MetricTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          ' ', // label below (keep layout tight)
          style: TextStyle(color: Color(0xFF7C8698), fontSize: 0),
        ),
        Text(
          item.label,
          style: const TextStyle(
            color: Color(0xFF7C8698),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.value,
          style: const TextStyle(
            color: _kPrimary,
            fontWeight: FontWeight.w800,
            decorationThickness: 2,
          ),
        ),
      ],
    );
  }
}

class _BarChartCard extends StatelessWidget {
  final String title;
  final List<ChartPoint> points;
  final double minY;
  final double maxY;
  final double redLineAt;
  final bool showSignedThousands;

  const _BarChartCard({
    required this.title,
    required this.points,
    required this.minY,
    required this.maxY,
    required this.redLineAt,
    this.showSignedThousands = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const blueBar = _kPrimary;
    const grid = Color(0xFFB0B7C3);
    const axis = Colors.black87;
    const redLine = Color(0xFFFF3B30);

    final bars = <BarChartGroupData>[
      for (int i = 0; i < points.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: points[i].y,
              width: 12,
              borderRadius: BorderRadius.circular(3),
              color: blueBar,
            ),
          ],
        ),
    ];

    String _fmt(double v) {
      if (!showSignedThousands) return v.toStringAsFixed(0);
      String s = v.abs() >= 1000
          ? '${(v.abs() / 1000).toStringAsFixed(0)},000'
          : v.toStringAsFixed(0);
      return v < 0 ? '-$s' : (v == 0 ? '0' : s);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 10,
            child: BarChart(
              BarChartData(
                minY: minY,
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barGroups: bars,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: grid, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= points.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            points[i].x,
                            style: const TextStyle(fontSize: 11, color: axis),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _chooseInterval(minY, maxY),
                      getTitlesWidget: (value, meta) {
                        final isNeg = value < 0;
                        return Text(
                          _fmt(value),
                          style: TextStyle(
                            fontSize: 11,
                            color: isNeg && showSignedThousands
                                ? const Color(0xFFD23B3B)
                                : axis,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                baselineY: null,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: redLineAt,
                      color: redLine,
                      strokeWidth: 1.8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _chooseInterval(double minY, double maxY) {
    final span = (maxY - minY).abs();
    if (span <= 1000) return 200; // for 0..1000
    if (span <= 12000) return 2000; // for -6k..6k
    return span / 5;
  }
}

class _HistoryCard extends StatelessWidget {
  final UpdateHistoryItem item;
  final bool isTablet;
  const _HistoryCard({required this.item, this.isTablet = false});

  Color _chipBg(BuildContext _) => const Color(0xFFEFFFFF);
  Color _chipText(BuildContext _) => _kText;

  @override
  Widget build(BuildContext context) {
    const textMuted = Color(0xFF7C8698);

    TextStyle muted([FontWeight w = FontWeight.w600]) => TextStyle(
      color: textMuted,
      fontWeight: w,
      fontSize: isTablet ? 13.5 : 12.5,
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9EEF6)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + chips
              Row(
                children: [
                  Text(item.date, style: muted(FontWeight.w700)),
                  const Spacer(),
                  _Chip(
                    text: item.category,
                    bg: _chipBg(context),
                    fg: _chipText(context),
                  ),
                  const SizedBox(width: 8),
                  _Chip(
                    text: item.type,
                    bg: _chipBg(context),
                    fg: _chipText(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                item.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _kText,
                  fontWeight: FontWeight.w800,
                  fontSize: isTablet ? 16 : 15,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),

              // Footer
              Row(
                children: [
                  const Icon(CupertinoIcons.person, size: 16, color: textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.person,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: muted(FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(CupertinoIcons.time, size: 16, color: textMuted),
                  const SizedBox(width: 6),
                  Text(item.duration, style: muted(FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Chip({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

/* ───────────────────────── Theme constants ───────────────────────── */
const _kPrimary = Color(0xFF2F6BFF);
const _kBorder = Color(0xFFE9EEF5);
const _kBg = Color(0xFFF7F9FC);
const _kText = Color(0xFF2D2F39);
