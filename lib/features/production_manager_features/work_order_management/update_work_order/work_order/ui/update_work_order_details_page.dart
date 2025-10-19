// update_work_order_details_page.dart
// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Thumb;
import 'package:get/get.dart';

// Import your controller
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/work_order/controller/update_work_order_controller.dart';

class UpdateWorkOrderDetailsPage
    extends GetView<UpdateWorkOrderDetailsController> {
  const UpdateWorkOrderDetailsPage({super.key});

  @override
  UpdateWorkOrderDetailsController get controller =>
      Get.put(UpdateWorkOrderDetailsController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double hPad = isTablet ? 18 : 14;
    final double btnH = isTablet ? 56 : 52;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      /* ---------- Bottom Buttons ---------- */
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(btnH),
                    side: const BorderSide(color: _C.primary, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: _C.primary,
                  ),
                  onPressed: controller.reOpenWorkOrder,
                  child: const Text('Re-Open',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(btnH),
                    backgroundColor: _C.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1.5,
                  ),
                  onPressed: controller.closeWorkOrder,
                  child: const Text('Close',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),

      /* ---------- Body ---------- */
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
              final pillColor = _priorityColor(controller.priority.value);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Reporter */
                  _KVBlock(rows: [
                    _KV(
                      label: 'Reported By :',
                      value: controller.reportedBy.value.isEmpty
                          ? '—'
                          : controller.reportedBy.value,
                    ),
                  ]),
                  const SizedBox(height: 8),

                  /* Operator */
                  _OperatorSection(
                    name: controller.operatorName.value,
                    phone: controller.operatorPhoneNumber.value,
                    info: controller.operatorInfo.value,
                  ),
                  const _DividerPad(),

                  /* Summary + priority */
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.workOrderTitle.value.isEmpty
                              ? '—'
                              : controller.workOrderTitle.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(
                        text: controller.priority.value.isEmpty
                            ? '—'
                            : controller.priority.value,
                        color: pillColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /* Time | Date + Issue type */
                  Row(
                    children: [
                      Text(
                        controller.date.value.isEmpty
                            ? '—'
                            : controller.date.value,
                        style: const TextStyle(
                          color: _C.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        controller.issueType.value.isEmpty
                            ? '—'
                            : controller.issueType.value,
                        style: const TextStyle(
                          color: _C.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  /* Location-ish line (your CNC text) */
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        size: 14,
                        color: Color(0xFFE25555),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          controller.cnc_1.value,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (controller.line.value.isNotEmpty) ...[
                    const SizedBox(height: 6),
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
                  ],
                  if (controller.location.value.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      controller.location.value,
                      style: const TextStyle(
                        color: _C.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const _DividerPad(),

                  /* Descriptions */
                  Text(
                    controller.remark.value.isEmpty
                        ? '—'
                        : controller.remark.value,
                    style: const TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.description.value.isEmpty
                        ? '—'
                        : controller.description.value,
                    style: const TextStyle(color: _C.text, height: 1.35),
                  ),
                  const SizedBox(height: 12),

                  /* -------- Media (GRID then full-width AUDIO) -------- */
                  Obx(() {
                    final imgs = controller.photoPaths
                        .where((p) => p.isNotEmpty)
                        .toList();
                    final hasImages = imgs.isNotEmpty;

                    final isTablet =
                        MediaQuery.of(context).size.shortestSide >= 600;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (hasImages)
                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // parent scrolls
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isTablet ? 4 : 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 88 / 64,
                            ),
                            itemCount: imgs.length,
                            itemBuilder: (_, i) => _Thumb(path: imgs[i]),
                          ),
                        if (hasImages) const SizedBox(height: 12),

                        // FULL-WIDTH AUDIO
                        if (controller.voiceNotePath.value.isNotEmpty)
                          _AudioBar(path: controller.voiceNotePath.value),
                      ],
                    );
                  }),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

/* ------------------------------ Helpers ------------------------------ */

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

/* ------------------------------ Widgets ------------------------------ */

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
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(color: _C.line, height: 1),
      );
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

/* ------------------------------ Media ------------------------------ */

class _Thumb extends StatelessWidget {
  final String path; // absolute URL
  const _Thumb({required this.path});
  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: const Color(0xFFF1F5FB),
        child: Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _BrokenThumb(),
          loadingBuilder: (c, w, p) => p == null ? w : const _ThumbSkeleton(),
        ),
      ),
    );
  }
}

class _ThumbSkeleton extends StatelessWidget {
  const _ThumbSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF3FA),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _BrokenThumb extends StatelessWidget {
  const _BrokenThumb();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDECEC),
      child: const Center(
        child: Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          size: 18,
          color: Color(0xFFE25555),
        ),
      ),
    );
  }
}

