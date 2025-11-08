import 'package:easy_ops/core/utils/loading_overlay.dart' show LoadingOverlay;
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/reassign_work_order/controller/me_reassign_work_order_controller.dart';
import 'package:easy_ops/features/reusable_components/lookup_picker.dart';
import 'package:easy_ops/features/reusable_components/work_order_top_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

/// Palette
class _C {
  static const bg = Color(0xFFF7F8FA);
  static const surface = Colors.white;
  static const border = Color(0xFFE9EEF5);
  static const text = Color(0xFF1F2430);
  static const muted = Color(0xFF7C8698);
  static const primary = Color(0xFF2F6BFF);
  static const pillBlue = Color(0xFFEFF4FF);
  static const dangerText = Color(0xFFED3B40);
  static const dangerBg = Color(0xFFFFE7E7);
}

/// ───────────────────────── UI Page ─────────────────────────
class MEReassignWorkOrderPage extends GetView<MEReassignWorkOrderController> {
  const MEReassignWorkOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;

    return Obx(() {
      final wo = c.workOrderInfo.value; // ⬅️ reactive read
      final busy = c.isSubmitting.value;

      return Stack(
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
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: busy ? null : () => Get.back(),
              ),
              title: const Text(
                'Reassign Work Order',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            body: AbsorbPointer(
              absorbing: busy,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
                children: [
                  if (wo != null)
                    WorkOrderTile(
                      workOrderInfo: wo, // ✅ guarded
                      onTap: () => debugPrint('Open work order'),
                    )
                  else
                    const _WorkOrderTileSkeleton(), // ✅ placeholder

                  const SizedBox(height: 16),
                  _FormCard(controller: c),
                ],
              ),
            ),
            bottomNavigationBar: _BottomBar(controller: c),
          ),
          if (busy) const LoadingOverlay(message: 'Reassigning…'),
        ],
      );
    });
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.controller});
  final MEReassignWorkOrderController controller;

  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

  @override
  Widget build(BuildContext context) {
    label(String s, {bool optional = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(s,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: _C.text)),
              if (optional) ...[
                const SizedBox(width: 6),
                const Text('(Optional)', style: TextStyle(color: _C.muted)),
              ],
            ],
          ),
        );

    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label('Reason'),
          Obx(() {
            final sel = controller.selectedReason.value;
            final text =
                _isPlaceholder(sel) ? 'Select reason' : sel!.displayName;
            return _TapField(
              text: text,
              onTap: () async {
                final v = await LookupPicker.show(
                  context: context,
                  // If you have a dedicated type for reassign reasons, use it here.
                  // Fallback to resolutiontype/cancellation per your API contract.
                  lookupType: LookupType.resolutiontype.name,
                  selected: controller.selectedReason.value,
                );
                if (v != null) {
                  controller.selectedReason.value = v;
                  controller.selectedReasonValue.value = v.displayName;
                }
              },
              enabled: !controller.isSubmitting.value,
            );
          }),
          const SizedBox(height: 16),
          label('Remarks', optional: true),
          _RemarksField(controller: controller),
          const SizedBox(height: 4),
          Obx(
            () => Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller.remarks.value.length}/300',
                style: const TextStyle(fontSize: 12, color: _C.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemarksField extends StatelessWidget {
  const _RemarksField({required this.controller});
  final MEReassignWorkOrderController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: controller.remarksCtrl,
        minLines: 4,
        maxLines: 6,
        maxLength: 300,
        textInputAction: TextInputAction.newline,
        onChanged: (v) => controller.remarks.value = v,
        enabled: !controller.isSubmitting.value,
        decoration: InputDecoration(
          hintText: 'Type remarks…',
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFF6F7FB),
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
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.controller});
  final MEReassignWorkOrderController controller;

  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select reason');

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
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          controller.onDiscard();
                        },
                  child: Text('Discard',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: primary)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                final sel = controller.selectedReason.value;
                final canSubmit =
                    !_isPlaceholder(sel) && !controller.isSubmitting.value;
                return FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor:
                        canSubmit ? primary : primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: canSubmit
                      ? () async {
                          HapticFeedback.mediumImpact();
                          await controller.onReassign();
                        }
                      : null,
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Reassign',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// ───────────────────────── Mini Widgets ─────────────────────────
class _TapField extends StatelessWidget {
  const _TapField(
      {required this.text, required this.onTap, this.enabled = true});

  final String text;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = text.trim().isEmpty || text == 'Select reason';
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? onTap : null,
      child: InputDecorator(
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF6F7FB),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.keyboard_arrow_down_rounded, color: _C.muted),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 32, minHeight: 32),
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
        ),
        child: Text(
          isPlaceholder ? 'Select reason' : text,
          style: TextStyle(
            color: isPlaceholder ? _C.muted : _C.text,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

final _cardDecoration = BoxDecoration(
  color: _C.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _C.border),
  boxShadow: const [
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4))
  ],
);

/// Simple placeholder while work order is loading
class _WorkOrderTileSkeleton extends StatelessWidget {
  const _WorkOrderTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _shimmerBox(height: 16, width: double.infinity),
          const SizedBox(height: 8),
          _shimmerBox(height: 14, width: double.infinity),
          const SizedBox(height: 8),
          _shimmerBox(height: 14, width: double.infinity),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F8),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
