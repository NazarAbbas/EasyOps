import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/mc_history/models/history_items.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/mc_history/widgets/chip.dart'
    show Chip;
import 'package:flutter/cupertino.dart';

class HistoryCard extends StatelessWidget {
  final HistoryItem item;
  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFFF4F7FB);
    const textPrimary = Color(0xFF2D2F39);
    const textMuted = Color(0xFF7C8698);

    TextStyle muted([FontWeight w = FontWeight.w600]) =>
        TextStyle(color: textMuted, fontWeight: w, fontSize: 12.5);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top meta row
          Row(
            children: [
              Text(item.date, style: muted(FontWeight.w700)),
              const Spacer(),
              Chip(text: item.category),
              const SizedBox(width: 8),
              Chip(text: item.type),
            ],
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            item.title,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          // Footer row (person + duration)
          Row(
            children: [
              const Icon(CupertinoIcons.person, size: 16, color: textMuted),
              const SizedBox(width: 6),
              Expanded(child: Text(item.person, style: muted(FontWeight.w500))),
              const SizedBox(width: 8),
              const Icon(CupertinoIcons.time, size: 16, color: textMuted),
              const SizedBox(width: 6),
              Text(item.duration, style: muted(FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
