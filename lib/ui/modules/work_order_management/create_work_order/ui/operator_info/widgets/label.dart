import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Widget? child;
  const Label(this.text, {super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2F39),
          ),
        ),
        const SizedBox(height: 6),
        if (child != null) child!,
      ],
    );
  }
}
