import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/constants/values/app_images.dart';
import 'package:easy_ops/ui/modules/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_text_field.dart';

class LoginCard extends StatelessWidget {
  final LoginPageController controller;
  final bool isTablet;
  const LoginCard({
    super.key,
    required this.controller,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(isTablet ? 30 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'login_to_account'.tr,
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            LoginTextField(
              controller: controller.emailController,
              label: 'phone_or_email'.tr,
              hint: 'enter_registered'.tr,
            ),
            const SizedBox(height: 15),
            Obx(
              () => LoginTextField(
                controller: controller.passwordController,
                label: 'password'.tr,
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'forgot_password'.tr,
                  style: const TextStyle(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 14),
                ),
                child: Text(
                  'login'.tr,
                  style: TextStyle(fontSize: isTablet ? 20 : 16),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("or".tr),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 15),
            Center(
              child: Column(
                children: [
                  // Icon(
                  //   Icons.fingerprint,
                  //   size: isTablet ? 70 : 50,
                  //   color: AppColors.primaryBlue,
                  // ),
                  Image.asset(
                    AppImages.fingerPrint,
                    width: isTablet ? 70 : 50,
                    height: isTablet ? 70 : 50
                  ),
                  const SizedBox(height: 10),
                  Text('login_biometric'.tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
