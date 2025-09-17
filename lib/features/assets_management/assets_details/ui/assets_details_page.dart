import 'package:easy_ops/features/assets_management/assets_details/controller/assets_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* ───────────────────────── Palette ───────────────────────── */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const text = Color(0xFF2D2F39);
  static const muted = Color(0xFF7C8698);
  static const line = Color(0xFFE6EBF3);
  static const card = Colors.white;
  static const chipRed = Color(0xFFEF4444);
  static const chipAmber = Color(0xFFF59E0B);
  static const chipGreen = Color(0xFF10B981);

  static const bg = Color(0xFFF6F7FB);
}

/* ───────────────────────── Page ───────────────────────── */

class AssetsDetailPage extends GetView<AssetsDetailController> {
  const AssetsDetailPage({super.key});

  @override
  AssetsDetailController get controller => Get.put(AssetsDetailController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => Text(
            controller.pageTitle.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: isTablet ? 18 : 16,
            ),
          ),
        ),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? _C.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(12, isTablet ? 14 : 10, 12, 16),
        children: const [
          _CardDashboard(),
          SizedBox(height: 10),
          _CardSpecification(),
          SizedBox(height: 10),
          _CardContact(),
          SizedBox(height: 10),
          _CardPmSchedule(),
          SizedBox(height: 10),
          _CardHistory(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

/* ───────────────────────── Reusable wrappers ───────────────────────── */

class _SectionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  final Widget child;
  const _SectionCard({required this.title, required this.child, this.onMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      height: 1.1,
                    ),
                  ),
                ),
                if (onMore != null)
                  InkWell(
                    onTap: onMore,
                    borderRadius: BorderRadius.circular(6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'View More',
                          style: TextStyle(
                            color: _C.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 14,
                          color: _C.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: _C.line),
          child,
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;
  final EdgeInsets padding;
  const _MetaChip(
    this.text, {
    this.icon,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? _C.primary;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: c),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCell extends StatelessWidget {
  final String label;
  final String value;
  const _KpiCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _C.muted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _C.primary,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── Cards ───────────────────────── */

class _CardDashboard extends GetView<AssetsDetailController> {
  const _CardDashboard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Assets Dashboard',
      onMore: () => controller.onViewMore('Assets Dashboard'),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: IntrinsicHeight(
            child: Row(
              children: [
                const SizedBox(width: 2),
                Expanded(
                  child: _KpiCell(label: 'MTBF', value: controller.mtbf.value),
                ),
                const _VSep(),
                Expanded(
                  child: _KpiCell(
                    label: 'BD Hours',
                    value: controller.bdHours.value,
                  ),
                ),
                const _VSep(),
                Expanded(
                  child: _KpiCell(label: 'MTTR', value: controller.mttr.value),
                ),
                const _VSep(),
                Expanded(
                  child: _KpiCell(
                    label: 'Criticality',
                    value: controller.criticality.value,
                  ),
                ),
                const SizedBox(width: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VSep extends StatelessWidget {
  const _VSep();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(width: 1, color: _C.line, thickness: 1);
  }
}

class _CardSpecification extends GetView<AssetsDetailController> {
  const _CardSpecification();

  Color _pillColor(String p) {
    switch (p.toLowerCase()) {
      case 'critical':
        return _C.chipRed;
      case 'medium':
      case 'semi':
      case 'semi critical':
      case 'semi-critical':
        return _C.chipAmber;
      default:
        return _C.chipGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Assets Specification',
      onMore: () => controller.onViewMore('Assets Specification'),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title + pill pinned right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(text: controller.assetName.value),
                            const TextSpan(text: '  •  '),
                            TextSpan(
                              text: controller.brand.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _C.muted,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _Pill(
                      controller.priority.value,
                      _pillColor(controller.priority.value),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  controller.description.value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _C.text, height: 1.28),
                ),
                const SizedBox(height: 8),
                _MetaChip(
                  controller.runningState.value,
                  icon: CupertinoIcons.check_mark_circled_solid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardContact extends GetView<AssetsDetailController> {
  const _CardContact();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Manufacturer Contact Info',
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            children: [
              _contactRow(
                leading: Text(
                  controller.phone.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                trailing: IconButton(
                  onPressed: controller.callPhone,
                  icon: const Icon(
                    CupertinoIcons.phone,
                    size: 18,
                    color: _C.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _contactRow(
                leading: Text(
                  controller.email.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                trailing: IconButton(
                  onPressed: controller.emailSupport,
                  icon: const Icon(
                    CupertinoIcons.envelope,
                    size: 18,
                    color: _C.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _contactRow(
                leading: Text(
                  controller.address.value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _C.text, height: 1.28),
                ),
                trailing: IconButton(
                  onPressed: controller.openMap,
                  icon: const Icon(
                    CupertinoIcons.placemark,
                    size: 18,
                    color: _C.primary,
                  ),
                ),
                alignTop: true,
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: _C.line),
              const SizedBox(height: 8),
              ...controller.hours.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      Text(
                        e.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _C.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactRow({
    required Widget leading,
    required Widget trailing,
    bool alignTop = false,
  }) {
    return Row(
      crossAxisAlignment: alignTop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Expanded(child: leading),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}

class _CardPmSchedule extends GetView<AssetsDetailController> {
  const _CardPmSchedule();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'PM Schedule',
      onMore: () => controller.onViewMore('PM Schedule'),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.pmType.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _C.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      controller.pmStatusRightTitle.value,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _C.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.pmTitle.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.w800,
                            height: 1.22,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              CupertinoIcons.time,
                              size: 14,
                              color: _C.muted,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                controller.pmWhen.value,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _C.text,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right actions
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _LinkChip(
                          label: 'View Activities',
                          onTap: controller.viewActivities,
                        ),
                        _LinkChip(
                          label: 'Propose New',
                          onTap: controller.proposeNew,
                        ),
                        _LinkChip(
                          label: 'View Check List',
                          onTap: controller.viewChecklist,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHistory extends GetView<AssetsDetailController> {
  const _CardHistory();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Assets History',
      onMore: () => controller.onViewMore('Assets History'),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // chips (wrap safely)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _MetaChip(
                    controller.histDate.value,
                    icon: CupertinoIcons.calendar,
                  ),
                  _MetaChip(
                    controller.histType.value,
                    icon: CupertinoIcons.tag,
                  ),
                  _MetaChip(
                    controller.histDept.value,
                    icon: CupertinoIcons.building_2_fill,
                  ), // ✅ valid icon
                ],
              ),
              const SizedBox(height: 8),
              Text(
                controller.histText.value,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _C.text, height: 1.28),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 14,
                    color: _C.muted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      controller.histUser.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _C.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.time, size: 14, color: _C.muted),
                  const SizedBox(width: 4),
                  Text(
                    controller.histDuration.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _C.muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── Small UI helpers ───────────────────────── */

class _LinkChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkChip({required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(color: _C.primary.withOpacity(0.28)),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.link, size: 13, color: _C.primary),
              const SizedBox(width: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _C.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
