/* ───────── Cancel Work Order (Beautiful UI) ───────── */
import 'dart:io';
import 'package:easy_ops/core/utils/loading_overlay.dart';
import 'package:easy_ops/features/cancel_work_order/controller/cancel_work_order_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelWorkOrderPage extends GetView<CancelWorkOrderController> {
  const CancelWorkOrderPage({super.key});

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
                    icon: const Icon(CupertinoIcons.clear),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(btnH),
                      side: const BorderSide(color: _C.primary, width: 1.4),
                      foregroundColor: _C.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: busy ? null : controller.discard,
                    label: const Text(
                      'Discard',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(CupertinoIcons.xmark_seal_fill),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(btnH),
                      backgroundColor: _C.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1.5,
                    ),
                    onPressed: busy ? null : controller.cancelWorkOrder,
                    label: busy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Cancel Work Order',
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
        final kb = MediaQuery.of(context).viewInsets.bottom;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24 + kb),
              child: Column(
                children: const [
                  _IssueHeaderCard(),
                  SizedBox(height: 12),
                  _CancelFormCard(),
                  SizedBox(height: 90),
                ],
              ),
            ),
            if (busy)
              const LoadingOverlay(
                message: 'Cancelling work order…',
              ),
          ],
        );
      }),
    );
  }
}

/* ===================== AppBar (centered, pretty) ===================== */

class _HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTablet;
  const _HeaderAppBar({required this.isTablet});

  @override
  Size get preferredSize => Size.fromHeight(isTablet ? 92 : 84);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true, // centered
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      leadingWidth: 56,
      actions: const [SizedBox(width: 56)], // balance for true centering
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2F6BFF), Color(0xFF6A8CFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: Get.back,
        icon: const Icon(CupertinoIcons.back),
        tooltip: 'Back',
      ),
      title: Text(
        'Cancel Work Order',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: .2,
          fontSize: isTablet ? 20 : 18,
        ),
      ),
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

/* ===================== top issue card ===================== */

class _IssueHeaderCard extends GetView<CancelWorkOrderController> {
  const _IssueHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              controller.issueTitle.value,
              style: const TextStyle(
                color: _C.text,
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            // Meta row
            Row(
              children: [
                _MetaChip(
                  icon: CupertinoIcons.number,
                  text: controller.workOrderId.value,
                ),
                const SizedBox(width: 8),
                _MetaChip(
                  icon: CupertinoIcons.time,
                  text: controller.time.value,
                ),
                const Spacer(),
                _Pill(
                  text: controller.priority.value,
                  color: const Color(0xFFEF4444),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  controller.category.value,
                  style: const TextStyle(
                    color: _C.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      controller.statusText.value,
                      style: const TextStyle(
                        color: _C.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.timer, size: 14, color: _C.muted),
                    const SizedBox(width: 4),
                    Text(
                      controller.duration.value,
                      style: const TextStyle(
                        color: _C.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7ECF6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _C.muted),
          const SizedBox(width: 6),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== Asset Card ===================== */

// class _AssetCard extends GetView<CancelWorkOrderController> {
//   const _AssetCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final a = controller.asset.value;
//       return _Card(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // icon block
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF4F7FF),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFFEAF0FB)),
//               ),
//               child: const Icon(CupertinoIcons.gear_alt_fill,
//                   size: 22, color: _C.primary),
//             ),
//             const SizedBox(width: 12),
//             // text
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // code | make
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Text(
//                           a.code,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: _C.text,
//                             fontSize: 16.5,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                       const Text(
//                         '  |  ',
//                         style: TextStyle(color: _C.muted, fontSize: 14),
//                       ),
//                       Flexible(
//                         child: Text(
//                           a.make,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: _C.text,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     a.description,
//                     style: const TextStyle(color: _C.muted, fontSize: 13.5),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text(
//                         a.status,
//                         style: const TextStyle(
//                           color: _C.primary,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: _C.pillRed,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: _C.pillRed.withOpacity(.28),
//                               blurRadius: 12,
//                               offset: const Offset(0, 4),
//                             )
//                           ],
//                         ),
//                         child: Text(
//                           a.criticality,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

/* ===================== Cancel Form ===================== */

class _CancelFormCard extends GetView<CancelWorkOrderController> {
  const _CancelFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _SectionHeader(
            title: 'Cancellation Details',
            icon: CupertinoIcons.xmark_circle_fill,
          ),
          SizedBox(height: 10),
          _KVLabel('Cancel reason'),
          SizedBox(height: 6),
          _ReasonPickerField(),
          SizedBox(height: 16),
          _KVLabel('Remarks (Optional)'),
          SizedBox(height: 6),
          _RemarksField(),
        ],
      ),
    );
  }
}

class _RemarksField extends GetView<CancelWorkOrderController> {
  const _RemarksField({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.remarksCtrl,
      minLines: 3,
      maxLines: 6,
      decoration: _D.field(hint: 'Add brief remarks for cancellation'),
    );
  }
}

/* ===================== Reason Picker (Bottom Sheet) ===================== */

class _ReasonPickerField extends GetView<CancelWorkOrderController> {
  const _ReasonPickerField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = controller.selectedCancelOrderReason.value;
      final isPlaceholder =
          sel == null || (sel.id.isEmpty && sel.displayName == 'Select reason');

      final text = isPlaceholder
          ? 'Select reason'
          : (sel.displayName.isEmpty ? '(Unnamed)' : sel.displayName);

      return InkWell(
        onTap: () => _openReasonSheet(context),
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

  void _openReasonSheet(BuildContext context) {
    final current = controller.selectedCancelOrderReason.value;
    final options = controller.cancelOrderReason
        .where((lv) => !(lv.id.isEmpty && lv.displayName == 'Select reason'))
        .toList();
    final kb = MediaQuery.of(context).viewInsets.bottom;

    Get.bottomSheet(
      isScrollControlled: true,
      SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.85,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.fromLTRB(16, 10, 16, 12 + kb),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select reason',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: _C.line),
                    itemBuilder: (ctx, i) {
                      final lv = options[i];
                      final isSelected = current?.id == lv.id;
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFF2F5FF),
                          child: Text(
                            (lv.displayName.isNotEmpty
                                    ? lv.displayName[0]
                                    : '?')
                                .toUpperCase(),
                            style: const TextStyle(
                              color: _C.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          lv.displayName.isEmpty ? '(Unnamed)' : lv.displayName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: (lv.code.isNotEmpty)
                            ? Text(
                                lv.code,
                                style: const TextStyle(
                                  color: _C.muted,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        trailing: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: _C.primary)
                              : const SizedBox(width: 24),
                        ),
                        onTap: () {
                          controller.selectedCancelOrderReason.value = lv;
                          Get.back();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
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
                        onPressed: Get.back,
                        child: const Text(
                          'Close',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}

/* ===================== Small Pieces & Styles ===================== */

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

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

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const bg = Color(0xFFF6F7FB);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);

  static const surface = Colors.white;
  static const pillRed = Color(0xFFFF4D4F);
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
