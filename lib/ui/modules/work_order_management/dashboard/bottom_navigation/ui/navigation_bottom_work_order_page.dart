import 'package:easy_ops/ui/modules/work_order_management/dashboard/bottom_navigation/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class NavigationBottomWorkOrderPage extends StatelessWidget {
  const NavigationBottomWorkOrderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work Orders')),
      body: const Center(child: Text('Work Orders Screen')),
      bottomNavigationBar: const BottomBar(currentIndex: 2),
    );
  }
}
