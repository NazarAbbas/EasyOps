import 'package:easy_ops/route_managment/routes.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/controller/work_order_details_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/audio_tile.dart'
    show AudioTile;
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/gradient_header.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/kv.dart'
    show KV, Pill;
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/kv_block.dart'
    show KVBlock;
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/success_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Thumb;

import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_detail/widgets/thumb.dart'
    show Thumb;
import 'package:get/get.dart';

class WorkOrderDetailsPage extends StatelessWidget {
  const WorkOrderDetailsPage({super.key});

  WorkOrderDetailsController get controller =>
      Get.put<WorkOrderDetailsController>(WorkOrderDetailsController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double headerH = isTablet ? 120 : 110;
    final double hPad = isTablet ? 18 : 14;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(headerH),
        child: const GradientHeader(title: 'Work Order Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success banner
                  SuccessBanner(
                    title: 'Work Order Created\nSuccessfully',
                    sub: 'Work Order ID - ${controller.workOrderId.value}',
                  ),
                  const SizedBox(height: 12),

                  // Reporter / Operator blocks
                  KVBlock(
                    rows: [
                      KV(
                        label: 'Reported By :',
                        value: controller.reportedBy.value,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  KVBlock(
                    rows: [
                      KV(
                        label: 'Operator :',
                        value: controller.operatorInfo.value,
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFE6EBF3), height: 1),
                  ),

                  // Issue summary with priority pill + category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.issueTitle.value,
                          style: const TextStyle(
                            color: Color(0xFF2D2F39),
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Pill(
                            text: controller.priorityText.value,
                            color: controller.priorityColor.value,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.category.value,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Meta rows
                  Row(
                    children: [
                      Text(
                        controller.metaTimeDate.value,
                        style: const TextStyle(
                          color: Color(0xFF7C8698),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        size: 14,
                        color: Color(0xFFE25555),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          controller.machineLine.value,
                          style: const TextStyle(
                            color: Color(0xFF2D2F39),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.location.value,
                    style: const TextStyle(
                      color: Color(0xFF7C8698),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFE6EBF3), height: 1),
                  ),

                  // Description
                  Text(
                    controller.descTitle.value,
                    style: const TextStyle(
                      color: Color(0xFF2D2F39),
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.descBody.value,
                    style: const TextStyle(
                      color: Color(0xFF2D2F39),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Media row
                  Row(
                    children: const [
                      Thumb(),
                      SizedBox(width: 10),
                      Thumb(),
                      Spacer(),
                      AudioTile(),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
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
              // block
              onPressed: () {
                Get.offAllNamed(Routes.workOrderInfoScreen);
              }, // <-- GetX navigation
              child: const Text(
                'Go to Work Order Listing',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
