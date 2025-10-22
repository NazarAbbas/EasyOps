import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkOrderTile extends StatelessWidget {
  const WorkOrderTile({
    super.key,
    required this.workOrderInfo,
    this.onTap,
  });

  final WorkOrder workOrderInfo;
  final VoidCallback? onTap;

  // ── Hard-coded styles (no longer arguments) ────────────────────────────────
  static const double _elevation = 6;
  static const EdgeInsets _padding = EdgeInsets.all(16);
  static const double _borderRadius = 16;

  bool get _hasEta =>
      (workOrderInfo.estimatedTimeToFix ?? '').trim().isNotEmpty;
  bool get _hasDept => (workOrderInfo.type ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // background uses theme surface; not configurable from outside
    final bg = theme.colorScheme.surface;

    // "HH:mm | dd Mon" -> split for UI
    final timeDate = _formatDate(workOrderInfo.createdAt);
    final parts = timeDate.split('|');
    final time = parts.isNotEmpty ? parts[0].trim() : '';
    final date = parts.length > 1 ? parts[1].trim() : '';

    return Material(
      color: bg,
      elevation: _elevation,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: _padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Priority pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      workOrderInfo.title ?? '—',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PriorityPill(priority: (workOrderInfo.priority ?? '')),
                ],
              ),
              const SizedBox(height: 8),

              // Left meta (issue | time | date) + Right status
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _MutedText(workOrderInfo.issueNo ?? '—'),
                        if (time.isNotEmpty) ...[
                          const _Dot(),
                          _MutedText(time),
                        ],
                        if (date.isNotEmpty) ...[
                          const _Dot(),
                          _MutedText(date),
                        ],
                      ],
                    ),
                  ),
                  _StatusLink(text: (workOrderInfo.status ?? '')),
                ],
              ),
              const SizedBox(height: 8),

              // Department + ETA
              Row(
                children: [
                  if (_hasDept) _MutedText(workOrderInfo.type!),
                  const Spacer(),
                  if (_hasEta) ...[
                    const Icon(CupertinoIcons.time,
                        size: 16, color: _Colors.muted),
                    const SizedBox(width: 6),
                    _MutedText(workOrderInfo.estimatedTimeToFix!),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ======= Small, reusable bits ======= */

class _PriorityPill extends StatelessWidget {
  const _PriorityPill({required this.priority});
  final String priority;

  @override
  Widget build(BuildContext context) {
    final colors = _priorityColors(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.isEmpty ? '—' : priority,
        style: TextStyle(
          color: colors.fg,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusLink extends StatelessWidget {
  const _StatusLink({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '—' : text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: _Colors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _MutedText extends StatelessWidget {
  const _MutedText(this.text, {this.maxLines = 1});
  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '—' : text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: _Colors.muted,
        fontSize: 13.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) {
    return const Text(
      '│',
      style: TextStyle(color: Color(0xFFCBD2E0), fontSize: 12.5),
    );
  }
}

/* ======= Colors & helpers ======= */

class _Colors {
  static const muted = Color(0xFF7C8698);
  static const primary = Color(0xFF2F6BFF);
  static const danger = Color(0xFFED3B40);
  static const warning = Color(0xFFF59E0B);
  static const success = Color(0xFF10B981);
  static const pillBg = Color(0xFFEFF4FF);
}

class _PillColors {
  const _PillColors(this.bg, this.fg);
  final Color bg;
  final Color fg;
}

_PillColors _priorityColors(String raw) {
  final s = raw.trim().toLowerCase();
  if (s == 'high' || s == 'critical') {
    return const _PillColors(Color(0xFFFFE7E7), _Colors.danger);
  } else if (s == 'medium') {
    return const _PillColors(Color(0xFFFFF3DF), _Colors.warning);
  } else if (s == 'low') {
    return const _PillColors(Color(0xFFE9FBF4), _Colors.success);
  }
  return const _PillColors(_Colors.pillBg, _Colors.primary);
}

/// Returns "HH:mm | dd Mon"
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
