import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_ops/constants/values/app_colors.dart';

class ThemeController extends GetxController {
  static const _fontFamily = 'Inter'; // <-- your font family name

  // Default Theme (User)
  final ThemeData defaultTheme = ThemeData(
    fontFamily: _fontFamily, // <-- apply globally
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
    fontFamily: _fontFamily, // <-- apply globally
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

  final Rx<ThemeData> currentTheme = ThemeData().obs;

  @override
  void onInit() {
    super.onInit();
    currentTheme.value = defaultTheme;
  }

  void setThemeByRole(String role) {
    currentTheme.value = (role == 'admin') ? adminTheme : defaultTheme;
  }
}
