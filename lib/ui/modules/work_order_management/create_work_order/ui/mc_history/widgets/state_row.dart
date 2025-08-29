import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2F6BFF);
    const label = TextStyle(
      color: Color(0xFF7C8698),
      fontWeight: FontWeight.w600,
    );
    const value = TextStyle(color: blue, fontWeight: FontWeight.w700);

    Widget cell(String l, String v) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: label),
        const SizedBox(height: 2),
        Text(v, style: value),
      ],
    );

    // small, subtle pipe like the screenshot
    Widget pipe() => Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 28, // adjust to match cell height
      color: const Color(0xFFE6EBF3),
    );

    return Column(
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
        const Divider(thickness: 1, height: 1, color: Color(0xFFE6EBF3)),
      ],
    );
  }
}
