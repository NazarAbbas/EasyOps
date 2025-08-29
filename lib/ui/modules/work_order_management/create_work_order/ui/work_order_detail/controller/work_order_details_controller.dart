// ignore: file_names
import 'dart:ui';
import 'package:get/get.dart';

class WorkOrderDetailsController extends GetxController {
  // you can populate these via Get.arguments or an API response
  final workOrderId = 'BD265'.obs;

  final reportedBy = 'Ashwath Mohan Mahendran'.obs;
  final operatorInfo = 'Ajay Kumar (MP18292)\n9876543211\nAssets Shop | A'.obs;

  final issueTitle = 'Tool misalignment and spindle speed issues in Bay 3'.obs;
  final priorityText = 'High'.obs;
  final priorityColor = const Color(0xFFEF4444).obs;
  final category = 'Mechanical'.obs;

  final metaTimeDate = '18:08 | 09 Aug'.obs;
  final machineLine = 'CNC - 1 (22465462)'.obs;
  final location = 'Assets Shop | Plant A'.obs;

  final descTitle = 'CNC Vertical Assets Center where we make housing'.obs;
  final descBody =
      'Tool misalignment and spindle speed issues in Bay 3 causing uneven cuts and delays. Immediate attention needed.'
          .obs;

  // If you want to pass data in: final args = Get.arguments; then map to fields in onInit()
  @override
  void onInit() {
    // Example: if (Get.arguments?['workOrderId'] != null) workOrderId.value = Get.arguments['workOrderId'];
    super.onInit();
  }
}
