import 'package:easy_ops/constants/values/app_images.dart';
import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  final bool isTablet;
  const LoginLogo({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.gearIcon,
          width: isTablet ? 70 : 50,
          height: isTablet ? 70 : 50,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text(
          'EazyOps',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 34 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
