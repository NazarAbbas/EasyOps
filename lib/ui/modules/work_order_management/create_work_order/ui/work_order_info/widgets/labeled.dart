import 'package:flutter/material.dart';

class Labeled extends StatelessWidget {
  final String label;
  final double labelSize;
  final Widget child;
  const Labeled(this.label, this.labelSize, {super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D2F39),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
