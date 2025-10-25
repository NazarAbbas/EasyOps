import 'package:easy_ops/core/theme/app_colors.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';

const _kBlue = Color(0xFF2F6BFF);

class AppInput {
  static InputDecoration fieldDecoration() => InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE1E6EF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE1E6EF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
        ),
      );

  static OutlineInputBorder _outline(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c),
      );

  static final InputDecorationTheme theme = InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: _outline(const Color(0xFFE1E6EF)),
    enabledBorder: _outline(const Color(0xFFE1E6EF)),
    focusedBorder: _outline(_kBlue),
  );

  static InputDecoration decoration({String? hintText, Widget? suffixIcon}) =>
      InputDecoration(hintText: hintText, suffixIcon: suffixIcon);

  static const _idle = Color(0xFFE1E6EF);
  static const _focus = Color(0xFF2F6BFF);
  static InputDecoration bordered({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: _outline(_idle),
      enabledBorder: _outline(_idle),
      focusedBorder: _outline(_focus),
    );
  }

  static InputDecorationTheme get decorationTheme => InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.primaryBlue, width: 1.6),
        ),
      );

  static InputDecoration infoPageBordered({String? hint, Widget? suffix}) =>
      InputDecoration(hintText: hint, suffixIcon: suffix);
}

/// Returns "HH:mm | dd Mon"
String formatDate(DateTime dt) {
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final day = dt.day.toString().padLeft(2, '0');
  final month = months[dt.month - 1];

  return '$hh:$mm | $day $month';
}

WorkOrders? getWorkOrderFromArgs(dynamic args) {
  // If caller passed the model directly
  if (args is WorkOrders) return args;

  // If caller passed a Map (JSON or wrapper)
  if (args is Map) {
    final map = args.cast<String, dynamic>();

    // Common keys you might use when pushing arguments
    final raw = map['work_order_info'] ??
        map['workOrder'] ??
        map['work_order'] ??
        map['workOrderInfo'];

    if (raw is WorkOrders) return raw;
    if (raw is Map) {
      return WorkOrders.fromJson(Map<String, dynamic>.from(raw));
    }
  }

  // Nothing usable
  return null;
}
