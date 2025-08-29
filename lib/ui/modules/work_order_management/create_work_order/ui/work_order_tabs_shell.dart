// The screen with header tabs + body that swaps content
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/controller/WorkTabsController.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/mc_history/ui/mc_history_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/ui/operator_info_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/ui/work_order_info_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/header_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrderTabsShell extends StatelessWidget {
  const WorkOrderTabsShell({super.key});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(WorkTabsController());
    final isTablet = _isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isTablet ? 140 : 120),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2F6BFF), Color(0xFF3F84FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.fromLTRB(12, isTablet ? 14 : 10, 12, 8),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back + centered title
                Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                      ),
                      tooltip: 'Back',
                    ),
                    Expanded(
                      child: Text(
                        'Create Work Order',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 22 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // balance IconButton width
                  ],
                ),
                const SizedBox(height: 6),
                const HeaderTabs(),
              ],
            ),
          ),
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: ctrl.selectedTab.value, // 0 shows WorkOrderInfoPage first
          children: const [
            WorkOrderInfoPage(),
            OperatorInfoPage(),
            McHistoryPage(),
          ],
        ),
      ),
    );
  }
}
