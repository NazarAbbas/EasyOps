import 'package:easy_ops/ui/modules/break_down_management/break_down_management_dashboard/controller/work_order_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOrderManagement extends StatelessWidget {
  WorkOrderManagement({super.key});
  final WorkOrderManagementController controller = Get.put(WorkOrderManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WorkOrderManagement"),
       // backgroundColor: Colors.blue,
      ),
      body: Container(),
    );
  }
}
