import 'package:easy_ops/ui/theme/AppInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectBox extends StatelessWidget {
  final String hint;
  final String? value;
  final VoidCallback onTap;
  const SelectBox({
    super.key,
    required this.hint,
    this.value,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: InputDecorator(
        decoration: AppInput.fieldDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: (value == null)
                      ? const Color(0xFF9AA3B2)
                      : const Color(0xFF2D2F39),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: Color(0xFF9AA3B2),
            ),
          ],
        ),
      ),
    );
  }
}
