import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  // Timer countdown
  var remainingSeconds = 115.obs;
  Timer? _timer;

  // OTP handling
  var otpCode = ''.obs;
  final otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    remainingSeconds.value = 115;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendCode() {
    startTimer();
    otpController.clear();
    otpCode.value = '';
    Get.snackbar("OTP", "Resend Code triggered",
        snackPosition: SnackPosition.BOTTOM);
  }

  void verifyCode() {
    if (otpCode.value.length == 6) {
      Get.snackbar("OTP", "Code Verified ✅",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("OTP", "Invalid Code ❌",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
