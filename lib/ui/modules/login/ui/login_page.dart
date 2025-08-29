import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/login/controller/login_controller.dart';
import 'package:easy_ops/ui/modules/login/widgets/login_card.dart';
import 'package:easy_ops/ui/modules/login/widgets/login_footer.dart';
import 'package:easy_ops/ui/modules/login/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final controller = Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;

          return Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: CustomPaint(painter: BlueBackgroundPainter()),
              ),

              Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 500 : double.infinity,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: isTablet ? 100 : 80),
                        LoginLogo(isTablet: isTablet),
                        SizedBox(height: isTablet ? 50 : 40),
                        // Animation wrapper
                        LoginCard(controller: controller, isTablet: isTablet),
                        SizedBox(height: isTablet ? 40 : 30),
                        const LoginFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BlueBackgroundPainter extends CustomPainter {
  const BlueBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryBlue;

    final path = Path()
      ..lineTo(0, size.height) // Start curve 40px from bottom
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height + 140, // Slight curve outside bounds
        size.width,
        size.height,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
