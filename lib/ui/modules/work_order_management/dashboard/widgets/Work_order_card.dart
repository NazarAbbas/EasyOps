import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/models/work_order.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrder order;
  const WorkOrderCard({super.key, required this.order});

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Responsive sizing
    final double radius = isTablet ? 14 : 10;
    final double pad = isTablet ? 16 : 12;
    final double titleSize = isTablet ? 18 : 16;
    final double metaSize = isTablet ? 13.5 : 12.5;
    final double labelSize = isTablet ? 14.5 : 13.5;
    final double iconSize = isTablet ? 16 : 14;

    // Colors
    const textPrimary = Color(0xFF1F2937);
    const textSecondary = Color(0xFF6B7280);
    const bullet = Color(0xFFBCC7D6);
    const borderSoft = Color(0xFFE9EEF5);

    final Color accent = _accentFor(order);

    return Card(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      clipBehavior: Clip.antiAlias, // ✅ ensure rounded corners clip children
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: borderSoft, width: 1), // ✅ soft outline
      ),
      child: Stack(
        children: [
          // ✅ Left accent stripe without decoration/constraints issues
          Positioned.fill(
            left: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(width: 3, color: accent),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // ✅ let content define height
              children: [
                // Title + pill
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
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Pill(order.statusPill),
                  ],
                ),

                const SizedBox(height: 6),

                // Code • time • date (Wrap avoids overflow on small screens)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    Text(order.code, style: _muted(metaSize, textSecondary)),
                    const Text('•', style: TextStyle(color: bullet)),
                    Text(order.time, style: _muted(metaSize, textSecondary)),
                    const Text('•', style: TextStyle(color: bullet)),
                    Text(order.date, style: _muted(metaSize, textSecondary)),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom: left (dept/line) | right (status/duration/tag)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.department,
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: labelSize,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_triangle_fill,
                                size: iconSize,
                                color: const Color(0xFFE25555),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  order.line,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: metaSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (order.rightStatus != RightStatus.none)
                          Text(
                            order.rightStatus.text,
                            style: TextStyle(
                              color: order.rightStatus.color,
                              fontWeight: FontWeight.w600,
                              fontSize: labelSize,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              size: iconSize,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              order.duration,
                              style: _muted(metaSize, textSecondary),
                            ),
                          ],
                        ),
                        if (order.footerTag.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            order.footerTag,
                            style: _muted(metaSize, textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _muted(double size, Color color) =>
      TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: size);

  Color _accentFor(WorkOrder o) {
    switch (o.statusPill) {
      case StatusPill.high:
        return const Color(0xFFFF5A5F); // coral red
      case StatusPill.resolved:
        return const Color(0xFF22C55E); // emerald
      // ignore: unreachable_switch_default
      default:
        return AppColors.primaryBlue; // brand blue fallback
    }
  }
}
