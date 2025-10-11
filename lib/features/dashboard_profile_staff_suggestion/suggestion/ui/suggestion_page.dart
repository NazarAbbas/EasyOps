import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/controller/suggestion_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionsPage extends GetView<SuggestionsController> {
  const SuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6BFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Suggestions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() {
        final list = controller.itemList;
        if (list.isEmpty) {
          return const Center(
            child: Text(
              'No suggestions found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (ctx, i) {
            final s = list[i];
            return Obx(
              () => _SuggestionCard(
                suggestion: s,
                isOpen: controller.isOpen(s.id),
                onOpenToggle: () => controller.toggleOpen(s.id),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemCount: list.length,
        );
      }),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2F6BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF2F6BFF).withOpacity(0.4),
              ),
              onPressed: controller.addNew,
              child: const Text(
                'Add New Suggestion',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ======================= WIDGETS =======================

class _SuggestionCard extends StatelessWidget {
  final Suggestion suggestion;
  final bool isOpen;
  final VoidCallback onOpenToggle;

  const _SuggestionCard({
    required this.suggestion,
    required this.isOpen,
    required this.onOpenToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    suggestion.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D2F39),
                      height: 1.3,
                    ),
                  ),
                ),
                _StatusPill(text: suggestion.status),
              ],
            ),
            const SizedBox(height: 8),

            // Meta Row
            Row(
              children: [
                const Icon(Icons.badge_outlined,
                    size: 15, color: Color(0xFF7C8698)),
                const SizedBox(width: 4),
                Text(
                  suggestion.id,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C8698),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.schedule_outlined,
                    size: 15, color: Color(0xFF7C8698)),
                const SizedBox(width: 4),
                Text(
                  _fmtTime(suggestion.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C8698),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month_outlined,
                    size: 15, color: Color(0xFF7C8698)),
                const SizedBox(width: 4),
                Text(
                  _fmtDate(suggestion.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C8698),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              suggestion.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D2F39),
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 6),
            Text(
              'Estimated Impact: ₹${suggestion.impactEstimate.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF7C8698),
                fontWeight: FontWeight.w700,
              ),
            ),

            // Expandable section
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState:
                  isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  _SoftBlock(
                    title: 'Comment',
                    text: suggestion.comment.isEmpty
                        ? 'No comment provided'
                        : suggestion.comment,
                  ),
                ],
              ),
            ),

            // Expand/Collapse icon at bottom
            Align(
              alignment: Alignment.center,
              child: Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF2F6BFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftBlock extends StatelessWidget {
  final String title;
  final String text;
  const _SoftBlock({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2F39),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.4,
              color: Color(0xFF2D2F39),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  const _StatusPill({required this.text});

  Color _statusColor() {
    switch (text.toLowerCase()) {
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFEBCB50);
      case 'rejected':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            _statusColor().withOpacity(0.9),
            _statusColor(),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: const StadiumBorder(),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// ======================= UTILS =======================

String _fmtTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _fmtDate(DateTime dt) {
  const months = [
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
    'Dec',
  ];
  final d = dt.day.toString().padLeft(2, '0');
  return '$d ${months[dt.month - 1]}';
}
