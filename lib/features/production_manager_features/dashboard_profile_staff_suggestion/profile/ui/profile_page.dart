import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final primary = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Obx(() {
          final p = c.profile.value;
          if (p == null) return const _ProfileLoading();

          final next = c.nextUpcomingHoliday;

          // Flatten + sort holidays for timeline and for count
          final items = [...c.holidayList]..sort((a, b) {
              final ad = a.holidayDate ?? DateTime(1900);
              final bd = b.holidayDate ?? DateTime(1900);
              return ad.compareTo(bd);
            });

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              children: [
                _AvatarBlock(imageUrl: p.avatarUrl, onEdit: c.onEditAvatar),
                const SizedBox(height: 16),

                // ----- My Info -----
                const _SectionTitle('My Info'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _InfoRow(label: 'Name', value: p.displayName),
                    _InfoRow(label: 'Age', value: '${p.age}'),
                    _InfoRow(label: 'Blood Group', value: p.bloodGroup),
                    _InfoRow(
                      label: 'Phone No',
                      value: p.phone,
                      trailing: IconButton(
                        icon: const Icon(Icons.call,
                            size: 18, color: Color(0xFF2F6BFF)),
                        onPressed: () => c.callNumber(p.phone),
                        tooltip: 'Call',
                      ),
                    ),
                    _InfoRow(
                      label: 'Email',
                      value: p.email,
                      trailing: IconButton(
                        icon: const Icon(Icons.email_outlined,
                            size: 18, color: Color(0xFF2F6BFF)),
                        onPressed: () => c.sendEmail(p.email),
                        tooltip: 'Email',
                      ),
                    ),
                    _InfoRow(label: 'Department', value: p.department),
                    _InfoRow(
                      label: 'Supervisor',
                      value: p.supervisorName,
                      trailing: IconButton(
                        icon: const Icon(Icons.call,
                            size: 18, color: Color(0xFF2F6BFF)),
                        onPressed: () => c.callNumber(p.supervisorPhone),
                        tooltip: 'Call Supervisor',
                      ),
                    ),
                    _InfoRow(label: 'Location', value: p.location),
                  ],
                ),
                const SizedBox(height: 16),

                // ----- Emergency Personal Contact -----
                const _SectionTitle('Emergency Personal Contact'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _InfoRow(label: 'Name', value: p.emergencyName),
                    _InfoRow(
                      label: 'Phone No',
                      value: p.emergencyPhone,
                      trailing: IconButton(
                        icon: const Icon(Icons.call,
                            size: 18, color: Color(0xFF2F6BFF)),
                        onPressed: () => c.callNumber(p.emergencyPhone),
                        tooltip: 'Call',
                      ),
                    ),
                    _InfoRow(
                      label: 'Email',
                      value: p.emergencyEmail,
                      trailing: IconButton(
                        icon: const Icon(Icons.email_outlined,
                            size: 18, color: Color(0xFF2F6BFF)),
                        onPressed: () => c.sendEmail(p.emergencyEmail),
                        tooltip: 'Email',
                      ),
                    ),
                    _InfoRow(
                        label: 'Relationship', value: p.emergencyRelationship),
                  ],
                ),
                const SizedBox(height: 12),

                // ----- Emergency list -----
                _CollapsedRow(
                  title: 'Emergency Contact',
                  subtitle: '${c.contactList.length} Contacts',
                  expanded: c.emergencyExpanded,
                  onTap: () => c.emergencyExpanded.toggle(),
                  child: Obx(() {
                    if (c.contactList.isEmpty) {
                      return const _MiniLine('No contacts found');
                    }
                    return Column(
                      children: c.contactList.map((e) {
                        final name = (e.name?.trim().isNotEmpty ?? false)
                            ? e.name!.trim()
                            : (e.label ?? 'Contact');
                        final phone = (e.phone?.trim().isNotEmpty ?? false)
                            ? e.phone!.trim()
                            : '—';
                        return _MiniContact(
                          name: name,
                          phone: phone,
                          onCall: () => c.callNumber(e.phone ?? ''),
                        );
                      }).toList(),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // ===== Holidays (Timeline, no calendar) =====
                _RowTitleWithCount(
                    title: 'Holiday Calendar', count: items.length),
                const SizedBox(height: 8),

                if (next != null)
                  _UpcomingHolidayBanner(
                    title: next.holidayName,
                    date: next.holidayDate,
                  ),

                if (items.isEmpty)
                  const _EmptyHolidays()
                else
                  _HolidayTimeline(items: items),

                const SizedBox(height: 20),

                // Log out
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE34B3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1.5,
                    ),
                    onPressed: c.logout,
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Log Out',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

//
// ===== Holidays: Timeline widgets (overflow-safe) =====
//

class _HolidayTimeline extends StatelessWidget {
  final List<dynamic> items; // List<OrganizationHoliday>
  const _HolidayTimeline({required this.items});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE9EEF5)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: -2,
              offset: Offset(0, 4),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Column(
          children: List.generate(items.length, (i) {
            final h = items[i];
            // Normalize to local, date-only here:
            final raw = h.holidayDate as DateTime?;
            final d = _localDateOnly(raw);

            final name = (h.holidayName?.trim().isNotEmpty ?? false)
                ? h.holidayName!.trim()
                : 'Holiday';

            final today = DateTime.now();
            final isPast = d != null
                ? DateTime(d.year, d.month, d.day)
                    .isBefore(DateTime(today.year, today.month, today.day))
                : false;

            return _TimelineRow(
              isFirst: i == 0,
              isLast: i == items.length - 1,
              date: d,
              title: name,
              isPast: isPast,
            );
          }),
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final DateTime? date;
  final String title;
  final bool isPast;

  const _TimelineRow({
    required this.isFirst,
    required this.isLast,
    required this.date,
    required this.title,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // tiny vertical padding ensures line doesn’t touch container edges
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Date Pill (fixed width, won’t overflow)
            SizedBox(width: 68, child: _DatePill(date: date)),

            // Middle: line + dot (stretches to full height)
            SizedBox(
              width: 26,
              child: Column(
                children: [
                  if (isFirst)
                    const SizedBox.shrink()
                  else
                    Expanded(
                      child:
                          Container(width: 2, color: const Color(0xFFE9EEF5)),
                    ),

                  // dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isPast
                          ? const Color(0xFF97A3B6)
                          : const Color(0xFF2F6BFF),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                  ),

                  if (isLast)
                    const SizedBox.shrink()
                  else
                    Expanded(
                      child:
                          Container(width: 2, color: const Color(0xFFE9EEF5)),
                    ),
                ],
              ),
            ),

            // Right: Card (expanded; text ellipsized to avoid right overflow)
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9EEF5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title safe against right overflow
                    Text(
                      title,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isPast
                            ? const Color(0xFF7C8698)
                            : const Color(0xFF2D2F39),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 12,
                            color: isPast
                                ? const Color(0xFF97A3B6)
                                : const Color(0xFF2F6BFF)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _weekdayDate(date),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isPast
                                  ? const Color(0xFF97A3B6)
                                  : const Color(0xFF2F6BFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RelativeChip(date: date),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayDate(DateTime? d) {
    if (d == null) return '—';
    const wk = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final w = wk[d.weekday - 1];
    final dd = d.day.toString().padLeft(2, '0');
    final mmm = _mmm[d.month - 1];
    return '$w, $dd $mmm ${d.year}';
  }
}

class _DatePill extends StatelessWidget {
  final DateTime? date;
  final double width;
  final double height;

  const _DatePill({
    required this.date,
    this.width = 62,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDEE8FF)),
        ),
        alignment: Alignment.center,
        child: const Text(
          '—',
          style: TextStyle(
            color: Color(0xFF2F6BFF),
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    // normalize here so month/day never shift due to timezone
    final raw = date!;
    final d = _localDateOnly(raw)!; // safe because raw != null
    final dd = d.day.toString().padLeft(2, '0');
    final mmm = _mmm[d.month - 1];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF2FF), Color(0xFFDDE8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDEE8FF)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dd,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2F6BFF),
            ),
          ),
          Text(
            mmm,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F6BFF),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelativeChip extends StatelessWidget {
  final DateTime? date;
  const _RelativeChip({required this.date});

  @override
  Widget build(BuildContext context) {
    final label = _relativeText(date);
    final isPast = _isPast(date);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isPast ? const Color(0xFFF2F4F8) : const Color(0xFFEDF3FF),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isPast ? const Color(0xFFE0E6EF) : const Color(0xFFDEE8FF),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPast ? const Color(0xFF7C8698) : const Color(0xFF2F6BFF),
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
        ),
      ),
    );
  }

  bool _isPast(DateTime? d) {
    if (d == null) return false;
    final a = DateTime(d.year, d.month, d.day);
    final now = DateTime.now();
    final b = DateTime(now.year, now.month, now.day);
    return a.isBefore(b);
  }

  String _relativeText(DateTime? d) {
    if (d == null) return '—';
    final now = DateTime.now();
    final a = DateTime(d.year, d.month, d.day);
    final b = DateTime(now.year, now.month, now.day);
    final diff = a.difference(b).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 1) return 'In $diff days';
    return '${diff.abs()} days ago';
  }
}

class _UpcomingHolidayBanner extends StatelessWidget {
  final String? title;
  final DateTime? date;
  const _UpcomingHolidayBanner({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    final name = (title?.trim().isNotEmpty ?? false)
        ? title!.trim()
        : 'Upcoming Holiday';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F6BFF), Color(0xFF6E8BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _DatePill(date: date),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(Icons.celebration, color: Colors.white, size: 22),
        ],
      ),
    );
  }
}

