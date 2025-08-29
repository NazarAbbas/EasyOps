import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/controller/work_order_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/card.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/labeled.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/operator_info.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/select_box.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/text_field.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/upload_box.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/widgets/value_tile.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/widgets/icon_square.dart';
import 'package:easy_ops/ui/theme/AppInput.dart';
import 'package:easy_ops/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrderInfoPage extends GetView<WorkorderInfoController> {
  const WorkOrderInfoPage({super.key});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    // Spacing + sizes (mobile/tablet)
    final double hPad = isTablet ? 18 : 14;
    final double vPad = isTablet ? 16 : 12;
    final double radius = isTablet ? 14 : 12;
    final double labelSize = isTablet ? 16 : 15;
    final double titleSize = isTablet ? 18 : 16;
    final double btnH = isTablet ? 56 : 52;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 0),
        children: [
          // --- Work Order Info card ---
          CustomCard(
            radius: radius,
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Work Order Info',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D2F39),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Row 1: Issue Type | Impact
                  Row(
                    children: [
                      Expanded(
                        child: Labeled(
                          'Issue Type',
                          labelSize,
                          child: Obx(
                            () => SelectBox(
                              hint: 'Select',
                              value: controller.issueType.value,
                              onTap: () => pick(
                                context,
                                title: 'Issue Type',
                                items: controller.issueTypes,
                                onPick: (v) => controller.issueType.value = v,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Labeled(
                          'Impact',
                          labelSize,
                          child: Obx(
                            () => SelectBox(
                              hint: 'Select',
                              value: controller.impact.value,
                              onTap: () => pick(
                                context,
                                title: 'Impact',
                                items: controller.impacts,
                                onPick: (v) => controller.impact.value = v,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Row 2: Asset Number | Type (+ small refresh icon at far right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Labeled(
                          'Assets Number',
                          labelSize,
                          child: CustomTextField(
                            controller: controller.assetNumberCtrl,
                            hint: 'Search',
                            suffixIcon: const Icon(
                              CupertinoIcons.search,
                              size: 18,
                              color: Color(0xFF9AA3B2),
                            ),
                            decoration: AppInput.fieldDecoration(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Labeled(
                          'Type',
                          labelSize,
                          child: Obx(() => ValueTile(controller.typeLabel)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconSquare(
                        child: Icon(
                          CupertinoIcons.clock,
                          color: Color(0xFF2F6BFF),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Labeled(
                    'Description',
                    labelSize,
                    child: Obx(() => ValueTile(controller.typeLabel)),
                  ),
                  const SizedBox(height: 12),

                  // Problem Description (multiline)
                  Labeled(
                    'Problem Description',
                    labelSize,
                    child: CustomTextField(
                      controller: controller.problemCtrl,
                      hint: 'Write here',
                      minLines: 4,
                      maxLines: 6,
                      decoration: AppInput.fieldDecoration(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Upload photos + mic
                  Row(
                    children: [
                      Expanded(
                        child: UploadBox(
                          onTap: () {},
                          title: 'Upload photos',
                          subtitle: 'Format : jpeg, jpg, png',
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconSquare(
                        child: const Icon(
                          CupertinoIcons.mic,
                          color: Color(0xFF2F6BFF),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // --- Operator Info section ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: OperatorInfo(isTablet: isTablet)),
              const SizedBox(width: 10),
              IconSquare(
                child: const Icon(
                  CupertinoIcons.pencil,
                  color: Color(0xFF2F6BFF),
                ),
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
        child: SizedBox(
          height: btnH,
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2F6BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              Get.toNamed(Routes.workOrderDetailScreen);
            },
            child: Text(
              'Create',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
