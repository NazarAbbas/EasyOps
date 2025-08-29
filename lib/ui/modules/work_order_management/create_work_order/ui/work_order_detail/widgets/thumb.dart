import 'package:flutter/material.dart';

class Thumb extends StatelessWidget {
  const Thumb({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF6),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: const AssetImage(
            'assets/placeholder.jpg',
          ), // replace if you have
          fit: BoxFit.cover,
          onError: (_, __) {}, // fallback to plain color
        ),
      ),
    );
  }
}
