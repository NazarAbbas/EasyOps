import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkorderInfoController extends GetxController {
  // Form fields
  final issueTypes = ['Electrical', 'Mechanical', 'Hydraulic'];
  final impacts = ['Low', 'Medium', 'High'];

  final issueType = RxnString();
  final impact = RxnString();
  final assetNumberCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final problemCtrl = TextEditingController();

  // Derived “Type” (just placeholder)
  String get typeLabel => (issueType.value == null) ? '-' : issueType.value!;

  @override
  void onClose() {
    assetNumberCtrl.dispose();
    descriptionCtrl.dispose();
    problemCtrl.dispose();
    super.onClose();
  }
}
