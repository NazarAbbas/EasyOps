// maintenance_engineer_closure_page.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/controller/general_pending_activity_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/controller/general_rca_analysis_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure/controller/closure_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/reusable_components/lookup_picker.dart';
import 'package:easy_ops/features/reusable_components/work_order_top_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class MaintenanceEngineerClosurePage
    extends GetView<MaintenanceEnginnerClosureController> {
  const MaintenanceEngineerClosurePage({super.key});

  @override
  MaintenanceEnginnerClosureController get controller =>
      Get.put(MaintenanceEnginnerClosureController());

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Closure',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Obx(() {
        final boot = controller.isBootstrapping.value;
        final submit = controller.isSubmitting.value;
        final wo = controller.workOrderInfo;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                children: [
                  if (boot)
                    const _SkeletonTile()
                  else if (wo != null)
                    WorkOrderTile(
                      workOrderInfo: wo,
                      onTap: () => debugPrint('Open work order'),
                    )
                  else
                    const _ErrorTile(message: 'No work order found'),
                  const SizedBox(height: 12),
                  const _ClosureCommentsCard(),
                  const SizedBox(height: 12),
                  const _SparesConsumedCard(),
                  const SizedBox(height: 12),
                  const _RcaCard(),
                  const SizedBox(height: 12),
                  const _PendingActivityCard(),
                ],
              ),
            ),
            if (boot || submit)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        );
      }),
      bottomNavigationBar: _BottomBar(onResolve: controller.resolveWorkOrder),
    );
  }
}

/* ─────────────────────── BOTTOM BAR ─────────────────────── */

