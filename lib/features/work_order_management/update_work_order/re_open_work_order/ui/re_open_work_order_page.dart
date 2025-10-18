import 'package:easy_ops/features/work_order_management/update_work_order/re_open_work_order/controller/re_open_work_order_controller.dart';
import 'package:easy_ops/core/utils/loading_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReopenWorkOrderPage extends GetView<ReopenWorkOrderController> {
  const ReopenWorkOrderPage({super.key});

  @override
  ReopenWorkOrderController get controller =>
      Get.put(ReopenWorkOrderController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final hPad = isTablet ? 20.0 : 16.0;
    final btnH = isTablet ? 56.0 : 52.0;

    return Scaffold(
      backgroundColor: _C.bg,
      resizeToAvoidBottomInset: true,
      appBar: _HeaderAppBar(isTablet: isTablet, title: 'Re-Open Work Order'),
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
            final busy = controller.isUploading.value;
            return Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(CupertinoIcons.clear),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(btnH),
                      backgroundColor: _C.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1.5,
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
                    icon: const Icon(CupertinoIcons.arrow_turn_up_right),
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
                            //if (!controller.validate()) return;
                            await Get.showOverlay(
                              opacity: 0.35,
                              loadingWidget: const LoadingOverlay(
                                message: 'Re-opening Work Order...',
                              ),
                              asyncFunction: () => controller.reOpenWorkOrder(),
                            );
                          },
                    label: const Text(
                      'Re-Open',
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
        final kb = MediaQuery.of(context).viewInsets.bottom;
        final busy = controller.isUploading.value;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24 + kb),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  _IssueHeaderCard(),
                  SizedBox(height: 12),
                  _FormCard(),
                  SizedBox(height: 90),
                ],
              ),
            ),
            if (busy)
              const LoadingOverlay(
                message: 'Please wait...',
              ),
          ],
        );
      }),
    );
  }
}

/* ===================== AppBar (center title, overflow-safe) ===================== */

class _HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTablet;
  final String title;
  const _HeaderAppBar({required this.isTablet, required this.title});

  @override
  Size get preferredSize => Size.fromHeight(isTablet ? 92 : 84);

  @override
  Widget build(BuildContext context) {
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
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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

/* ===================== Summary Card ===================== */

class _IssueHeaderCard extends GetView<ReopenWorkOrderController> {
  const _IssueHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

/* ===================== Form Card ===================== */

class _FormCard extends GetView<ReopenWorkOrderController> {
  const _FormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'Re-Open Details',
            icon: CupertinoIcons.doc_text_fill,
          ),
          const SizedBox(height: 10),

          // Reason (picker opens bottom sheet; bound to cancelOrderReason)
          const _KVLabel('Reason'),
          const SizedBox(height: 6),
          _TapField(
            textObs: controller.selectedReason,
            placeholder: 'Select',
            onTap: () => _openReasonSheet(context),
          ),
          const SizedBox(height: 14),

          // Remark
          const _KVLabel('Remark (Optional)'),
          const SizedBox(height: 6),
          TextField(
            controller: controller.remarkCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: _D.field(hint: 'Add a brief context for reopening...'),
          ),
        ],
      ),
    );
  }

  /// Bottom sheet that shows reasons from controller.cancelOrderReason
  /// Bottom sheet that shows reasons from controller.cancelOrderReason
  Future<void> _openReasonSheet(BuildContext context) async {
    final kb = MediaQuery.of(context).viewInsets.bottom;

    // Build a static snapshot for the sheet (no Obx needed here)
    final options = controller.cancelOrderReason
        .where((lv) => !(lv.id.isEmpty && lv.displayName == 'Select reason'))
        .toList();

    // Current selection snapshot (for one-time highlight)
    final currentSel = controller.selectedCancelOrderReason.value;

    await showModalBottomSheet<void>(
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
            child: Column(
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
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Reason',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _C.text,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: _C.line),

                // Plain ListView (no Obx!)
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFF2F5FA)),
                    itemBuilder: (_, i) {
                      final lv = options[i];
                      final display =
                          lv.displayName.isEmpty ? '(Unnamed)' : lv.displayName;
                      final isSel = currentSel?.id == lv.id;

                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFF2F5FF),
                          child: Text(
                            display[0].toUpperCase(),
                            style: const TextStyle(
                              color: _C.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          display,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: (lv.code.isNotEmpty)
                            ? Text(lv.code,
                                style: const TextStyle(
                                    color: _C.muted, fontSize: 12))
                            : null,
                        trailing: isSel
                            ? const Icon(Icons.check_circle, color: _C.primary)
                            : const SizedBox(width: 24),
                        onTap: () {
                          // Update reactive values, then close.
                          controller.selectedCancelOrderReason.value = lv;
                          controller.selectedReason.value =
                              display; // field text
                          Get.back();
                        },
                      );
                    },
                  ),
                ),

                const Divider(height: 1, color: _C.line),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          onPressed: Get.back,
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
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== Small Pieces ===================== */

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

/* ===================== Styles ===================== */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const bg = Color(0xFFF6F7FB);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
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

Color _priorityColor(String s) {
  switch (s.toLowerCase()) {
    case 'high':
      return const Color(0xFFEF4444);
    case 'medium':
      return const Color(0xFFF59E0B);
    case 'low':
      return const Color(0xFF10B981);
    default:
      return const Color(0xFF9CA3AF);
  }
}
