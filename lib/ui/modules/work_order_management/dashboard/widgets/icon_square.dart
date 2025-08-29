import 'package:flutter/material.dart';

class IconSquare extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const IconSquare({super.key, required this.child, required this.onTap});

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Responsive sizing
    final double size = isTablet ? 52 : 44;
    final double radius = isTablet ? 8 : 6; // little rounded corner
    final EdgeInsets pad = EdgeInsets.all(isTablet ? 10 : 8);

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: Color(0xFFDFE5F0)), // subtle outline
      ),
      clipBehavior: Clip.antiAlias, // keep ripple inside rounded shape
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: SizedBox(
          height: size,
          width: size,
          child: Padding(
            padding: pad,
            // FittedBox keeps icons looking good on both phone & tablet
            child: FittedBox(fit: BoxFit.scaleDown, child: child),
          ),
        ),
      ),
    );
  }
}
