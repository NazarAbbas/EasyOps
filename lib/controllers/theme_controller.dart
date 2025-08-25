import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_ops/constants/values/app_colors.dart';

class ThemeController extends GetxController {
  // Default Theme (User)
  final ThemeData defaultTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  // Admin Theme
  final ThemeData adminTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.textGrey,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  /// ✅ Initialize currentTheme with defaultTheme immediately
  final Rx<ThemeData> currentTheme = ThemeData().obs;

  @override
  void onInit() {
    super.onInit();
    currentTheme.value = defaultTheme;
  }

  /// Optional: Switch theme based on role
  void setThemeByRole(String role) {
    currentTheme.value = (role == 'admin') ? adminTheme : defaultTheme;
  }
}
