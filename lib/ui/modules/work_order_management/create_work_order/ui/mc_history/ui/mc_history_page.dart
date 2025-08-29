// view: lib/.../mc_history/ui/mc_history_page.dart
import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/controller/WorkTabsController.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/mc_history/widgets/history_card.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/mc_history/widgets/state_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mc_history_controller.dart';

class McHistoryPage extends GetView<McHistoryController> {
  const McHistoryPage({super.key});

  @override
  McHistoryController get controller =>
      Get.put<McHistoryController>(McHistoryController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double hPad = isTablet ? 18 : 14;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        final items = controller.items;

        if (items.isEmpty) {
          // simple empty state (optional)
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No history yet',
                style: TextStyle(
                  color: const Color(0xFF7C8698),
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 18 : 16,
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 12),
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemCount: items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Text(
                'Assets History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2F39),
                ),
              );
            }
            if (index == 1) {
              return const StatsRow();
            }
            final item = items[index - 2];
            return HistoryCard(item: item);
          },
        );
      }),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
          child: SizedBox(
            height: isTablet ? 56 : 52,
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2F6BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.find<WorkTabsController>().goTo(0),
              child: const Text(
                'Go Back',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
