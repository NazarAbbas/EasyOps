/* ───────── Page ───────── */
import 'dart:ui';

import 'package:easy_ops/features/cancel_work_order/controller/cancel_work_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelWorkOrderPage extends GetView<CancelWorkOrderController> {
  const CancelWorkOrderPage({super.key});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final hPad = isTablet ? 20.0 : 14.0;

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Cancel Work Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
        children: [
          const _AssetCard(),
          const SizedBox(height: 14),
          _FormCard(isTablet: isTablet),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
          child: SizedBox(
            height: isTablet ? 56 : 52,
            child: Row(
              children: [
                // Left: Discard (outlined)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.primary,
                      side: const BorderSide(color: _C.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.discard,
                    child: const Text(
                      'Discard',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Right: Cancel Work Order (filled)
                Expanded(
                  child: Obx(() {
                    final busy = controller.isSubmitting.value;
                    return FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _C.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: busy ? null : controller.cancelWorkOrder,
                      child: busy
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
                              style: TextStyle(fontSize: 12),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────── Widgets ───────── */

class _AssetCard extends GetView<CancelWorkOrderController> {
  const _AssetCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final a = controller.asset.value;
      return Container(
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.primary.withOpacity(.35), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CNC-1 | Siemens
                  Row(
                    children: [
                      Text(
                        a.code,
                        style: const TextStyle(
                          color: _C.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        '  |  ',
                        style: TextStyle(
                          color: _C.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        a.make,
                        style: const TextStyle(
                          color: _C.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a.description,
                    style: const TextStyle(color: _C.text, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {}, // optional: status tap
                    child: const Text(
                      'Working',
                      style: TextStyle(
                        color: _C.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right: pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _C.pillRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Critical',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _FormCard extends GetView<CancelWorkOrderController> {
  const _FormCard({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: _C.muted,
      fontWeight: FontWeight.w600,
      fontSize: isTablet ? 15 : 14,
    );

    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reason
          Text('Reason', style: labelStyle),
          const SizedBox(height: 6),
          Obx(() {
            final selected = controller.selectedReason.value;
            return DropdownButtonFormField<String>(
              value: selected,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Select',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _C.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _C.border),
                ),
              ),
              items: controller.reasons
                  .map(
                    (r) => DropdownMenuItem<String>(
                      value: r,
                      child: Text(r, style: const TextStyle(color: _C.text)),
                    ),
                  )
                  .toList(),
              onChanged: (val) => controller.selectedReason.value = val,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
            );
          }),

          const SizedBox(height: 16),

          // Remarks
          Text('Remarks (Optional)', style: labelStyle),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.remarksCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Type here',
              contentPadding: const EdgeInsets.all(12),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _C.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _C.border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────── Palette ───────── */
class _C {
  static const primary = Color(0xFF2F6BFF);
  static const bg = Color(0xFFF6F7FB);
  static const surface = Colors.white;
  static const border = Color(0xFFE1E7F2);
  static const text = Color(0xFF2D2F39);
  static const muted = Color(0xFF7C8698);
  static const pillRed = Color(0xFFFF4D4F);
}
