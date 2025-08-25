import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/forgot_password/controller/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordButtons extends StatelessWidget {
  const ForgotPasswordButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    final isTablet = MediaQuery.of(context).size.width > 600; // breakpoint

    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: isTablet ? 2 : 1,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
                minimumSize: Size(double.infinity, isTablet ? 55 : 45), // responsive
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.resendCode,
              child: const Text("Resend Code"),
            ),
          ),
          const SizedBox(width: 16), // spacing between buttons
          Expanded(
            flex: isTablet ? 2 : 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: Size(double.infinity, isTablet ? 55 : 45), // responsive
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.verifyCode,
              child: const Text(
                "Verify Code",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
