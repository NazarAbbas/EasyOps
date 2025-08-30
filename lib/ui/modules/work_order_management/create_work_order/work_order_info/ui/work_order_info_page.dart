import 'package:easy_ops/ui/modules/work_order_management/create_work_order/work_order_info/controller/work_order_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrderInfoPage extends GetView<WorkorderInfoController> {
  const WorkOrderInfoPage({super.key});
  @override
  WorkorderInfoController get controller => Get.put(WorkorderInfoController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double hPad = isTablet ? 20 : 14;
    final double cardRadius = isTablet ? 16 : 12;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Work Order card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFF)],
                ),
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(color: const Color(0xFFE9EEF6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _CardTitle('Work Order Info'),
                    const SizedBox(height: 12),

                    // Issue Type | Impact
                    _Row2(
                      left: _Label(
                        'Issue Type',
                        _TapField(
                          textRx: controller.issueType,
                          placeholder: 'Select',
                          onTap: () => controller.pickFromList(
                            context: context,
                            title: 'Select Issue Type',
                            items: controller.issueTypes,
                            onSelected: (v) => controller.issueType.value = v,
                          ),
                        ),
                      ),
                      right: _Label(
                        'Impact',
                        _TapField(
                          textRx: controller.impact,
                          placeholder: 'Select',
                          onTap: () => controller.pickFromList(
                            context: context,
                            title: 'Select Impact',
                            items: controller.impacts,
                            onSelected: (v) => controller.impact.value = v,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    const _Hr(),

                    // Assets Number | Type + clock square
                    _Row2(
                      left: _Label(
                        'Assets Number',
                        TextField(
                          controller: controller.assetsCtrl,
                          decoration: _D.field(
                            hint: 'Search',
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 12, right: 6),
                              child: Icon(
                                CupertinoIcons.number,
                                size: 18,
                                color: _C.muted,
                              ),
                            ),
                            suffix: const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                CupertinoIcons.search,
                                color: _C.muted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      right: _Label(
                        'Type',
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => _ValueTile(controller.typeText.value),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _IconSquare(
                              tooltip: 'Recent types',
                              onTap: () {},
                              child: const Icon(
                                CupertinoIcons.clock,
                                color: _C.primary,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    const _Hr(),

                    // Description (read-only tile)
                    _Label(
                      'Description',
                      Obx(() => _ValueTile(controller.descriptionText.value)),
                    ),

                    const SizedBox(height: 12),

                    // Problem Description
                    _Label(
                      'Problem Description',
                      TextField(
                        controller: controller.problemCtrl,
                        minLines: 5,
                        maxLines: 8,
                        decoration: _D.field(hint: 'Write here'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Upload photos + mic button
                    Row(
                      children: [
                        Expanded(child: _UploadPhotosBox(onTap: () {})),
                        const SizedBox(width: 10),
                        _IconSquare(
                          tooltip: 'Voice note',
                          onTap: () {},
                          child: const Icon(
                            CupertinoIcons.mic,
                            color: _C.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ── Operator Info footer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(color: const Color(0xFFE9EEF6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: _OperatorInfoFooter()),
                  const SizedBox(width: 10),
                  _IconSquare(
                    tooltip: 'Edit',
                    onTap: () {}, // navigate to operator page if needed
                    child: const Icon(CupertinoIcons.pencil, color: _C.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Bottom CTA
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 6, hPad, 10),
          child: SizedBox(
            height: isTablet ? 56 : 52,
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _C.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1.5,
              ),
              onPressed: () {
                controller.goToWorkOrderDetailScreen();
              },
              child: const Text(
                'Create',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ─────────────── pieces ─────────────── */

class _CardTitle extends StatelessWidget {
  final String text;
  const _CardTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _C.text,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 3,
          decoration: BoxDecoration(
            color: _C.primary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _OperatorInfoFooter extends StatelessWidget {
  const _OperatorInfoFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operator Info',
          style: TextStyle(
            color: Color(0xFF5B667A),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Ajay Kumar (MP18292)',
          style: TextStyle(color: _C.text, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 2),
        Text(
          '9876543211',
          style: TextStyle(color: _C.text, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 2),
        Text(
          'Assets Shop | 12:20| 03 Sept| A',
          style: TextStyle(color: _C.text, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String title;
  final Widget child;
  const _Label(this.title, this.child);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _C.text,
              fontWeight: FontWeight.w800,
              fontSize: 15.5,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  final RxString textRx;
  final String placeholder;
  final VoidCallback onTap;
  const _TapField({
    required this.textRx,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmpty = textRx.value.isEmpty;
      final text = isEmpty ? placeholder : textRx.value;
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
            text,
            style: TextStyle(
              color: isEmpty ? _C.muted : _C.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }
}

class _ValueTile extends StatelessWidget {
  final String value;
  const _ValueTile(this.value);
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: _D.field(),
      child: Text(
        value,
        style: const TextStyle(color: _C.text, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _UploadPhotosBox extends StatelessWidget {
  final VoidCallback onTap;
  const _UploadPhotosBox({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE1E6EF), width: 1.4),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.upload_circle, color: _C.primary),
                SizedBox(width: 8),
                Text(
                  'Upload photos',
                  style: TextStyle(
                    color: _C.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              'Format : jpeg, jpg, png',
              style: TextStyle(color: _C.muted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? tooltip;
  const _IconSquare({required this.child, required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: const Color(0xFFEFF3FF),

      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Color(0xFFE1E6EF), width: 1.4),
          ),
          child: Center(child: child),
        ),
      ),
    );
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

class _Hr extends StatelessWidget {
  const _Hr();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Divider(color: _C.line, height: 1),
  );
}

class _Row2 extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _Row2({required this.left, required this.right});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(fit: FlexFit.tight, child: left),
        const SizedBox(width: 12),
        Flexible(fit: FlexFit.tight, child: right),
      ],
    );
  }
}

/* ─────────────── style helpers ─────────────── */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const muted = Color(0xFF8A94A6);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
}

class _D {
  static InputDecoration field({String? hint, Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: const TextStyle(color: _C.muted, fontWeight: FontWeight.w600),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE1E6EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE1E6EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE1E6EF)),
      ),
    );
  }
}
