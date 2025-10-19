import 'dart:async';

import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_specification/controller/assets_specification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetsSpecificationPage extends GetView<AssetSpecificationController> {
  const AssetsSpecificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F6BFF);
    const _border = Color(0xFFE9EEF5);
    const _card = Color(0xFFF6F7FB);
    const _text = Color(0xFF2D2F39);
    const _muted = Color(0xFF7C8698);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: const Text('Assets Specification'),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final a = controller.asset.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header card
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: _text,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  children: [
                                    TextSpan(text: a.code),
                                    const TextSpan(
                                      text: '  |  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: a.make,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                a.description,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: Color(0xFF15C66B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    a.status,
                                    style: const TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _CriticalPill(text: a.criticality),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Docs row (GRID - no overflow)
                    Container(
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _border),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                      child: _PdfGrid<dynamic>(
                        docs: controller.docs,
                        titleOf: (d) => d.title,
                        pagesOf: (d) => d.pages,
                        progressOf: (d) =>
                            controller.progress[d.id], // null / -1 / 0..1 / ≥1
                        onTapDoc: (d) =>
                            controller.downloadAndOpen(d), // Future ok
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Technical Data
              _SectionCard(
                title: 'Technical Data',
                items: a.technicalData,
                primary: primary,
                border: _border,
                text: _text,
                muted: _muted,
              ),
              const SizedBox(height: 12),

              // Commercial Data
              _SectionCard(
                title: 'Commercial Data',
                items: a.commercialData,
                primary: primary,
                border: _border,
                text: _text,
                muted: _muted,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}

// ---------- UI atoms ----------

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _CriticalPill extends StatelessWidget {
  final String text;
  const _CriticalPill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D4F),
        borderRadius: BorderRadius.circular(20),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Map<String, String> items;
  final Color primary, border, text, muted;

  const _SectionCard({
    required this.title,
    required this.items,
    required this.primary,
    required this.border,
    required this.text,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: border)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: TextStyle(color: primary, fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(child: Divider(color: border)),
            ],
          ),
          const SizedBox(height: 6),
          ...items.entries
              .map(
                (e) => _KVRow(
                  label: e.key,
                  value: e.value,
                  text: text,
                  muted: muted,
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String label, value;
  final Color text, muted;
  const _KVRow({
    required this.label,
    required this.value,
    required this.text,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 48,
            child: Text(
              label,
              style: TextStyle(
                color: muted,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 52,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: text,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfGrid<T> extends StatelessWidget {
  final List<T> docs;
  final String Function(T doc) titleOf;
  final int Function(T doc) pagesOf;
  final double? Function(T doc)
      progressOf; // null idle, -1 opening, 0..1 dl, ≥1 done
  final FutureOr<void> Function(T doc) onTapDoc;

  const _PdfGrid({
    super.key,
    required this.docs,
    required this.titleOf,
    required this.pagesOf,
    required this.progressOf,
    required this.onTapDoc,
  });

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No documents available',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, c) {
        const spacing = 10.0;

        // ✅ Force at least 2 columns on phones, 3 on wider screens
        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
        final columns = isTablet ? 3 : 2;

        // Compute a safe tile height (icon row + gaps + 2 title lines + chip + padding)
        final ts = MediaQuery.of(context).textScaleFactor;
        final titleLineH = 16.0 * 1.25 * ts; // matches ~12.5 font * line-height
        final tileHeight = 22 /*top row*/ +
            8 /*gap*/ +
            (titleLineH * 2) +
            8 /*gap*/ +
            24 /*chip*/ +
            20 /*vertical padding*/;

        // Use the actual available width seen by the grid
        final tileWidth = (c.maxWidth - spacing * (columns - 1)) / columns;
        final childAspectRatio = tileWidth / tileHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns, // 👈 fixed columns (2 or 3)
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio, // 👈 prevents bottom overflow
          ),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i];
            return _PdfTile(
              title: titleOf(d),
              pages: pagesOf(d),
              progress: progressOf(d),
              onTap: () => onTapDoc(d),
            );
          },
        );
      },
    );
  }
}

class _PdfTile extends StatelessWidget {
  final String title;
  final int pages;
  final double? progress; // null idle, -1 opening, 0..1 downloading, ≥1 done
  final VoidCallback onTap;

  const _PdfTile({
    required this.title,
    required this.pages,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFE9EEF5);
    final chipBg = const Color(0xFFF2F6FF);
    final chipText = const Color(0xFF2F6BFF);

    Widget status;
    if (progress == null) {
      status = const Icon(Icons.download_rounded, size: 18);
    } else if (progress == -1) {
      status = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (progress! >= 0 && progress! < 1) {
      status = SizedBox(
        width: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            Text(
              '${(progress! * 100).toInt()}%',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    } else {
      status = const Icon(Icons.check_circle, size: 18, color: Colors.green);
    }

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // top row: pdf icon + status
              Row(
                children: const [
                  Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 20,
                    color: Colors.red,
                  ),
                  Spacer(),
                ],
              ),
              Align(alignment: Alignment.centerRight, child: status),
              const SizedBox(height: 8),
              // title (max 2 lines)
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const Spacer(),
              // pages chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  '$pages Pages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: chipText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
