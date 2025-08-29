import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/controller/work_orders_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/calender_card.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/icon_square.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientHeader extends GetView<WorkOrdersController>
    implements PreferredSizeWidget {
  const GradientHeader({super.key});

  @override
  WorkOrdersController get controller => Get.find<WorkOrdersController>();

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top; // status-bar height
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, top + 8, 16, 12), // <-- no overlap
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Breakdown Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SearchField(
                  onChanged: (v) => controller.query.value = v,
                ),
              ),
              const SizedBox(width: 12),
              IconSquare(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      insetPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      backgroundColor:
                          Colors.transparent, // keep backdrop invisible
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // <- little rounding
                        child: const CalendarCard(),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  CupertinoIcons.calendar,
                  color: Color(0xFF2F6BFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
