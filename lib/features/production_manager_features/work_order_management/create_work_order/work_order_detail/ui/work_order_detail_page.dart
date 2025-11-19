// work_order_details_page.dart
// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_ops/core/utils/loading_overlay.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/work_order_detail/controller/work_order_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Thumb;
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
        child: Obx(
          () => _GradientHeader(
            title: controller.title.value,
            isTablet: isTablet,
          ),
        ),
      ),
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
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
                      final pillColor =
                          _priorityColor(controller.priority.value);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _KVBlock(
                            rows: [
                              _KV(
                                label: 'Reported By :',
                                value: controller.reportedName.value.isEmpty
                                    ? '—'
                                    : controller.reportedName.value,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          _OperatorSection(
                            name: controller.operatorName.value,
                            phone: controller.operatorPhoneNumber.value,
                            info: controller.operatorInfo.value,
                          ),

                          const _DividerPad(),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller
                                        .problemTitle.value.isNotEmpty) ...[
                                      Text(
                                        controller.problemTitle.value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: _C.text,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15.5,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    Text(
                                      controller
                                              .problemDescription.value.isEmpty
                                          ? '—'
                                          : controller.problemDescription.value,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _C.text,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.5,
                                        height: 1.25,
                                      ),
                                    ),
                                  ],
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

                          Row(
                            children: [
                              Text(
                                [
                                  controller.time.value.isEmpty
                                      ? '—'
                                      : controller.time.value,
                                  controller.date.value.isEmpty
                                      ? '—'
                                      : controller.date.value,
                                ].join(' | '),
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
                          const SizedBox(height: 6),

                          if (controller.line.value.isNotEmpty) ...[
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
                          ],

                          if (controller.location.value.isNotEmpty)
                            Text(
                              controller.location.value,
                              style: const TextStyle(
                                color: _C.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                          const _DividerPad(),

                          Text(
                            controller.descriptionText.value.isEmpty
                                ? '—'
                                : controller.descriptionText.value,
                            style: const TextStyle(
                              color: _C.text,
                              fontWeight: FontWeight.w800,
                              fontSize: 15.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.problemTitle.value.isEmpty
                                ? '—'
                                : controller.problemTitle.value,
                            style:
                                const TextStyle(color: _C.text, height: 1.35),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.problemDescription.value.isEmpty
                                ? '—'
                                : controller.problemDescription.value,
                            style:
                                const TextStyle(color: _C.text, height: 1.35),
                          ),
                          const SizedBox(height: 12),

                          // MEDIA
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.photoPaths.isEmpty)
                                const _EmptyHint(text: 'No photos attached')
                              else
                                _PhotoGrid(
                                  paths: controller.photoPaths,
                                  onPhotoTap: (index) => _showPhotoViewer(controller.photoPaths, index),
                                ),
                              const SizedBox(height: 12),
                              if (controller.voiceNotePath.value.isEmpty)
                                const _EmptyHint(text: 'No audio attached')
                              else
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 360),
                                  child: _AudioCard(path: controller.voiceNotePath.value),
                                ),
                            ],
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ),
              if (controller.isLoading.value)
                const LoadingOverlay(message: 'Creating work order...'),
            ],
          )),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
          child: SizedBox(
            height: isTablet ? 56 : 52,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.primary,
                      side: const BorderSide(color: _C.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.goBack,
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _C.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.create,
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /* -------------------- Photo Viewer -------------------- */

  void _showPhotoViewer(List<String> paths, int initialIndex) {
    if (paths.isEmpty) return;

    final PageController pageController = PageController(initialPage: initialIndex);
    int currentIndex = initialIndex;

    showDialog(
      context: Get.context!,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                // Photo viewer
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    final path = paths[index];
                    return PhotoViewGalleryPageOptions(
                      imageProvider: _getImageProvider(path),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  itemCount: paths.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                  ),
                  pageController: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),

                // Close button
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Get.back(),
                  ),
                ),

                // Image counter
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      '${currentIndex + 1} / ${paths.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    if (_isUrl(path)) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  bool _isUrl(String p) => p.toLowerCase().startsWith('http');
}

