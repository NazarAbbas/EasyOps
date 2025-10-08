import 'dart:convert';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/ui/models/work_orders_response.dart';
import 'package:flutter/services.dart' show rootBundle;

// parse into your model
Future<WorkOrdersResponse> loadWorkOrdersFromAsset() async {
  final jsonStr =
      await rootBundle.loadString('assets/mock_json/work_orders.json');
  final Map<String, dynamic> map = jsonDecode(jsonStr);
  return WorkOrdersResponse.fromJson(map);
}
