import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/ui/work_order_list/work_orders_list_page.dart';
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
