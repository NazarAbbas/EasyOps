import 'package:flutter/material.dart';

Future<void> pick(
  BuildContext context, {
  required String title,
  required List<String> items,
  required ValueChanged<String> onPick,
}) async {
  final v = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
    ),
    builder: (_) => ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        ...items.map(
          (e) =>
              ListTile(title: Text(e), onTap: () => Navigator.pop(context, e)),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
  if (v != null) onPick(v);
}
