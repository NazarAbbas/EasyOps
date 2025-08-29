import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/controller/work_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tabs extends GetView<WorkOrdersController> {
  const Tabs({super.key});

  @override
  WorkOrdersController get controller => Get.find<WorkOrdersController>();

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Sizes
    final double tabHeight = isTablet ? 44 : 36;
    final double fontSize = isTablet ? 15 : 13.5;
    final double underlineThickness = isTablet ? 3.5 : 3;
    final double sidePad = isTablet ? 10 : 8;

    // Spacing
    final double textUnderlineGap = isTablet
        ? 8
        : 6; // gap between label & underline
    final double underlineSideGap = isTablet
        ? 12
        : 10; // side inset of underline
    final double underlineBottomGap = isTablet ? 6 : 6; // space below underline

    return Container(
      color: AppColors.primaryBlue,
      padding: EdgeInsets.only(
        left: sidePad,
        right: sidePad,
        bottom: underlineBottomGap, // keeps underline off the edge
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = controller.tabs.length;
          final segW = constraints.maxWidth / count;

          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              // Row of labels (only each label depends on selectedTab)
              Padding(
                padding: EdgeInsets.only(
                  bottom: textUnderlineGap + underlineThickness,
                ),
                child: Row(
                  children: List.generate(count, (i) {
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.selectedTab.value = i,
                        child: SizedBox(
                          height: tabHeight,
                          child: Center(
                            child: Obx(() {
                              final bool isActive =
                                  controller.selectedTab.value == i;
                              return Text(
                                controller.tabs[i],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: isActive
                                      ? FontWeight.w900
                                      : FontWeight.w500,
                                  color: Colors.white,
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

              // Underline (depends on selectedTab); using Obx so GetX tracks it
              Obx(() {
                final left =
                    underlineSideGap + controller.selectedTab.value * segW;
                final width = segW - underlineSideGap * 2;

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  left: left,
                  bottom: 0, // bottom gap handled by container padding
                  width: width,
                  height: underlineThickness,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          Colors.white, // or a darker blue to match your mock
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