//
// ===== Loading =====
//

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      children: const [
        _ShimmerBox(width: 104, height: 104, radius: 100),
        SizedBox(height: 20),
        _ShimmerLine(),
        SizedBox(height: 12),
        _ShimmerCard(lines: 6),
        SizedBox(height: 16),
        _ShimmerLine(),
        SizedBox(height: 12),
        _ShimmerCard(lines: 4),
      ],
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final int lines;
  const _ShimmerCard({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Column(
        children: List.generate(lines, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i == lines - 1 ? 0 : 10),
            child: const _ShimmerLine(),
          );
        }),
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerBox(width: double.infinity, height: 14, radius: 6);
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FA),
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF3FA), Color(0xFFF7F9FD), Color(0xFFEFF3FA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.5, 0.8],
        ),
      ),
    );
  }
}

//
// ===== Shared/general widgets from your original =====
//

class _AvatarBlock extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEdit;
  const _AvatarBlock({required this.imageUrl, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    const double size = 104;
    const double radius = 100;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius - 1),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEAF2FF),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF2F6BFF),
                    size: 44,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Material(
              color: const Color(0xFF2F6BFF),
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onEdit,
                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E8F0), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7A8494),
              letterSpacing: 0.3,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E8F0), thickness: 1)),
      ],
    );
  }
}

