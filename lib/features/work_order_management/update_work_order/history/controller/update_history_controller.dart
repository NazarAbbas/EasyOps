// assets_history_page.dart
// deps: get: ^4.x, fl_chart: ^0.68.x (or compatible)

import 'package:easy_ops/features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

/* ───────────────────────── Models ───────────────────────── */
class AssetSummary {
  final String code;
  final String make;
  final String description;
  final String status;
  final String criticality;
  AssetSummary({
    required this.code,
    required this.make,
    required this.description,
    required this.status,
    required this.criticality,
  });
}

class MetricItem {
  final String label;
  final String value;
  MetricItem({required this.label, required this.value});
}

class ChartPoint {
  final String x;
  final double y;
  ChartPoint(this.x, this.y);
}

class UpdateHistoryItem {
  final String date;
  final String category;
  final String type;
  final String title;
  final String person;
  final String duration;
  UpdateHistoryItem({
    required this.date,
    required this.category,
    required this.type,
    required this.title,
    required this.person,
    required this.duration,
  });
}

/* ───────────────────────── Unified Controller ───────────────────────── */
class UpdateHistoryController extends GetxController {
  // Header card data
  final Rx<AssetSummary> asset = Rx<AssetSummary>(
    AssetSummary(
      code: 'CNC-1',
      make: 'Siemens',
      description: 'CNC Vertical Assets Center where we make housing',
      status: 'Working',
      criticality: 'Critical',
    ),
  );

  // Metrics row
  final RxList<MetricItem> metrics = <MetricItem>[
    MetricItem(label: 'MTBF', value: '110 Days'),
    MetricItem(label: 'BD Hours', value: '17 Hrs'),
    MetricItem(label: 'MTTR', value: '2.4 Hrs'),
    MetricItem(label: 'Criticality', value: 'Semi'),
  ].obs;

  // Charts
  final RxList<ChartPoint> breakdownHrs = <ChartPoint>[
    ChartPoint('Jan', 200),
    ChartPoint('Feb', 320),
    ChartPoint('Mar', 910),
    ChartPoint('Apr', 450),
    ChartPoint('May', 980),
    ChartPoint('Jun', 980),
    ChartPoint('Jul', 860),
    ChartPoint('Aug', 210),
    ChartPoint('Sep', 720),
    ChartPoint('Oct', 260),
    ChartPoint('Nov', 640),
    ChartPoint('Dec', 680),
  ].obs;

  final RxList<ChartPoint> sparesConsumption = <ChartPoint>[
    ChartPoint('Jan', 200),
    ChartPoint('Feb', 4200),
    ChartPoint('Mar', -5200),
    ChartPoint('Apr', 800),
    ChartPoint('May', 1200),
    ChartPoint('Jun', -600),
    ChartPoint('Jul', 900),
    ChartPoint('Aug', 1100),
    ChartPoint('Sep', -300),
    ChartPoint('Oct', 500),
    ChartPoint('Nov', 700),
    ChartPoint('Dec', 900),
  ].obs;

  // Machine-wise breakdown hours (as in screenshot)
  final RxList<ChartPoint> machineBreakdown = <ChartPoint>[
    ChartPoint('CNC21', 16),
    ChartPoint('CNC19', 15),
    ChartPoint('CNC18', 15),
    ChartPoint('CNC2', 12),
    ChartPoint('CNC10', 12),
    ChartPoint('CNC12', 12),
    ChartPoint('CNC9', 8),
    ChartPoint('CNC13', 6),
    ChartPoint('CNC1', 5),
    ChartPoint('CNC6', 4),
    ChartPoint('CNC8', 3),
    ChartPoint('CNC15', 3),
    ChartPoint('CNC14', 0),
    ChartPoint('CNC3', 0),
    ChartPoint('CNC7', 0),
  ].obs;

  // History
  final RxList<UpdateHistoryItem> history = <UpdateHistoryItem>[
    UpdateHistoryItem(
      date: '03 Sep 2025',
      category: 'Maintenance',
      type: 'PM',
      title: 'Preventive maintenance completed for spindle unit',
      person: 'Ajay Kumar',
      duration: '1h 32m',
    ),
    UpdateHistoryItem(
      date: '02 Sep 2025',
      category: 'Breakdown',
      type: 'BD',
      title: 'Unexpected vibration detected; bearings inspected and greased',
      person: 'Priya Sharma',
      duration: '48m',
    ),
    UpdateHistoryItem(
      date: '31 Aug 2025',
      category: 'Inspection',
      type: 'QC',
      title: 'Routine inspection—alignment tolerances within limits',
      person: 'Rahul Verma',
      duration: '22m',
    ),
  ].obs;

  // Hooks
  void onHeaderTap() {}
  void onStatusTap() {}
  void goBack() => Get.find<UpdateWorkTabsController>().goTo(0);
}
