// ignore_for_file: library_private_types_in_public_api

import 'package:easy_ops/constants/values/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_ops/ui/modules/splash/controller/splash_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});
  final SplashPageController controller = Get.put(SplashPageController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Adjusted sizes
    final iconSize = size.width * 0.12; // smaller gear icon
    final logoSize = size.width * 0.3; // smaller logo so it sits closer

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.gearIcon,
                width: iconSize,
                height: iconSize,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                "EasyOps", // replace with the text you want
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize:
                      logoSize * 0.35, // proportional size like your image
                  color: Colors.white, // same color as before
                  fontWeight: FontWeight
                      .bold, // optional: makes it look more like a logo
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