/// Title + count chip (used for Holiday header)
class _RowTitleWithCount extends StatelessWidget {
  final String title;
  final int count;
  const _RowTitleWithCount({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _SectionTitle('')), // visual dividers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A8494),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3FF),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFDEE8FF)),
                ),
                child: Text(
                  '$count total',
                  style: const TextStyle(
                    color: Color(0xFF2F6BFF),
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: _SectionTitle('')),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: -2,
            offset: Offset(0, 4),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Column(children: _withDividers(children)),
    );
  }

  List<Widget> _withDividers(List<Widget> kids) {
    final out = <Widget>[];
    for (var i = 0; i < kids.length; i++) {
      out.add(kids[i]);
      if (i != kids.length - 1) {
        out.add(const Divider(height: 14, color: Color(0xFFE9EEF5)));
      }
    }
    return out;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7C8698),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2F39),
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _CollapsedRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxBool expanded;
  final VoidCallback onTap;
  final Widget child;

  const _CollapsedRow({
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOpen = expanded.value;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EEF5)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: -2,
              offset: Offset(0, 4),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              onTap: onTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                        color: Color(0xFF2D2F39),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7C8698),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF7C8698),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: child,
              ),
              crossFadeState:
                  isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      );
    });
  }
}

class _MiniContact extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback onCall;
  const _MiniContact({
    required this.name,
    required this.phone,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        phone,
        style: const TextStyle(fontSize: 12, color: Color(0xFF7C8698)),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.call, size: 18, color: Color(0xFF2F6BFF)),
        onPressed: onCall,
      ),
    );
  }
}

//
// ===== tiny utils/shared =====
//

final List<String> _mmm = const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

/// A tiny text row used across the page
class _MiniLine extends StatelessWidget {
  final String text;
  const _MiniLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          color: Color(0xFF2D2F39),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Shown when there are no holidays to display
class _EmptyHolidays extends StatelessWidget {
  const _EmptyHolidays();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: -2,
            offset: Offset(0, 4),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.event_busy, color: Color(0xFF7A8494)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No holidays found',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A8494),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Convert a DateTime (any timezone) into a local, date-only DateTime
/// Example: 2025-01-01T00:00:00Z -> DateTime(2025,1,1) in local zone
DateTime? _localDateOnly(DateTime? d) {
  if (d == null) return null;
  // If it's UTC, convert to local; if it's already local, keep it.
  final local = d.isUtc ? d.toLocal() : d;
  // Truncate time-of-day so we compare/display only the calendar date.
  return DateTime(local.year, local.month, local.day);
}
