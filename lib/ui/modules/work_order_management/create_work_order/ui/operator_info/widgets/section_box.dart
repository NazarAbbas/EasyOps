import 'package:easy_ops/ui/theme/AppInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectBox<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String> onPick;
  const SelectBox({
    super.key,
    this.value,
    required this.hint,
    required this.items,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final v = await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ),
          builder: (_) => ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: Text(
                  'Select',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              ...items.map(
                (e) => ListTile(
                  title: Text(e),
                  onTap: () => Navigator.pop(context, e),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
        if (v != null) onPick(v);
      },
      child: InputDecorator(
        decoration: AppInput.bordered(hintText: null), // <- border here
        child: Row(
          children: [
            Expanded(
              child: Text(
                value?.toString() ?? hint,
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
