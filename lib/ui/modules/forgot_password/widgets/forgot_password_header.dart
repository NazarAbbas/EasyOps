import 'package:flutter/material.dart';

class ForgotPasswordHeader extends StatelessWidget {
  final String imagePath;
  const ForgotPasswordHeader({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale image height based on device type
    final imageHeight = screenWidth > 600 ? 300.0 : 200.0; // Tablet vs Mobile

    return Center(
      child: Image.asset(
        imagePath,
        height: imageHeight,
      ),
    );
  }
}
