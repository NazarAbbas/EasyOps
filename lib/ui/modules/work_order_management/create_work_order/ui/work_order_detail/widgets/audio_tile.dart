import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioTile extends StatelessWidget {
  final String duration;
  const AudioTile({super.key, this.duration = '00:20'});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2F6BFF);
    final isTablet = _isTablet(context);

    // Responsive tokens
    final double w = isTablet ? 108 : 88;
    final double h = isTablet ? 76 : 64;
    final double radius = isTablet ? 12 : 10;
    final double iconSize = isTablet ? 32 : 28;
    final double timeFont = isTablet ? 13.5 : 12;
    final double padRight = isTablet ? 10 : 8;
    final double padBottom = isTablet ? 8 : 6;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(CupertinoIcons.play_fill, color: blue, size: iconSize),
          Positioned(
            right: padRight,
            bottom: padBottom,
            child: Text(
              duration,
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: timeFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
