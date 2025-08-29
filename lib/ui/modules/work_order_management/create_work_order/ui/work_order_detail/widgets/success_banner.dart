import 'package:flutter/material.dart';

class SuccessBanner extends StatelessWidget {
  final String title;
  final String sub;
  const SuccessBanner({super.key, required this.title, required this.sub});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Responsive tokens
    final double radius = isTablet ? 16 : 12;
    final double hPad = isTablet ? 16 : 14;
    final double vPad = isTablet ? 14 : 12;
    final double avatarSize = isTablet ? 52 : 44;
    final double iconSize = isTablet ? 30 : 26;
    final double gap = isTablet ? 14 : 12;
    final double titleSize = isTablet ? 18 : 16;
    final double subSize = isTablet ? 13.5 : 12.5;

    return Container(
      // Let it expand if text wraps; enforce a comfortable minimum height.
      constraints: BoxConstraints(minHeight: isTablet ? 96 : 82),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E8A3B), Color(0xFF0A6A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: const BoxDecoration(
              color: Color(0xFFBFEBCB),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.black87, size: iconSize),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: titleSize,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: subSize,
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
