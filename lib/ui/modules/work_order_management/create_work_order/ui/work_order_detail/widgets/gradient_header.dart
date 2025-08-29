import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing; // optional action on the right (keeps title centered)

  const GradientHeader({super.key, required this.title, this.trailing});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Responsive tokens
    final double sidePad = isTablet ? 16 : 12;
    final double topPad = isTablet ? 16 : 12;
    final double botPad = isTablet ? 12 : 10;
    final double fontSize = isTablet ? 22 : 18;
    final double iconSize = isTablet ? 28 : 22;
    final double btnSize = isTablet ? 56 : 48; // hit target box
    final canPop = Navigator.of(context).canPop();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2F6BFF), Color(0xFF3F84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(sidePad, topPad, sidePad, botPad),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: btnSize,
          child: Row(
            children: [
              // Back button (or spacer if cannot pop)
              SizedBox(
                width: btnSize,
                height: btnSize,
                child: canPop
                    ? IconButton(
                        iconSize: iconSize,
                        splashRadius: btnSize / 2,
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                        ),
                        tooltip: 'Back',
                      )
                    : const SizedBox.shrink(),
              ),

              // Centered title
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Right spacer/action to balance the back button width
              SizedBox(
                width: btnSize,
                height: btnSize,
                child: trailing ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
