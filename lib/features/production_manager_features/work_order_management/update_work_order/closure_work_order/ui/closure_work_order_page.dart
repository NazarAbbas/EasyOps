// closure_page.dart
import 'dart:io';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/controller/closure_work_order_controller.dart';
import 'package:easy_ops/core/utils/loading_overlay.dart';
import 'package:easy_ops/features/reusable_components/lookup_picker.dart';
import 'package:easy_ops/features/reusable_components/work_order_top_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class ClosureWorkOrderPage extends GetView<ClosureWorkOrderController> {
  const ClosureWorkOrderPage({super.key});

  @override
  ClosureWorkOrderController get controller =>
      Get.put(ClosureWorkOrderController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final hPad = isTablet ? 20.0 : 16.0;
    final btnH = isTablet ? 56.0 : 52.0;

    return Scaffold(
      backgroundColor: _C.bg,
      resizeToAvoidBottomInset: true,
      appBar: _HeaderAppBar(isTablet: isTablet),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: _C.line)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -4),
              )
            ],
          ),
          padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 12),
          child: Obx(() {
            final busy = controller.isSubmitting.value;
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(CupertinoIcons.arrow_counterclockwise),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(btnH),
                      side: const BorderSide(color: _C.primary, width: 1.4),
                      foregroundColor: _C.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: busy ? null : controller.reopenWorkOrder,
                    label: const Text(
                      'Re-open',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(CupertinoIcons.check_mark_circled_solid),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(btnH),
                      backgroundColor: _C.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1.5,
                    ),
                    onPressed: busy
                        ? null
                        : () async {
                            controller.isSubmitting.value = true;
                            try {
                              await controller.closeWorkOrder();
                            } finally {
                              controller.isSubmitting.value = false;
                            }
                          },
                    label: const Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      body: Obx(() {
        final busy = controller.isSubmitting.value;
        final kb = MediaQuery.of(context).viewInsets.bottom; // keyboard inset
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24 + kb),
              child: Column(
                children: [
                  WorkOrderTile(
                    workOrderInfo: controller.workOrderInfo!,
                    onTap: () => print('Open work order'),
                  ),
                  // _IssueHeaderCard(),
                  const SizedBox(height: 12),
                  const _ClosureCommentsCard(),
                  const SizedBox(height: 12),
                  const _SparesCard(),
                  const SizedBox(height: 90),
                ],
              ),
            ),
            if (busy)
              const LoadingOverlay(
                message: 'Closing Work Order...',
              ),
          ],
        );
      }),
    );
  }
}

/* ===================== AppBar (overflow-proof) ===================== */

class _HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTablet;
  const _HeaderAppBar({required this.isTablet});

  @override
  Size get preferredSize => Size.fromHeight(isTablet ? 92 : 84);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final titleText = Get.find<ClosureWorkOrderController>().pageTitle.value;

      return AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2F6BFF), Color(0xFF6A8CFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // prevents vertical overflow
          children: [
            // Line 1 — main title
            Text(
              titleText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: .2,
                fontSize: isTablet ? 20 : 18,
              ),
            ),
            // Line 2 — subtitle
          ],
        ),
      );
    });
  }
}

/* ===================== closure comments ===================== */

