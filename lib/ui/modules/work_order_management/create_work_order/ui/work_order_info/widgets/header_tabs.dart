import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/controller/WorkTabsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderTabs extends GetView<WorkTabsController> {
  const HeaderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final segW = c.maxWidth / controller.tabs.length;
        return Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: List.generate(controller.tabs.length, (i) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.selectedTab.value = i,
                      child: SizedBox(
                        height: 38,
                        child: Center(
                          child: Obx(() {
                            final active = controller.selectedTab.value == i;
                            return Text(
                              controller.tabs[i],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: active
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // underline
            Obx(() {
              final left = 8 + controller.selectedTab.value * segW;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                left: left,
                bottom: 0,
                width: segW - 16,
                height: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
