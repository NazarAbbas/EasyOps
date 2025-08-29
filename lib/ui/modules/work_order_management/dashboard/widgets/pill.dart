import 'package:easy_ops/ui/modules/work_order_management/dashboard/models/work_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  final StatusPill pill;
  const Pill(this.pill, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = switch (pill) {
      StatusPill.high => (
        bg: const Color(0xFFE94141),
        fg: Colors.white,
        text: 'High',
      ),
      StatusPill.resolved => (
        bg: const Color(0xFF017F0E),
        fg: Colors.white,
        text: 'Resolved',
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        colors.text,
        style: TextStyle(
          color: colors.fg,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
      ),
    );
  }
}
