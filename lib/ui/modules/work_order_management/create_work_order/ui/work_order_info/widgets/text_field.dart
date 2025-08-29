import 'package:easy_ops/ui/theme/AppInput.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    required decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      decoration: AppInput.fieldDecoration().copyWith(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9AA3B2)),
        suffixIcon: (suffixIcon == null)
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 8),
                child: suffixIcon,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 40,
          minWidth: 36,
        ),
      ),
    );
  }
}
