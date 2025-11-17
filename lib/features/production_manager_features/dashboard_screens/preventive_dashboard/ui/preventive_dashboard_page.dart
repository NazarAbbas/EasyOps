// lib/core/navigation/main_tab_shell.dart
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/preventive_work_order_list/ui/me_preventive_work_order_list_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_management_dashboard/ui/assets_management_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_screens/preventive_dashboard/controller/preventive_dashboard_controller.dart';
import 'package:easy_ops/features/production_manager_features/feature_preventive_maintenance/preventive_work_order_list/ui/preventive_work_order_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreventiveDashboardPage extends StatelessWidget {
  const PreventiveDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PreventiveRootNavController(), permanent: true);

    // Titles shown in the AppBar per tab
    //const titles = <String>['Home', 'Spare Parts', 'Assets', 'Work Orders'];

    return Scaffold(
      body: PageView(
        controller: c.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MEPreventiveWorkOrderListPage(),
          // SparePartsTabsShell(),
          AssetsManagementDashboardPage(),
          MEPreventiveWorkOrderListPage(),
          // PreventiveWorkOrderPage(), // your existing page
        ],
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: c.index.value,
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.house),
              label: 'Home',
            ),
            // NavigationDestination(
            //   icon: Icon(CupertinoIcons.increase_indent),
            //   label: 'Spare Parts',
            // ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.cube_box),
              label: 'Assets',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.doc_on_clipboard),
              label: 'Work Orders',
            ),
          ],
          onDestinationSelected: c.select, // uses your controller's jumpToPage
        ),
      ),
    );
  }
}
