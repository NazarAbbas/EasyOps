import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex; // 0=Home, 1=Assets, 2=Work Orders
  const BottomBar({super.key, required this.currentIndex});

  static const Color _blue = AppColors.primaryBlue;
  static const Color _grey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        // ignore: deprecated_member_use
        indicatorColor: _blue.withOpacity(0.10), // subtle pill behind selected
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? _blue : _grey);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? _blue : _grey,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w500,
          );
        }),
      ),
      child: NavigationBar(
        height: 70,
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.cube_box),
            label: 'Assets',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.doc_on_clipboard),
            label: 'Work Orders',
          ),
        ],
        onDestinationSelected: (i) {
          if (i == currentIndex) return;
          switch (i) {
            case 0:
              Get.offAllNamed(Routes.bottomNavigationHomeScreen);
              break;
            case 1:
              Get.offAllNamed(Routes.bottomNavigationAssetsScreen);
              break;
            case 2:
              Get.offAllNamed(Routes.workOrderScreen);
              break;
          }
        },
      ),
    );
  }
}
