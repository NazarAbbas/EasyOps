import 'package:flutter/material.dart';

class IconSquare extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const IconSquare({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEFF3FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(width: 46, height: 46, child: Center(child: child)),
      ),
    );
  }
}
