import 'package:easy_ops/controllers/theme_controller.dart';
import 'package:easy_ops/network/ApiService.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  // Inputs
  final emailController = TextEditingController(); // email OR phone
  final passwordController = TextEditingController();

  // UI state
  final isPasswordVisible = false.obs;
  final isLoading = false.obs; // <-- for the progress indicator
  final role = ''.obs;
  final themeController = Get.find<ThemeController>();
  final ApiService _apiService = Get.find<ApiService>(); // ✅

  @override
  void onInit() {
    super.onInit();
    emailController.text = "satya.eazysaas@gmail.com";
    passwordController.text = "r@Iv2Zi8iu?M";
  }

  Future<void> login() async {
    if (isLoading.value) return;
    // Accept either email OR phone
    final userName = emailController.text.trim();
    final password = passwordController.text.trim();
    final isEmail = _isValidEmail(userName);
    final isPhone = _isValidPhone(password);
    if (!isEmail && !isPhone) {
      _err('Enter a valid email address or phone number');
      return;
    }
    isLoading.value = true;
    try {
      final res = await _apiService.loginWithBasic(
        username: userName,
        password: password,
      );

      // final resq = await _apiService.historyWorkOrderActivityById(
      //   "HWOA-123456",
      // );
      Get.toNamed(Routes.workOrderScreen);
      Get.snackbar(
        'Success',
        'Logged in successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // your code here
    } on Exception catch (e, st) {
      // handle/log the error
      debugPrint('Error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void forgotPassword() {
    final idRaw = emailController.text.trim();

    if (idRaw.isEmpty) {
      _err('Please enter mobile number');
      return;
    }
    final isPhone = _isValidPhone(idRaw);
    if (!isPhone) {
      _err('Please enter a valid phone number');
      return;
    }
    final phone = _normalizePhone(idRaw); // keep your existing helper
    Get.toNamed(Routes.forgotPasswordScreen, arguments: {'phone': phone});
  }
  /* ================= Helpers ================= */

  void _err(String msg) {
    Get.snackbar(
      'Error',
      msg,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  bool _isValidEmail(String input) {
    // Simple, robust email check (no spaces, one "@", a dot after)
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(input);
  }

  String _normalizePhone(String input) {
    // Keep leading +, remove everything else that's not a digit
    final cleaned = input.replaceAll(RegExp(r'[^\d+]'), '');
    if (RegExp(r'\+').allMatches(cleaned).length > 1 ||
        (cleaned.contains('+') && !cleaned.startsWith('+'))) {
      return cleaned.replaceAll('+', '');
    }
    return cleaned;
  }

  bool _isValidPhone(String input) {
    final normalized = _normalizePhone(input);
    // Your spec: optional +, exactly 10 digits
    return RegExp(r'^\+?\d{10}$').hasMatch(normalized);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
