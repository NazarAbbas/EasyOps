import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text.rich(
        TextSpan(
          text: '${'help_text'.tr} ',
          style: TextStyle(color: Colors.grey[600]),
          children: [
            const TextSpan(
              text: 'contact@eazyops.in',
              style: TextStyle(color: AppColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
}
