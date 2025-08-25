import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/assest_management_dashboard_controller.dart';

class AssestManagementDashboard extends StatelessWidget {
   AssestManagementDashboard({super.key});
   final AssestManagementDashboardController controller = Get.put(AssestManagementDashboardController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AssestManagementDashboard"),
      ),
      body: Container(),
    );
  }
}
