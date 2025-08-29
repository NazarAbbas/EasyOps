import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabelValue extends StatelessWidget {
  final String label;
  final RxString valueRx;
  const LabelValue({super.key, required this.label, required this.valueRx});

  @override
  Widget build(BuildContext context) {
    return Label(
      label,
      child: Obx(() {
        return InputDecorator(
          decoration: const InputDecoration(
            border: InputBorder.none, // <- remove line
            enabledBorder: InputBorder.none, // <- remove line
            focusedBorder: InputBorder.none, // <- remove line
            isDense: true,
            contentPadding: EdgeInsets.zero, // optional: tighten spacing
            filled: false,
          ),
          child: Text(
            valueRx.value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }),
    );
  }
}
