import 'package:easy_ops/ui/modules/work_order_management/dashboard/bottom_navigation/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class NavigationBottomAssets extends StatelessWidget {
  const NavigationBottomAssets({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets')),
      body: const Center(child: Text('Assets Screen')),
      bottomNavigationBar: const BottomBar(currentIndex: 1),
    );
  }
}