class _BottomBar extends GetView<MaintenanceEnginnerClosureController> {
  final VoidCallback onResolve;
  const _BottomBar({required this.onResolve});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            // Popup trigger styled like enabled button
            Expanded(
              child: PopupMenuButton<String>(
                onSelected: (v) => Get.snackbar('Action', v),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'Hold Work Order',
                    child: Text('Hold Work Order'),
                  ),
                  PopupMenuItem(
                    value: 'Reassign Work Order',
                    child: Text('Reassign Work Order'),
                  ),
                  PopupMenuItem(
                    value: 'Cancel Work Order',
                    child: Text('Cancel Work Order'),
                  ),
                ],
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Other Options',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        SizedBox(width: 6),
                        Icon(CupertinoIcons.chevron_up, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                final loading = controller.isSubmitting.value;
                return FilledButton(
                  onPressed: loading ? null : onResolve,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 1.5,
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Resolve Work Order',
                          style: TextStyle(fontWeight: FontWeight.w800),
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

/* ───────────── Closure Comments (form + signature) ───────────── */
class _SoftCard extends StatelessWidget {
  final Widget child;
  const _SoftCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9EEF5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: child,
        ),
      );
}

class _ClosureCommentsCard
    extends GetView<MaintenanceEnginnerClosureController> {
  const _ClosureCommentsCard();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Closure Comments'),
          const SizedBox(height: 12),
          const Text(
            'Resolution Type',
            style: TextStyle(color: _C.muted, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Obx(() {
            final label = controller.selectedReasonValue.value.trim();

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final v = await LookupPicker.show(
                  context: context,
                  lookupType: LookupType.resolution.name,
                  selected: controller.selectedReason.value,
                );
                if (v != null) {
                  controller.selectedReason.value = v;
                  controller.selectedReasonValue.value = v.displayName;
                }
              },
              child: InputDecorator(
                isEmpty: label.isEmpty,
                decoration: _borderInputDecoration().copyWith(
                  hintText: 'Select resolution type',
                  suffixIcon: const Icon(CupertinoIcons.chevron_down, size: 18),
                ),
                child: Text(
                  label.isEmpty ? 'Select resolution type' : label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            );
          }),
          const SizedBox(height: 14),
          const Text(
            'Add Note (Optional)',
            style: TextStyle(color: _C.muted, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.noteController,
            maxLines: 4,
            decoration:
                _borderInputDecoration().copyWith(hintText: 'Type here...'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Signature',
            style: TextStyle(color: _C.muted, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const _SignaturePad(),
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
        ],
      ),
    );
  }
}

class _SignaturePad extends GetView<MaintenanceEnginnerClosureController> {
  const _SignaturePad();

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
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

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
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}

/* ───────────── Spares Consumed (accordion) ───────────── */

class _SparesConsumedCard
    extends GetView<MaintenanceEnginnerClosureController> {
  const _SparesConsumedCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final open = controller.sparesOpen.value;
      final totalNos = controller.sparesConsumedNos.value;
      final totalCost = controller.sparesConsumedCost.value;

      return _SoftCard(
        child: Column(
          children: [
            _AccordionHeader(
              title: 'Spares Consumed',
              subtitle: '($totalNos nos | ₹ $totalCost)',
              open: open,
              onToggle: controller.sparesOpen.toggle,
            ),
            AnimatedCrossFade(
              crossFadeState:
                  open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 180),
              firstChild: Column(
                children: [
                  const Divider(color: _C.line, height: 20),
                  _KVRow(
                    leftTitle: 'Spares Consumed',
                    leftValue: '${controller.sparesConsumedNos.value} nos',
                    rightTitle: 'Cost',
                    rightValue: '₹ ${controller.sparesConsumedCost.value}',
                  ),
                  const SizedBox(height: 12),
                  _KVRow(
                    leftTitle: 'Spares Issued',
                    leftValue: '${controller.sparesIssuedNos.value} nos',
                    rightTitle: 'Cost',
                    rightValue: '₹ ${controller.sparesIssuedCost.value}',
                  ),
                  const SizedBox(height: 12),
                  _KVRow(
                    leftTitle: 'Spares to be Returned',
                    leftValue: '${controller.sparesToReturnNosTotal} nos',
                    rightTitle: 'Cost',
                    rightValue: controller.sparesToReturnCostTotal == 0
                        ? '₹ -'
                        : '₹ ${controller.sparesToReturnCostTotal}',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Need to return spares?',
                          style: TextStyle(
                            color: _C.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _IconChip(
                        icon: CupertinoIcons.wrench_fill,
                        bg: const Color(0xFFEFF4FF),
                        fg: _C.primary,
                        onTap: () async {
                          final res = await Get.toNamed(
                            Routes.maintenanceEngeneerreturnSpareScreen,
                            arguments: List<SpareReturnItem>.from(
                              controller.sparesToReturn,
                            ),
                          );

                          if (res is List<SpareReturnItem>) {
                            controller.sparesToReturn.assignAll(res);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }
}

/* ───────────── RCA Summary (accordion) ───────────── */

class _RcaCard extends GetView<MaintenanceEnginnerClosureController> {
  const _RcaCard();

  String? _safeAt(List<String>? list, int i) =>
      (list != null && i >= 0 && i < list.length && list[i].trim().isNotEmpty)
          ? list[i].trim()
          : null;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final open = controller.rcaOpen.value;
      final r = controller.rcaResult.value; // may be null

      return _SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccordionHeader(
              title: 'Root Cause Analysis (Summary)',
              open: open,
              onToggle: controller.rcaOpen.toggle,
            ),
            AnimatedCrossFade(
              crossFadeState:
                  open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 180),
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RcaLine('Problem Identified', r?.problemIdentified),
                    const SizedBox(height: 10),
                    _RcaLine('Why 1', _safeAt(r?.fiveWhys, 0)),
                    const SizedBox(height: 10),
                    _RcaLine('Why 2', _safeAt(r?.fiveWhys, 1)),
                    const SizedBox(height: 10),
                    _RcaLine('Why 3', _safeAt(r?.fiveWhys, 2)),
                    const SizedBox(height: 10),
                    _RcaLine('Why 4', _safeAt(r?.fiveWhys, 3)),
                    const SizedBox(height: 10),
                    _RcaLine('Why 5', _safeAt(r?.fiveWhys, 4)),
                    const SizedBox(height: 10),
                    _RcaLine('Root Cause Identified', r?.rootCause),
                    const SizedBox(height: 10),
                    _RcaLine('Corrective Action', r?.correctiveAction),
                    const SizedBox(height: 16),
                    const _EnterRowRCA(
                      text: 'Enter Root Cause Analysis',
                      icon: CupertinoIcons.search,
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }
}

class _RcaLine extends StatelessWidget {
  final String title;
  final String? value;
  final String placeholder;

  const _RcaLine(
    this.title,
    this.value, {
    this.placeholder = '-',
  });

  @override
  Widget build(BuildContext context) {
    final display = (value?.trim().isNotEmpty ?? false) ? value! : placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: _C.text, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(display, style: const TextStyle(color: _C.text)),
      ],
    );
  }
}

/* ───────────── Pending Activity (accordion) ───────────── */

class _PendingActivityCard
    extends GetView<MaintenanceEnginnerClosureController> {
  const _PendingActivityCard();

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final open = controller.pendingOpen.value;
      final items = controller.pendingActivities;
      final count = items.length;

      return _SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccordionHeader(
              title: 'Pending Activity',
              subtitle: '$count Identified',
              open: open,
              onToggle: controller.pendingOpen.toggle,
            ),
            AnimatedCrossFade(
              crossFadeState:
                  open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 180),
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    const _PendingActivity(
                      text: 'Add activity',
                      icon: CupertinoIcons.list_bullet_below_rectangle,
                    ),
                    const SizedBox(height: 10),
                    if (count == 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No activities yet. Tap "Add activity" to create one.',
                          style: TextStyle(color: _C.muted, fontSize: 12),
                        ),
                      )
                    else
                      Column(
                        children: items.map((it) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE9EEF5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title + status
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        it.title,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      it.status,
                                      style: const TextStyle(
                                        color: _C.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // ID + date + assignee
                                Row(
                                  children: [
                                    Text(
                                      it.id,
                                      style: const TextStyle(
                                        color: _C.muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (it.targetDate != null) ...[
                                      const Icon(
                                        CupertinoIcons.calendar,
                                        size: 14,
                                        color: _C.muted,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _fmtDate(it.targetDate!),
                                        style: const TextStyle(
                                          color: _C.muted,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    const Icon(
                                      CupertinoIcons.person,
                                      size: 14,
                                      color: _C.muted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      it.assignee ?? 'Unassigned',
                                      style: const TextStyle(
                                        color: _C.muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                if ((it.note ?? '').isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(it.note!,
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }
}

/* ─────────────────────── SMALL PARTS ─────────────────────── */

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(CupertinoIcons.doc_plaintext, size: 16, color: _C.muted),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF3C4354),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
}

class _EnterRowRCA extends GetView<MaintenanceEnginnerClosureController> {
  final String text;
  final IconData icon;
  const _EnterRowRCA({required this.text, required this.icon});
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _C.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _IconChip(
            icon: icon,
            bg: const Color(0xFFEFF4FF),
            fg: _C.primary,
            onTap: () async {
              final res = await Get.toNamed(
                Routes.maintenanceEngeneerrcaAnalysisScreen,
                arguments: controller.rcaResult.value,
              );

              if (res is RcaResult) {
                controller.rcaResult.value = res;
              }
            },
          ),
        ],
      );
}

class _PendingActivity extends GetView<MaintenanceEnginnerClosureController> {
  final String text;
  final IconData icon;
  const _PendingActivity({required this.text, required this.icon});
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _C.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _IconChip(
            icon: icon,
            bg: const Color(0xFFEFF4FF),
            fg: _C.primary,
            onTap: () async {
              final res = await Get.toNamed(
                Routes.maintenanceEngeneerpendingActivityScreen,
                arguments: PendingActivityArgs(
                  initial:
                      List<ActivityItem>.from(controller.pendingActivities),
                ),
              );

              if (res is PendingActivityResult &&
                  res.action == PendingActivityAction.back) {
                controller.pendingActivities.assignAll(res.activities);
              }
            },
          ),
        ],
      );
}

class _KVRow extends StatelessWidget {
  final String leftTitle;
  final String leftValue;
  final String rightTitle;
  final String rightValue;
  const _KVRow({
    required this.leftTitle,
    required this.leftValue,
    required this.rightTitle,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(color: _C.muted, fontWeight: FontWeight.w700);
    const valueStyle = TextStyle(color: _C.text, fontWeight: FontWeight.w800);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(leftTitle, style: titleStyle),
              const SizedBox(height: 4),
              Text(leftValue, style: valueStyle),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(rightTitle, style: titleStyle),
            const SizedBox(height: 4),
            Text(rightValue, style: valueStyle),
          ],
        ),
      ],
    );
  }
}

class _IconChip extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;
  final double dimension;
  final double iconSize;
  final String? tooltip;

  const _IconChip({
    required this.icon,
    required this.bg,
    required this.fg,
    this.onTap,
    this.dimension = 48,
    this.iconSize = 22,
    this.tooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final content = Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(color: bg, borderRadius: radius),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: fg),
    );
    final child =
        tooltip == null ? content : Tooltip(message: tooltip!, child: content);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: child,
      ),
    );
  }
}

class _AccordionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool open;
  final VoidCallback onToggle;

  const _AccordionHeader({
    required this.title,
    this.subtitle,
    required this.open,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          color: _C.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedRotation(
              duration: const Duration(milliseconds: 180),
              turns: open ? 0.5 : 0.0,
              child: const Icon(
                CupertinoIcons.chevron_down,
                size: 18,
                color: _C.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────── Signature Box (optional preview widget) ───────────── */

class _SignatureBox extends StatelessWidget {
  final Uint8List? bytes;
  const _SignatureBox({this.bytes});

  @override
  Widget build(BuildContext context) {
    final border = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(10),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 120,
      decoration: border,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: bytes == null
              ? const Text('Signature', style: TextStyle(color: _C.muted))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    clipBehavior: Clip.hardEdge,
                    child: Image.memory(bytes!, gaplessPlayback: true),
                  ),
                ),
        ),
      ),
    );
  }
}

/* ─────────────────────── THEME & INPUT ─────────────────────── */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
}

InputDecoration _borderInputDecoration() => InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.primary, width: 1.2),
      ),
    );

/* ───────────── Small placeholders ───────────── */

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();
  @override
  Widget build(BuildContext context) => Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EEF5)),
        ),
        child: const Center(
          child: Text('Loading work order…', style: TextStyle(color: _C.muted)),
        ),
      );
}

class _ErrorTile extends StatelessWidget {
  final String message;
  const _ErrorTile({required this.message});
  @override
  Widget build(BuildContext context) => Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EEF5)),
        ),
        child: Center(
          child: Text(message, style: const TextStyle(color: _C.muted)),
        ),
      );
}
