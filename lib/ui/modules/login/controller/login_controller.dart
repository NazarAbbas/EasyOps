import 'package:easy_ops/controllers/theme_controller.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginPageController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var role = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Call API...
    // Suppose response has role
    final themeController = Get.find<ThemeController>();

    String userRole = "user"; // from API
    role.value = userRole;
    themeController.setThemeByRole(userRole);

    // if (role.value == "admin") {
    //   Get.toNamed(Routes.assestManagementDashboard);
    // } else {
    //   Get.toNamed(Routes.workOrderManagement);
    // }
     Get.toNamed(Routes.forgotPasswordScreen);

    //   if (email.isEmpty || password.isEmpty) {
    //     Get.snackbar("Error", "Please fill in all fields",
    //         snackPosition: SnackPosition.TOP, backgroundColor: Colors.redAccent, colorText: Colors.white);
    //     return;
    //   }

    //   // Implement your API call or login logic here
    //   Get.snackbar("Success", "Logged in successfully",
    //       snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
