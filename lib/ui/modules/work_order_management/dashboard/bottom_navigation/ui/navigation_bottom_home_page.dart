import 'package:easy_ops/ui/modules/work_order_management/dashboard/bottom_navigation/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class NavigationBottomHomePage extends StatelessWidget {
  const NavigationBottomHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
    );
  }
}
