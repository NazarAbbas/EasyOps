import 'package:flutter/material.dart';

class ValueTile extends StatelessWidget {
  final String value;
  const ValueTile(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.zero, // adjust if you want spacing
      child: _ValueInner(),
    );
  }
}

class _ValueInner extends StatelessWidget {
  const _ValueInner();

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero, // add padding if needed
        filled: false,
      ),
      child: const Text(
        '-', // will be replaced below via ValueListenableBuilder if needed
        style: TextStyle(color: Color(0xFF2D2F39), fontWeight: FontWeight.w600),
      ),
    );
  }
}
