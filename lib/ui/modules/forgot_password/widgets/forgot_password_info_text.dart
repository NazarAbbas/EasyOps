import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/forgot_password/controller/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordInfoText extends StatelessWidget {
  const ForgotPasswordInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font size (larger on tablets)
    final double fontSize = screenWidth > 600 ? 18 : 14;

    return Obx(
      () => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  "We have sent a code on your registered phone\nnumber ending with 0081.\nThis code will expire in: ",
              style: TextStyle(fontSize: fontSize, color: Colors.black54),
            ),
            TextSpan(
              text: "${controller.remainingSeconds.value}s",
              style: TextStyle(
                fontSize: fontSize,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
