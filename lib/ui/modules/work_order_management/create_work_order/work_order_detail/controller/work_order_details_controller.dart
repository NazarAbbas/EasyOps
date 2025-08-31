// ignore: file_names
import 'dart:ui';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:get/get.dart';

class WorkOrderDetailsController extends GetxController {
  // You can populate these from API
  final title = 'Work Order Details'.obs;

  final successTitle = 'Work Order Created\nSuccessfully'.obs;
  final successSub = 'Work Order ID - BD265'.obs;

  final reportedBy = 'Ashwath Mohan Mahendran'.obs;

  final operatorName = 'Ajay Kumar (MP18292)'.obs;
  final operatorPhone = '9876543211'.obs;
  final operatorOrg = 'Assets Shop | A'.obs;

  final issueSummary =
      'Tool misalignment and spindle speed issues in Bay 3'.obs;
  final priority = 'High'.obs; // render as red pill
  final category = 'Mechanical'.obs;

  final time = '18:08'.obs;
  final date = '09 Aug'.obs;

  final line = 'CNC - 1 (22465462)'.obs;
  final location = 'Assets Shop | Plant A'.obs;

  final headline = 'CNC Vertical Assets Center where we make housing'.obs;
  final description =
      'Tool misalignment and spindle speed issues in Bay 3 causing uneven cuts and delays. Immediate attention needed.'
          .obs;

  // Thumbnails (use your real images; placeholders used here)
  final thumbs = <Color>[
    const Color(0xFFDEE9FF),
    // const Color(0xFFDFF6E1),
    // const Color(0xFFFFEDD5),
  ].obs;

  void goToListing() =>
      Get.offAllNamed(Routes.workOrderScreen); // Replace with your navigation
}
