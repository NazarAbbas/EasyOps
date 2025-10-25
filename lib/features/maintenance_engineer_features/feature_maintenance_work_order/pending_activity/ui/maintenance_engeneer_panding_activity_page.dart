import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/controller/general_pending_activity_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/controller/pending_activity_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/reusable_components/lookup_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceEngineerPendingActivityPage
    extends GetView<MaintenanceEnginnerPendingActivityController> {
  const MaintenanceEngineerPendingActivityPage({super.key});

  final _formKey = const Key('add_edit_form');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            ...controller.activities.asMap().entries.map(
                  (e) => _ActivityCard(
                    item: e.value,
                    index: e.key,
                    onEdit: () {
                      controller.beginEdit(e.key);
                      Scrollable.ensureVisible(
                        primaryFocus?.context ?? context,
                        duration: const Duration(milliseconds: 250),
                      );
                    },
                    onDelete: () => _confirmDelete(context, e.key),
                  ),
                ),
            const SizedBox(height: 12),
            _FormCard(controller: controller, formKey: _formKey),
            const SizedBox(height: 20),
            const _GoBackButton(),
          ],
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete activity?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) controller.deleteAt(index);
  }
}

/* ------------------------------ Widgets ------------------------------ */

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF555C6E),
      foregroundColor: Colors.white,
      title: const Text('Pending Activity'),
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
        onPressed: () => Get.back<void>(),
      ),
      centerTitle: true,
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.item,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  final ActivityItem item;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _dateStr(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                  onPressed: onEdit,
                  icon: const Icon(CupertinoIcons.pencil, size: 18)),
              IconButton(
                  onPressed: onDelete,
                  icon: const Icon(CupertinoIcons.delete, size: 18)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(item.id,
                  style:
                      const TextStyle(color: Color(0xFF7C8698), fontSize: 12)),
              const Spacer(),
              Text(
                item.status,
                style: const TextStyle(
                    color: Color(0xFF2F6BFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(CupertinoIcons.calendar, size: 16),
              const SizedBox(width: 6),
              Text(
                item.targetDate != null
                    ? _dateStr(item.targetDate!)
                    : '--/--/----',
                style: const TextStyle(fontSize: 13),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.person, size: 16),
              const SizedBox(width: 6),
              Text(item.assignee ?? 'Unassigned',
                  style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.controller, required this.formKey});
  final MaintenanceEnginnerPendingActivityController controller;
  final Key formKey;

  InputDecoration _decor(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F6BFF), width: 1.5),
        ),
      );

  String _userLabel(UserSummary u) {
    final name = '${u.firstName} ${u.lastName}'.trim();
    return name.isEmpty ? u.email : name;
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = const TextStyle(
      fontSize: 13,
      color: Color(0xFF1F2430),
      fontWeight: FontWeight.w600,
    );

    return Container(
      key: formKey,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Center(
                child: Text(
                  controller.isEditing ? 'Edit Activity' : 'Add Activity',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              )),
          const SizedBox(height: 16),

          // Title
          Text('Activity Title', style: labelStyle),
          const SizedBox(height: 6),
          TextField(
              controller: controller.titleCtrl,
              decoration: _decor('Enter activity title')),
          const SizedBox(height: 14),

          // Activity Type (lookup picker)
          Text('Activity Type', style: labelStyle),
          const SizedBox(height: 6),
          const _ReasonPickerField(),
          const SizedBox(height: 14),

          // Assignee dropdown (BOUND TO USER LIST)
          Text('Assign To (Optional)', style: labelStyle),
          const SizedBox(height: 6),
          Obx(() {
            final items = controller.userSummary;
            return DropdownButtonFormField<UserSummary>(
              value: controller.selectedAssignee.value,
              decoration: _decor('Select assignee'),
              items: items
                  .map(
                    (u) => DropdownMenuItem<UserSummary>(
                      value: u,
                      child: Text(_userLabel(u)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => controller.selectedAssignee.value = v,
            );
          }),
          const SizedBox(height: 14),

          // Date
          Text('Target Date (Optional)', style: labelStyle),
          const SizedBox(height: 6),
          Obx(() {
            final d = controller.targetDate.value;
            final text = d == null
                ? ''
                : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
            return GestureDetector(
              onTap: () => controller.pickDate(context),
              child: InputDecorator(
                decoration: _decor('__/__/____').copyWith(
                  suffixIcon: const Icon(CupertinoIcons.calendar),
                ),
                child: Text(text.isEmpty ? ' ' : text,
                    style: const TextStyle(fontSize: 14)),
              ),
            );
          }),
          const SizedBox(height: 14),

          // Note
          Text('Add Note (Optional)', style: labelStyle),
          const SizedBox(height: 6),
          TextField(
              controller: controller.noteCtrl,
              minLines: 3,
              maxLines: 3,
              decoration: _decor('Write a note')),
          const SizedBox(height: 20),

          // Buttons
          Obx(() {
            final saving = controller.isSubmitting.value;
            final editing = controller.isEditing;

            return Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: saving ? null : controller.submit,
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(editing ? 'Update' : 'Add'),
                  ),
                ),
                if (editing) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: saving ? null : controller.cancelEdit,
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ReasonPickerField
    extends GetView<MaintenanceEnginnerPendingActivityController> {
  const _ReasonPickerField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = controller.selectedReason.value;
      final isPlaceholder = sel == null ||
          (sel.id.isEmpty && sel.displayName == 'Select activity type');

      final text = isPlaceholder
          ? 'Select activity type'
          : (sel.displayName.isEmpty ? '(Unnamed)' : sel.displayName);

      return InkWell(
        onTap: () async {
          final v = await LookupPicker.show(
            context: context,
            lookupType: LookupType.activityType.name,
            selected: controller.selectedReason.value,
          );
          if (v != null) {
            controller.selectedReason.value = v;
            controller.selectedReasonValue.value = v.displayName;
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: _D
              .field()
              .copyWith(suffixIcon: const Icon(CupertinoIcons.chevron_down)),
          child: Text(
            text,
            style: TextStyle(
              color: isPlaceholder ? _C.muted : _C.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }
}

class _D {
  static InputDecoration field({String? hint}) {
    return const InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE1E6EF)),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE1E6EF)),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _C.primary),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ).copyWith(
      hintText: hint,
      hintStyle: const TextStyle(color: _C.muted, fontWeight: FontWeight.w600),
    );
  }
}

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const bg = Color(0xFFF6F7FB);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
}

class _GoBackButton
    extends GetView<MaintenanceEnginnerPendingActivityController> {
  const _GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => controller.saveAndBack(),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF2F6BFF)),
        foregroundColor: const Color(0xFF2F6BFF),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text('Save & Back',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}
