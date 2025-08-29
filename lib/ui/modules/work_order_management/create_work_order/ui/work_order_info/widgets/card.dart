import 'package:flutter/material.dart';

const _kCard = Color(0xFFF4F7FB);

class CustomCard extends StatelessWidget {
  final Widget child;
  final double radius;
  const CustomCard({super.key, required this.child, this.radius = 12});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
