import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lightweight palette used only inside this component.
/// You can replace these with your design system if you prefer.
class _C {
  static const border = Color(0xFFE9EEF5);
  static const text = Color(0xFF1F2430);
  static const muted = Color(0xFF7C8698);
  static const primary = Color(0xFF2F6BFF);
}

class PickerBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required List<T> items,
    required T? selected,
    required String Function(T) labelOf,
    String Function(T)? codeOf,
    String Function(T)? avatarTextOf,
  }) async {
    final kb = MediaQuery.of(context).viewInsets.bottom;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: kb),
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: _PickerList<T>(
              title: title,
              items: items,
              selected: selected,
              labelOf: labelOf,
              codeOf: codeOf,
              avatarTextOf: avatarTextOf,
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerList<T> extends StatefulWidget {
  const _PickerList({
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.codeOf,
    required this.avatarTextOf,
    this.title,
  });

  final String? title;
  final List<T> items;
  final T? selected;
  final String Function(T) labelOf;
  final String Function(T)? codeOf;
  final String Function(T)? avatarTextOf;

  @override
  State<_PickerList<T>> createState() => _PickerListState<T>();
}

class _PickerListState<T> extends State<_PickerList<T>> {
  late T? current;

  @override
  void initState() {
    super.initState();
    current = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 44,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EDF6),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        if ((widget.title ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: _C.text,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        const Divider(height: 1, color: _C.border),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.items.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFF2F5FA)),
            itemBuilder: (_, i) {
              final item = widget.items[i];
              final label = widget.labelOf(item);
              final code = widget.codeOf?.call(item) ?? '';
              final avatarText = widget.avatarTextOf?.call(item) ??
                  (label.isNotEmpty ? label[0].toUpperCase() : '?');
              final selected = identical(current, item) || current == item;

              return ListTile(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => current = item);
                  Navigator.of(context).pop<T>(item);
                },
                dense: true,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF2F5FF),
                  child: Text(
                    avatarText,
                    style: const TextStyle(
                      color: _C.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(
                  label.isEmpty ? '(Unnamed)' : label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: (code.isNotEmpty)
                    ? Text(
                        code,
                        style: const TextStyle(
                          color: _C.muted,
                          fontSize: 12,
                        ),
                      )
                    : null,
                trailing: _RoundCheck(
                  value: selected,
                  onChanged: (val) {
                    if (val == true) {
                      HapticFeedback.selectionClick();
                      setState(() => current = item);
                      Navigator.of(context).pop<T>(item);
                    }
                  },
                ),
              );
            },
          ),
        ),
        const Divider(height: 1, color: _C.border),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _C.primary,
                    side: const BorderSide(color: _C.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundCheck extends StatelessWidget {
  const _RoundCheck({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape: const CircleBorder(),
      side: const BorderSide(color: _C.border),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      activeColor: _C.primary,
      checkColor: Colors.white,
    );
  }
}