class _ClosureCommentsCard extends GetView<ClosureWorkOrderController> {
  const _ClosureCommentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'Closure Details',
            icon: CupertinoIcons.doc_text_fill,
          ),
          const SizedBox(height: 10),

          // Reason
          const _KVLabel('Cancel / Resolution Reason'),
          const SizedBox(height: 6),
          const _ReasonPickerField(),
          const SizedBox(height: 16),

          // Note
          const _KVLabel('Note'),
          const SizedBox(height: 6),
          TextField(
            controller: controller.noteCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: _D.field(hint: 'Add a brief summary of the resolution'),
          ),
          const SizedBox(height: 16),

          // Signature
          const _KVLabel('Signature'),
          const SizedBox(height: 6),
          _SignaturePad(),
          const SizedBox(height: 8),

          Row(
            children: [
              TextButton.icon(
                onPressed: controller.clearSignature,
                icon: const Icon(CupertinoIcons.trash),
                label: const Text('Clear'),
              ),
              const Spacer(),
              Flexible(
                child: Obx(() {
                  final path = controller.savedSignaturePath.value;
                  if (path.isEmpty || !File(path).existsSync()) {
                    return const SizedBox.shrink();
                  }
                  final fileName = path.split(Platform.pathSeparator).last;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(CupertinoIcons.check_mark_circled_solid,
                          size: 16, color: _C.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Saved • $fileName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: _C.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${TimeOfDay.now().format(context)} • Today',
            style: const TextStyle(
              color: _C.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePad extends GetView<ClosureWorkOrderController> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: const Color(0xFFF8FAFF),
        shape: _DashedBorder(
          color: const Color(0xFFE0E7F5),
          radius: 12,
          dashWidth: 5,
          dashSpace: 4,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          child: Signature(
            controller: controller.signatureCtrl,
            backgroundColor: const Color(0xFFF8FAFF),
          ),
        ),
      ),
    );
  }
}

class _ReasonPickerField extends GetView<ClosureWorkOrderController> {
  const _ReasonPickerField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = controller.selectedReason.value;
      final isPlaceholder =
          sel == null || (sel.id.isEmpty && sel.displayName == 'Select reason');

      final text = isPlaceholder
          ? 'Select reason'
          : (sel.displayName.isEmpty ? '(Unnamed)' : sel.displayName);

      return InkWell(
        onTap: () async {
          final v = await LookupPicker.show(
            context: context,
            lookupType: LookupType.resolutiontype.name,
            selected: controller.selectedReason.value,
          );
          if (v != null) {
            controller.selectedReason.value = v;
            controller.selectedReasonValue.value =
                v.displayName; // <-- update the text
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: _D.field().copyWith(
                suffixIcon: const Icon(CupertinoIcons.chevron_up),
              ),
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

  // Future<void> _openReasonSheet(BuildContext context) async {
  //   if (controller.isSubmitting.value) return;

  //   final chosen = await ReasonPicker.show(
  //     context: context,
  //     items: controller.reason.toList(), // List<LookupValues>
  //     selected: controller.selectedReason.value, // LookupValues?
  //     title: 'Select Reason',
  //   );

  //   if (chosen != null) {
  //     controller.selectedReason.value = chosen; // ⬅️ key unchanged
  //   }
  // }

  // void _openReasonSheet(BuildContext context) {
  //   final current = controller.selectedCancelOrderReason.value;
  //   final options = controller.cancelOrderReason
  //       .where((lv) => !(lv.id.isEmpty && lv.displayName == 'Select reason'))
  //       .toList();

  //   final kb = MediaQuery.of(context).viewInsets.bottom;

  //   Get.bottomSheet(
  //     isScrollControlled: true,
  //     SafeArea(
  //       child: FractionallySizedBox(
  //         heightFactor: 0.85,
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //           ),
  //           padding: EdgeInsets.fromLTRB(16, 10, 16, 12 + kb),
  //           child: Column(
  //             children: [
  //               Container(
  //                 width: 44,
  //                 height: 5,
  //                 margin: const EdgeInsets.only(bottom: 12),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFE8EDF6),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //               ),
  //               const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   'Select reason',
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Expanded(
  //                 child: ListView.separated(
  //                   itemCount: options.length,
  //                   separatorBuilder: (_, __) =>
  //                       const Divider(height: 1, color: _C.line),
  //                   itemBuilder: (ctx, i) {
  //                     final lv = options[i];
  //                     final isSelected = current?.id == lv.id;
  //                     return ListTile(
  //                       dense: true,
  //                       leading: CircleAvatar(
  //                         radius: 14,
  //                         backgroundColor: const Color(0xFFF2F5FF),
  //                         child: Text(
  //                           (lv.displayName.isNotEmpty
  //                                   ? lv.displayName[0]
  //                                   : '?')
  //                               .toUpperCase(),
  //                           style: const TextStyle(
  //                             color: _C.primary,
  //                             fontWeight: FontWeight.w800,
  //                             fontSize: 12,
  //                           ),
  //                         ),
  //                       ),
  //                       title: Text(
  //                         lv.displayName.isEmpty ? '(Unnamed)' : lv.displayName,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: const TextStyle(fontWeight: FontWeight.w700),
  //                       ),
  //                       subtitle: (lv.code.isNotEmpty)
  //                           ? Text(lv.code,
  //                               style: const TextStyle(
  //                                   color: _C.muted, fontSize: 12))
  //                           : null,
  //                       trailing: AnimatedSwitcher(
  //                         duration: const Duration(milliseconds: 200),
  //                         child: isSelected
  //                             ? const Icon(Icons.check_circle,
  //                                 color: _C.primary)
  //                             : const SizedBox(width: 24),
  //                       ),
  //                       onTap: () {
  //                         controller.selectedCancelOrderReason.value = lv;
  //                         Get.back();
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: OutlinedButton(
  //                       style: OutlinedButton.styleFrom(
  //                         foregroundColor: _C.primary,
  //                         side: const BorderSide(color: _C.primary),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       onPressed: Get.back,
  //                       child: const Text(
  //                         'Close',
  //                         style: TextStyle(fontWeight: FontWeight.w700),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     backgroundColor: Colors.transparent,
  //     enableDrag: true,
  //   );
  // }
}

/* ===================== spares ===================== */

class _SparesCard extends GetView<ClosureWorkOrderController> {
  const _SparesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Spares Consumed',
              icon: CupertinoIcons.cube_box_fill,
              trailing: Text(
                '(${controller.totalQty} nos • ₹ ${controller.totalCost})',
                style: const TextStyle(
                  color: _C.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Divider(height: 1, color: _C.line),
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 8),
              secondChild: Column(
                children: controller.spares
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FF),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xFFEAF0FB)),
                              ),
                              child: const Icon(CupertinoIcons.gear,
                                  size: 16, color: _C.primary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.name,
                                style: const TextStyle(
                                  color: _C.text,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${s.qty} nos',
                              style: const TextStyle(
                                color: _C.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '₹ ${s.unitPrice}',
                              style: const TextStyle(
                                color: _C.text,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              crossFadeState: controller.sparesExpanded.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: controller.toggleSpares,
                icon: Icon(
                  controller.sparesExpanded.value
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 16,
                ),
                label: Text(
                  controller.sparesExpanded.value ? 'Collapse' : 'Expand',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== small pieces ===================== */

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _SectionHeader(
      {required this.title, required this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF3FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: _C.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.w800,
              fontSize: 15.5,
            ),
          ),
        ),
        if (trailing != null)
          Flexible(
              child: Align(alignment: Alignment.centerRight, child: trailing!)),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _KVLabel extends StatelessWidget {
  final String text;
  const _KVLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: _C.text,
        fontWeight: FontWeight.w800,
        fontSize: 14.5,
      ),
    );
  }
}

/* ===================== styles ===================== */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const bg = Color(0xFFF6F7FB);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
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

/* ===================== dashed border shape ===================== */

class _DashedBorder extends ShapeBorder {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  const _DashedBorder({
    this.color = const Color(0xFFE0E7F5),
    this.dashWidth = 4,
    this.dashSpace = 4,
    this.radius = 12,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = dashWidth;
        final next = distance + len;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}
