import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/controller/work_orders_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/Work_order_card.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/bottom_navigation/widgets/bottom_bar.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/gradient_header.dart';
import 'package:easy_ops/ui/modules/work_order_management/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// If you aren't using Bindings, make sure somewhere before this page you do:
// Get.put(WorkOrdersController(), permanent: true);

class WorkOrdersPage extends GetView<WorkOrdersController> {
  const WorkOrdersPage({super.key});

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Responsive sizes
    final double headerHeight = isTablet ? 148 : 120;
    final double listHSpacing = isTablet ? 5 : 2;
    final double listVSpacing = isTablet ? 5 : 2;
    final double buttonHeight = isTablet ? 56 : 52;
    final double buttonFontSize = isTablet ? 18 : 16;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(headerHeight),
        child: const GradientHeader(),
      ),
      body: Column(
        children: [
          const Tabs(),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              // --- reactive reads (track changes) ---
              final q = controller.query.value.trim().toLowerCase();
              final src = controller.orders;
              final _ = src.length; // ensures Obx tracks changes to the list

              // Always build a plain List for ListView
              final List filtered = q.isEmpty
                  ? src.toList(growable: false)
                  : src
                        .where((o) => o.title.toLowerCase().contains(q))
                        .toList(growable: false);

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(listHSpacing, 8, listHSpacing, 24),
                itemBuilder: (_, i) => WorkOrderCard(order: filtered[i]),
                separatorBuilder: (_, __) => SizedBox(height: listVSpacing),
                itemCount: filtered.length,
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SizedBox(
                height: buttonHeight,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        6,
                      ), // <- little bit rounded
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.workOrderTabShellScreen);
                  },
                  child: Text(
                    'Create Work Order',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Use your existing bottom bar widget (make sure it's const if possible)
      bottomNavigationBar: BottomBar(currentIndex: 2),
    );
  }
}
