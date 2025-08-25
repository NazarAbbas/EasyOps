import 'package:easy_ops/ui/modules/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'login_card.dart';

class LoginCardWithAnimation extends StatefulWidget {
  final LoginPageController controller;
  final bool isTablet;

  const LoginCardWithAnimation({
    super.key,
    required this.controller,
    required this.isTablet,
  });

  @override
  State<LoginCardWithAnimation> createState() => _LoginCardWithAnimationState();
}

class _LoginCardWithAnimationState extends State<LoginCardWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: LoginCard(
          controller: widget.controller,
          isTablet: widget.isTablet,
        ),
      ),
    );
  }
}
