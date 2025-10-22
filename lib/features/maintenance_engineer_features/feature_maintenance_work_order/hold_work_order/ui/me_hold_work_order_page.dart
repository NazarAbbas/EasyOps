import 'package:easy_ops/core/utils/loading_overlay.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/hold_work_order/controller/me_hold_work_order_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/reusable_components/lookup_picker.dart';
import 'package:easy_ops/features/reusable_components/work_order_top_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// ───────────────────────── Palette ─────────────────────────
class _C {
  static const bg = Color(0xFFF7F8FA);
  static const surface = Colors.white;
  static const soft = Color(0xFFF6F7FB);
  static const border = Color(0xFFE9EEF5);
  static const text = Color(0xFF1F2430);
  static const muted = Color(0xFF7C8698);
  static const primary = Color(0xFF2F6BFF);
  static const pillBlue = Color(0xFFEFF4FF);
  static const dangerText = Color(0xFFED3B40);
  static const dangerBg = Color(0xFFFFE7E7);
  static const line = Color(0xFFE6EBF3);
}

/// ───────────────────────── Page ─────────────────────────
class MaintenanceEngineerHoldWorkOrderPage
    extends GetView<MEHoldWorkOrderController> {
  const MaintenanceEngineerHoldWorkOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: _C.bg,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              toolbarHeight: 56,
              backgroundColor: primary,
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: c.isSubmitting.value ? null : () => Get.back(),
              ),
              title: const Text(
                'Hold Work Order',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: AbsorbPointer(
              absorbing: c.isSubmitting.value,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
                children: [
                  // _WoInfoCard(c),
                  WorkOrderTile(
                    workOrderInfo: controller.workOrderInfo!,
                    onTap: () => print('Open work order'),
                  ),
                  const SizedBox(height: 12),
                  _HoldContextCard(c),
                  const SizedBox(height: 12),
                  _FormCard(c),
                ],
              ),
            ),
            bottomNavigationBar: _BottomBar(c),
          ),
          if (c.isSubmitting.value)
            const LoadingOverlay(message: 'Placing on hold…'),
        ],
      ),
    );
  }
}

/// ───────────────────────── Widgets ─────────────────────────

class _HoldContextCard extends StatelessWidget {
  const _HoldContextCard(this.c);
  final MEHoldWorkOrderController c;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration.copyWith(color: const Color(0xFFF9FAFC)),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    c.holdContextTitle.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _C.text,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_rounded,
                  color: _C.primary,
                  size: 20,
                ),
                onPressed: () => c.onEditContext(context),
                tooltip: 'Edit',
              ),
            ],
          ),
          Obx(
            () => Text(
              c.holdContextCategory.value,
              style: const TextStyle(
                color: _C.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              c.holdContextDesc.value,
              style: const TextStyle(color: _C.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard(this.c);
  final MEHoldWorkOrderController c;

  @override
  Widget build(BuildContext context) {
    label(String s, {bool optional = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                s,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: _C.text),
              ),
              if (optional) ...[
                const SizedBox(width: 6),
                const Text('(Optional)', style: TextStyle(color: _C.muted)),
              ],
            ],
          ),
        );

    return Container(
      decoration: _cardDecoration.copyWith(color: const Color(0xFFF5F7FB)),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Hold Reasons',
                style: TextStyle(fontWeight: FontWeight.w700, color: _C.muted),
              ),
            ),
          ),

          // Hold Reason Title
          label('Hold Reason Title'),
          Obx(
            () => TextField(
              controller: c.reasonTitleCtrl,
              onChanged: (v) => c.reasonTitle.value = v,
              enabled: !c.isSubmitting.value,
              decoration: _inputDecoration(hint: 'Placeholder'),
            ),
          ),
          const SizedBox(height: 14),

          // Hold Reason Type (dropdown)
          label('Hold Reason Type'),
          _TapField(
            textObs: c.selectedReasonValue,
            placeholder: 'Select',
            onTap: () async {
              final v = await LookupPicker.show(
                context: context,
                lookupType: LookupType.resolution.name,
                selected: c.selectedReason.value,
              );
              if (v != null) {
                c.selectedReason.value = v; // keep selected model
                c.selectedReasonValue.value =
                    v.displayName; // <-- update the text
              }
            },
          ),
          // Obx(
          //   () => _CupertinoLikeDropdown<String>(
          //     value: c.selectedReasonType.value,
          //     items: c.reasonTypes.toList(),
          //     onChanged: (v) {
          //       if (c.isSubmitting.value) return;
          //       HapticFeedback.selectionClick();
          //       c.selectedReasonType.value = v ?? c.reasonTypes.first;
          //     },
          //   ),
          // ),
          const SizedBox(height: 14),

          // Remarks
          label('Remarks', optional: true),
          Obx(
            () => TextField(
              controller: c.remarksCtrl,
              minLines: 4,
              maxLines: 6,
              maxLength: 300,
              onChanged: (v) => c.remarks.value = v,
              enabled: !c.isSubmitting.value,
              textInputAction: TextInputAction.newline,
              decoration: _inputDecoration(
                hint: 'Type remarks…',
              ).copyWith(counterText: ''),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  final RxString textObs;
  final String placeholder;
  final VoidCallback onTap;
  const _TapField({
    required this.textObs,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmpty = textObs.value.isEmpty || textObs.value == 'Select Reason';
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: InputDecorator(
          decoration: _D.field(
            suffix: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(CupertinoIcons.chevron_down, color: _C.muted),
            ),
          ),
          child: Text(
            isEmpty ? placeholder : textObs.value,
            style: TextStyle(
              color: isEmpty ? _C.muted : _C.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }
}

class _D {
  static InputDecoration field({String? hint, Widget? prefix, Widget? suffix}) {
    return const InputDecoration(
      isDense: true,
      hintText: null,
      hintStyle: TextStyle(color: _C.muted, fontWeight: FontWeight.w600),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      prefixIcon: null,
      suffixIcon: null,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: _C.line),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _C.line),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _C.primary),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ).copyWith(hintText: hint, prefixIcon: prefix, suffixIcon: suffix);
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar(this.c);
  final MEHoldWorkOrderController c;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          color: _C.surface,
          border: Border(top: BorderSide(color: _C.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: BorderSide(color: primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: c.isSubmitting.value ? null : () => c.onDiscard(),
                  child: Text(
                    'Discard',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                final submitting = c.isSubmitting.value;

                return FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: submitting
                        ? primary.withOpacity(0.5) // dim while submitting
                        : primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: submitting
                      ? null
                      : () async {
                          HapticFeedback.mediumImpact();
                          await c.onHold();
                        },
                  child: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Hold Work Order',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// ───────────────────────── Reusable UI helpers ─────────────────────────
InputDecoration _inputDecoration({required String hint}) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: _C.surface,
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBFD0FF)),
      ),
    );

final _cardDecoration = BoxDecoration(
  color: _C.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _C.border),
  boxShadow: const [
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
  ],
);

class _CupertinoLikeDropdown<T> extends StatelessWidget {
  const _CupertinoLikeDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    e.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.5, color: _C.text),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
