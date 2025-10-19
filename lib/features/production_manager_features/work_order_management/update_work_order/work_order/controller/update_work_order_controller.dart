// work_order_details_controller.dart
// ignore: file_names
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateWorkOrderDetailsController extends GetxController {
  // Header
  final title = 'Work Order Details'.obs;

  // Operator
  final operatorName = ''.obs;
  final operatorInfo = ''.obs;
  final operatorPhoneNumber = ''.obs;

  // Banner
  final successTitle = 'Work Order Created\nSuccessfully'.obs;
  final successSub = 'Work Order ID - BD265'.obs;

  // Reporter / Operator (will be overridden from operator draft if present)
  final reportedBy = ''.obs;

  // Summary (from work order info)
  final descriptionText =
      ''.obs; // descriptionText (fallback: problemDescription)
  final priority = ''.obs; // impact
  final issueType = ''.obs; // issueType

  // Time / Date (from operator draft)
  final time = ''.obs; // HH:mm
  final date = ''.obs; // dd MMM

  // Location line under summary (you can join location + plant)
  final line = ''.obs; // keep for your own line text if needed
  final location = ''.obs; // "Location | Plant"

  // Body
  final headline = ''.obs; // typeText
  final problemDescription = ''.obs; // problemDescription

  // Media (from work order info)
  final photoPaths = <String>[].obs;
  final voiceNotePath = ''.obs;

  final cnc_1 = 'CNC-1'.obs;

  @override
  void onInit() {
    super.onInit();

    final workTabsController = Get.find<UpdateWorkTabsController>();
    final workOrderInfo = workTabsController.workOrder;
    final x = '';

// If `reportedBy` is RxnString (nullable Rx):
    reportedBy.value = workOrderInfo?.reportedBy?.trim().isEmpty ?? true
        ? 'Operator (Self)'
        : workOrderInfo!.reportedBy!.trim();

    date.value = _formatDate(workOrderInfo!.createdAt);
    priority.value = workOrderInfo.priority;
    problemDescription.value = workOrderInfo.description;
    descriptionText.value = workOrderInfo.remark!;
  }
  // --------- Helpers ---------

  String _formatDate(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];

    return '$hh:$mm | $day $month';
  }

  void closeWorkOrder() {
    Get.toNamed(Routes.closureWorkOrderScreen);
  }

  void reOpenWorkOrder() {
    Get.toNamed(Routes.reOpenWorkOrderScreen);
  }
}
