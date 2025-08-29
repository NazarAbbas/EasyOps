import 'package:flutter/material.dart';

class OperatorInfo extends StatelessWidget {
  final bool isTablet;
  const OperatorInfo({super.key, required this.isTablet});
  @override
  Widget build(BuildContext context) {
    final double label = isTablet ? 16 : 15;
    final double value = isTablet ? 16 : 15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operator Info',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: label,
            color: const Color(0xFF2D2F39),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ajay Kumar (MP18292)',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: value,
            color: const Color(0xFF2D2F39),
          ),
        ),
        const SizedBox(height: 2),
        const Text('9876543211', style: TextStyle(color: Color(0xFF2D2F39))),
        const SizedBox(height: 2),
        const Text(
          'Assets Shop | 12:20| 03 Sept| A',
          style: TextStyle(color: Color(0xFF2D2F39)),
        ),
      ],
    );
  }
}
