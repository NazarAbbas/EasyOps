import 'package:easy_ops/ui/modules/forgot_password/controller/forgot_password_controller.dart';
import 'package:easy_ops/ui/modules/forgot_password/widgets/forgot_password_buttons.dart';
import 'package:easy_ops/ui/modules/forgot_password/widgets/forgot_password_header.dart';
import 'package:easy_ops/ui/modules/forgot_password/widgets/forgot_password_info_text.dart';
import 'package:easy_ops/ui/modules/forgot_password/widgets/forgot_password_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_ops/constants/values/app_images.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: Text('forgot_password_text'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ForgotPasswordHeader(imagePath: AppImages.forgotPasswordFrameIcon),
            const SizedBox(height: 20),
            const ForgotPasswordInfoText(),
            const SizedBox(height: 20),
            const ForgotPasswordOtpField(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const ForgotPasswordButtons(),
    );
  }
}
