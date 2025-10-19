// Preventive Maintenance screen inspired by the screenshot
// Uses GetX for state + a TabBar (Work Order, History, M/C Info)
// Drop this into your project and navigate to PreventiveMaintenancePage()

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* ---------------------- THEME ---------------------- */
class _C {
  static const primary = Color(0xFF2F6BFF);
  static const surface = Colors.white;
  static const bg = Color(0xFFF6F7FB);
  static const text = Color(0xFF1F2430);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE9EEF5);
  static const danger = Color(0xFFE53935);
}

/* ---------------------- CONTROLLER ---------------------- */
class PreventiveMaintenanceWorkOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tab;

// Expansion states
  final pmScheduleOpen = true.obs;
  final pendingActivityOpen = false.obs;
  final mfgContactOpen = false.obs;
  final assetsHistoryOpen = false.obs;
  final assetsMasterOpen = true.obs;
  final dashboardOpen = false.obs;

// Data (mock/demo) – wire these to your models / API
  final maintenanceType = 'Half Yearly Comprehensive\nMaintenance'.obs;
  final dueDateText = 'Due by 30 Mar 2025'.obs;
  final requiredHrs = '4 Hrs required'.obs;
  final pendingActivityCount = 2.obs;

  final assetName = 'CNC-1';
  final assetBrand = 'Siemens';
  final assetDesc = 'CNC Vertical Assets Center where we make housing';
  final assetStatus = 'Working';
  final critical = true.obs;

  @override
  void onInit() {
    tab = TabController(vsync: this, length: 3);
    super.onInit();
  }

  @override
  void onClose() {
    tab.dispose();
    super.onClose();
  }

  void toggle(RxBool r) => r.value = !r.value;
}
