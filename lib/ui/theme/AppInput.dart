import 'package:flutter/material.dart';

const _kBlue = Color(0xFF2F6BFF);

class AppInput {
  static InputDecoration fieldDecoration() => InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  // static OutlineInputBorder _outline(Color c) => OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(8),
  //   borderSide: BorderSide(color: c),
  // );

  /// Global theme for all inputs
  // static final InputDecorationTheme theme = InputDecorationTheme(
  //   isDense: true,
  //   filled: true,
  //   fillColor: Colors.white,
  //   contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //   border: _outline(_idle),
  //   enabledBorder: _outline(_idle),
  //   focusedBorder: _outline(_focus),
  // );

  /// Use this on any field that needs a guaranteed bordered look.
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
}
