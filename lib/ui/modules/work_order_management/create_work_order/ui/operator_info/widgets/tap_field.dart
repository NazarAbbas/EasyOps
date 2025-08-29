import 'package:easy_ops/ui/theme/AppInput.dart';
import 'package:flutter/material.dart';

class TapField extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget icon;
  const TapField(
    this.text, {
    super.key,
    required this.onTap,
    required this.icon,
  });

  bool get _isHint => text == 'hh:mm' || text == 'dd/mm/yyyy';

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      enableInteractiveSelection: false,
      onTap: onTap,
      decoration: AppInput.bordered(
        hintText: _isHint ? text : null,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: icon,
        ),
      ),
      controller: _isHint
          ? null
          : TextEditingController(
              text: text,
            ), // just to render value without keyboard
    );
  }
}