/* ------------------------------ Full-width Audio Bar ------------------------------ */

class _AudioBar extends StatefulWidget {
  final String path; // absolute URL
  const _AudioBar({required this.path});

  @override
  State<_AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<_AudioBar> {
  late final AudioPlayer _player;
  bool _isPlaying = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (!mounted) return;
      if (_duration != Duration.zero && p > _duration) p = _duration;
      setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _position = _duration;
      });
    });

    _preload();
  }

  Future<void> _preload() async {
    if (widget.path.isEmpty) return;
    try {
      await _player.setSource(UrlSource(widget.path));
      final d = await _player.getDuration();
      if (mounted && d != null) setState(() => _duration = d);
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (widget.path.isEmpty) return;

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      if (_position > Duration.zero && _position < _duration) {
        await _player.resume();
      } else {
        await _player.stop();
        await _player.play(UrlSource(widget.path));
      }
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _seek(double v) async {
    final target = Duration(milliseconds: v.round());
    await _player.seek(target);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path.isEmpty) return const SizedBox.shrink();

    final max = _duration.inMilliseconds.toDouble();
    final value =
        _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFE6F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Play / Pause
              IconButton(
                onPressed: _toggle,
                icon: Icon(
                  _isPlaying
                      ? CupertinoIcons.pause_fill
                      : CupertinoIcons.play_fill,
                  color: _C.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 8),

              // Slider (expanded)
              Expanded(
                child: Slider(
                  value: max == 0 ? 0 : value,
                  min: 0,
                  max: max == 0 ? 1 : max,
                  onChanged: max == 0 ? null : _seek,
                ),
              ),

              const SizedBox(width: 8),

              // Time label
              Text(
                '${_fmt(_position)} / ${max == 0 ? '--:--' : _fmt(_duration)}',
                style: const TextStyle(
                  color: _C.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ------------------------------ Tiny bits ------------------------------ */

class _OperatorSection extends StatelessWidget {
  final String name;
  final String phone;
  final String info;
  const _OperatorSection({
    required this.name,
    required this.phone,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(color: _C.muted, fontWeight: FontWeight.w800);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operator', style: labelStyle),
        const SizedBox(height: 6),
        _LineWithIcon(
          icon: CupertinoIcons.person,
          text: name.isEmpty ? '—' : name,
        ),
        const SizedBox(height: 4),
        _LineWithIcon(
          icon: CupertinoIcons.phone,
          text: phone.isEmpty ? '—' : phone,
        ),
        const SizedBox(height: 4),
        _LineWithIcon(
          icon: CupertinoIcons.location,
          text: info.isEmpty ? '—' : info,
        ),
      ],
    );
  }
}

class _LineWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const _LineWithIcon({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    const valueStyle = TextStyle(color: _C.text, fontWeight: FontWeight.w800);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: _C.muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}

/* ------------------------------ Style ------------------------------ */

class _C {
  static const primary = Color(0xFF2F6BFF);
  static const muted = Color(0xFF7C8698);
  static const text = Color(0xFF2D2F39);
  static const line = Color(0xFFE6EBF3);
}
