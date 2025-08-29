import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/kv.dart'
    show KV;
import 'package:flutter/material.dart';

class KVBlock extends StatelessWidget {
  final List<KV> rows;

  /// Optional: override the label column width.
  final double? labelWidth;

  /// Space between label and value.
  final double gap;

  /// Make values selectable (copyable).
  final bool selectable;

  const KVBlock({
    super.key,
    required this.rows,
    this.labelWidth,
    this.gap = 6,
    this.selectable = false,
  });

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double lw = labelWidth ?? (isTablet ? 140 : 110);

    const labelStyle = TextStyle(
      color: Color(0xFF7C8698),
      fontWeight: FontWeight.w700,
    );
    const valueStyle = TextStyle(
      color: Color(0xFF2D2F39),
      fontWeight: FontWeight.w700,
    );

    return Column(
      children: [
        for (final e in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed width label column so values align nicely
                SizedBox(
                  width: lw,
                  child: Text(
                    e.label, // include ":" in label if you need it
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle,
                  ),
                ),
                SizedBox(width: gap),
                // Value expands and wraps as needed
                Expanded(
                  child: selectable
                      ? SelectableText(e.value, style: valueStyle)
                      : Text(e.value, style: valueStyle),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
