import 'package:easy_ops/ui/modules/work_order_management/create_work_order/work_order_detail/controller/work_order_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Thumb;
import 'package:get/get.dart';

class WorkOrderDetailsPage extends GetView<WorkOrderDetailsController> {
  const WorkOrderDetailsPage({super.key});

  @override
  WorkOrderDetailsController get controller =>
      Get.put(WorkOrderDetailsController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double headerH = isTablet ? 120 : 110;
    final double hPad = isTablet ? 18 : 14;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(headerH),
        child: _GradientHeader(
          title: controller.title.value,
          isTablet: isTablet,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE9EEF5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SuccessBanner(
                    title: controller.successTitle.value,
                    sub: controller.successSub.value,
                  ),
                  const SizedBox(height: 12),

                  _KVBlock(
                    rows: [
                      _KV(
                        label: 'Reported By :',
                        value: controller.reportedBy.value,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _KVBlock(
                    rows: [
                      _KV(
                        label: 'Operator :',
                        value: controller.operatorName.value,
                      ),
                      _KV(label: '', value: controller.operatorPhone.value),
                      _KV(label: '', value: controller.operatorOrg.value),
                    ],
                  ),

                  const _DividerPad(),

                  // Issue summary + pill + category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.issueSummary.value,
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const _Pill(text: 'High', color: Color(0xFFEF4444)),
                          const SizedBox(height: 6),
                          Text(
                            controller.category.value,
                            style: const TextStyle(
                              color: _C.muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Time | Date
                  Row(
                    children: [
                      Text(
                        '${controller.time.value} | ${controller.date.value}',
                        style: const TextStyle(
                          color: _C.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Line
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        size: 14,
                        color: Color(0xFFE25555),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          controller.line.value,
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Text(
                    controller.location.value,
                    style: const TextStyle(
                      color: _C.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const _DividerPad(),

                  // Headline
                  Text(
                    controller.headline.value,
                    style: const TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    controller.description.value,
                    style: const TextStyle(color: _C.text, height: 1.35),
                  ),
                  const SizedBox(height: 12),

                  // Media row
                  Row(
                    children: [
                      // thumbnails
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: controller.thumbs
                              .map((c) => _Thumb(color: c))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const _AudioTile(),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
          child: SizedBox(
            height: isTablet ? 56 : 52,
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _C.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: controller.goToListing,
              child: const Text(
                'Go to Work Order Listing',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── Widgets ───────────────────────── */

class _GradientHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isTablet;
  const _GradientHeader({required this.title, required this.isTablet});

  @override
  Size get preferredSize => Size.fromHeight(isTablet ? 120 : 110);

  @override
  Widget build(BuildContext context) {
    final btnSize = isTablet ? 48.0 : 44.0;
    final iconSize = isTablet ? 26.0 : 22.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2F6BFF), Color(0xFF3F84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(12, isTablet ? 12 : 10, 12, 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            SizedBox(
              width: btnSize,
              height: btnSize,
              child: IconButton(
                onPressed: Get.back,
                iconSize: iconSize,
                splashRadius: btnSize / 2,
                icon: const Icon(CupertinoIcons.back, color: Colors.white),
                tooltip: 'Back',
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: isTablet ? 20 : 18,
                ),
              ),
            ),
            SizedBox(width: btnSize, height: btnSize),
          ],
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final String title;
  final String sub;
  const _SuccessBanner({required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E8A3B), Color(0xFF0A6A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFBFEBCB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.black87, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KV {
  final String label;
  final String value;
  const _KV({required this.label, required this.value});
}

class _KVBlock extends StatelessWidget {
  final List<_KV> rows;
  const _KVBlock({required this.rows});

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(color: _C.muted, fontWeight: FontWeight.w800);
    const valueStyle = TextStyle(color: _C.text, fontWeight: FontWeight.w800);

    return Column(
      children: rows
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.label.isNotEmpty) ...[
                    Text(e.label, style: labelStyle),
                    const SizedBox(width: 6),
                  ],
                  Expanded(child: Text(e.value, style: valueStyle)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DividerPad extends StatelessWidget {
  const _DividerPad();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: _C.line, height: 1),
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
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final Color color;
  const _Thumb({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        image: null, // replace with DecorationImage for real photos
      ),
    );
  }
}

class _AudioTile extends StatelessWidget {
  const _AudioTile();
  @override
  Widget build(BuildContext context) {
    const blue = _C.primary;
    return Container(
      width: 88,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(CupertinoIcons.play_fill, color: blue, size: 28),
          Positioned(
            bottom: 6,
            right: 8,
            child: Text(
              '00:20',
              style: TextStyle(
                color: blue,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────── Style ───────────────────────── */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
}
