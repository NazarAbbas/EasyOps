import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static const _fontFamily = 'Inter';

  /// Normalize role strings from API/UI so minor format differences still match.
  /// Examples:
  /// - "ROLEMAINTENANCE_ENGINEER"        -> "ROLEMAINTENANCE_ENGINEER"
  /// - "rolemaintenance_engineer"        -> "ROLEMAINTENANCE_ENGINEER"
  /// - "ROLE_MAINTENANCE_ENGINEER"       -> "ROLEMAINTENANCE_ENGINEER"
  /// - " Role Maintenance Engineer  "    -> "ROLEMAINTENANCEENGINEER"
  String _norm(String s) =>
      s.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9_]'), '');

  ThemeData _exactTheme(Color primary, {Color? secondary}) {
    // Build a precise, non-seeded ColorScheme
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary ?? primary,
      onSecondary: Colors.white,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF111827),
      background: Colors.white,
      onBackground: const Color(0xFF111827),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        iconTheme: IconThemeData(color: scheme.onPrimary),
        titleTextStyle: TextStyle(
          color: scheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary, width: 1.4),
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F7FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
    );
  }

  // Role → Theme mappings (define your brand colors here)
  late final ThemeData productionManagerTheme =
      _exactTheme(const Color(0xFF2F6BFF));
  late final ThemeData maintenanceEngineerTheme =
      _exactTheme(AppColors.darkGray);
  late final ThemeData sellerTheme = _exactTheme(Colors.teal);
  late final ThemeData superUserTheme = _exactTheme(Colors.deepPurple);
  late final ThemeData auditorTheme = _exactTheme(Colors.indigo);
  late final ThemeData guestTheme = _exactTheme(Colors.grey);

  // Use normalized keys so lookups are reliable regardless of input casing/spacing
  late final Map<String, ThemeData> _byRole = {
    _norm('ROLEPRODUCTION_SUPERVISOR'): productionManagerTheme,
    _norm('ROLEMAINTENANCE_ENGINEER'): maintenanceEngineerTheme,

    // (Optional) add more as needed:
    _norm('ROLESELLER'): sellerTheme,
    _norm('ROLESUPER_USER'): superUserTheme,
    _norm('ROLEAUDITOR'): auditorTheme,
    _norm('ROLEGUEST'): guestTheme,
  };

  final Rx<ThemeData> currentTheme = ThemeData().obs;

  @override
  void onInit() {
    super.onInit();
    currentTheme.value = productionManagerTheme;
  }

  /// Public API: set theme by role string from server/session.
  void setThemeByRole(String role) {
    final key = _norm(role);
    final t = _byRole[key] ?? productionManagerTheme;

    if (!_byRole.containsKey(key)) {
      debugPrint(
        'ThemeController: unknown role "$role" (norm="$key"), using default (Production Manager).',
      );
    }

    currentTheme.value = t; // for Obx-bound GetMaterialApp(theme: ...)
    Get.changeTheme(t); // also update Get’s global theme
  }
}