/* ───────────────────────── Original helpers ───────────────────────── */

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
    const labelStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w800);
    const valueStyle = TextStyle(color: Colors.black);

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
    const labelStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w800);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operator', style: labelStyle),
        const SizedBox(height: 6),
        _LineWithIcon(
            icon: CupertinoIcons.person, text: name.isEmpty ? '—' : name),
        const SizedBox(height: 4),
        _LineWithIcon(
            icon: CupertinoIcons.phone, text: phone.isEmpty ? '—' : phone),
        const SizedBox(height: 4),
        _LineWithIcon(
            icon: CupertinoIcons.location, text: info.isEmpty ? '—' : info),
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
    const valueStyle = TextStyle(color: Colors.black);
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

/* ───────────────────────── Media (file or URL) ───────────────────────── */

class _PhotoGrid extends StatelessWidget {
  final List<String> paths;
  final Function(int index)? onPhotoTap;

  const _PhotoGrid({required this.paths, this.onPhotoTap});

  bool _isUrl(String p) => p.toLowerCase().startsWith('http');

  bool _localExists(String p) {
    try {
      return File(p).existsSync();
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // accept:
    //  - http/https URLs
    //  - local files that exist
    final valid = paths.where((p) {
      final t = p.trim();
      if (t.isEmpty) return false;
      if (_isUrl(t)) return true;
      return _localExists(t);
    }).toList();

    if (valid.isEmpty) return const _EmptyHint(text: 'No photos attached');

    return LayoutBuilder(
      builder: (ctx, c) {
        final maxW = c.maxWidth;
        final cross = maxW > 520 ? 4 : (maxW > 380 ? 3 : 2);
        return GridView.builder(
          itemCount: valid.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 4 / 3,
          ),
          itemBuilder: (_, i) => _Thumb(
            path: valid[i],
            onTap: () => onPhotoTap?.call(i),
          ),
        );
      },
    );
  }
}

class _Thumb extends StatelessWidget {
  final String path;
  final VoidCallback? onTap;
  const _Thumb({required this.path, this.onTap});

  bool _isUrl(String p) => p.toLowerCase().startsWith('http');

  @override
  Widget build(BuildContext context) {
    final isUrl = _isUrl(path);
    final border = BorderRadius.circular(12);

    Widget img;
    if (isUrl) {
      img = Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFF1F5F9),
          child: const Center(
            child:
            Icon(CupertinoIcons.exclamationmark_triangle, color: _C.muted),
          ),
        ),
      );
    } else {
      final f = File(path);
      if (!f.existsSync()) return const SizedBox();
      img = Image.file(f, fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: border,
        child: Stack(
          fit: StackFit.expand,
          children: [
            img,
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AudioCard extends StatefulWidget {
  final String path; // file path or URL
  const _AudioCard({required this.path});

  @override
  State<_AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<_AudioCard> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get _isUrl => widget.path.toLowerCase().startsWith('http');

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
      if (_isUrl) {
        await _player.setSource(UrlSource(widget.path));
      } else {
        if (!File(widget.path).existsSync()) return;
        await _player.setSource(DeviceFileSource(widget.path));
      }
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
    if (!_isUrl && !File(widget.path).existsSync()) return;

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      if (_position > Duration.zero && _position < _duration) {
        await _player.resume();
      } else {
        await _player.stop();
        if (_isUrl) {
          await _player.play(UrlSource(widget.path));
        } else {
          await _player.play(DeviceFileSource(widget.path));
        }
      }
      setState(() => _isPlaying = true);
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path.isEmpty) {
      return const _EmptyHint(text: 'No voice note');
    }

    final totalText = _duration == Duration.zero ? '--:--' : _fmt(_duration);
    final pos = (_duration != Duration.zero && _position > _duration)
        ? _duration
        : _position;
    final posText = _fmt(pos);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        border: Border.all(color: const Color(0xFFDCE5FF)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: _C.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Voice note',
                    style: TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.w800,
                    )),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: _duration == Duration.zero
                        ? 0
                        : pos.inMilliseconds / _duration.inMilliseconds,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation(_C.primary),
                  ),
                ),
                const SizedBox(height: 6),
                Text('$posText / $totalText',
                    style: const TextStyle(
                      color: _C.muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EAFB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.info, color: _C.muted, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _C.muted,
                fontWeight: FontWeight.w700,
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
