// lib/ui/modules/maintenance_work_order/return_spare_parts/controller/return_spare_controller.dart
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure/controller/closure_controller.dart'
    show SpareReturnItem;
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/models/spare_parts_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MEReturnSparesController extends GetxController {
  final isSaving = false.obs;
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  /// Demo catalog. Replace with repo call in real app.
  final RxList<SpareItem> items = <SpareItem>[
    SpareItem(name: 'Spindle Motor', code: 'SM-1001', cost: 10, requested: 10),
    SpareItem(name: 'Ball Screws', code: 'BS-2002', cost: 10, requested: 10),
    SpareItem(
        name: 'Linear Guide Rails', code: 'LGR-3003', cost: 10, requested: 10),
    SpareItem(name: 'Tool Holders', code: 'TH-4004', cost: 10, requested: 10),
    SpareItem(name: 'Cutting Tools', code: 'CT-5005', cost: 10, requested: 10),
    SpareItem(
        name: 'Proximity Sensors', code: 'PS-8008', cost: 10, requested: 10),
  ].obs;

  WorkOrders? workOrderInfo;

  int get totalReturning => items.fold(0, (sum, e) => sum + e.returning.value);

  @override
  void onInit() async {
    super.onInit();

    // Load current WO from bag/shared store
    workOrderInfo = await SharePreferences.getObject(
      Constant.workOrder,
      WorkOrders.fromJson,
    );

    // Prefill from arguments: expecting List<SpareReturnItem> (from Closure screen)
    final arg = Get.arguments;
    if (arg is List<SpareReturnItem>) {
      final mapByCode = {
        for (final it in arg) it.id: it
      }; // in Closure, id == code
      for (final item in items) {
        final pre = mapByCode[item.code];
        if (pre != null) {
          item.returning.value = pre.nos.clamp(0, item.requested);
        }
      }
    }
  }

  void inc(SpareItem item) {
    if (item.returning.value < item.requested) {
      item.returning.value++;
    }
  }

  void dec(SpareItem item) {
    if (item.returning.value > 0) {
      item.returning.value--;
    }
  }

  Future<void> onReturn() async {
    if (workOrderInfo == null || (workOrderInfo!.id).isEmpty) {
      Get.snackbar(
        'Missing Work Order',
        'Could not find the current work order.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    // Build result for Closure screen: List<SpareReturnItem>
    final List<SpareReturnItem> selected = items
        .where((e) => e.returning.value > 0)
        .map((e) => SpareReturnItem(
              id: e.code, // using code as unique id
              name: e.name,
              nos: e.returning.value, // quantity to return
              cost: e.cost, // total/line cost if you have it, else unit cost
            ))
        .toList();

    // If nothing selected, just notify and stay
    if (selected.isEmpty) {
      Get.snackbar(
        'No Items Selected',
        'Please choose at least one spare to return.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    // Build API request payload for returning spares.
    // NOTE: If your backend expects an internal ID, replace `code` with that ID.
    final List<SparePartsRequest> sparePartsRequest = items
        .where((e) => e.returning.value > 0)
        .map((e) => SparePartsRequest(
              assetSpareId: e.code, // <-- replace with real id if available
              requestedQty: e.returning.value, // quantity being returned
              status: 'RETURNED', // or whatever status your API expects
            ))
        .toList();

    try {
      isSaving.value = true;

      final result = await repositoryImpl.sendBulkSpareRequest(
        workOrderInfo!.id,
        sparePartsRequest,
      );

      if (result.httpCode == 200 && result.data != null) {
        // Pop back to caller with the chosen items so totals can update
        Get.back(result: selected);

        Get.snackbar(
          'Spares Returned',
          'Returning $totalReturning item(s).',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black87,
        );
      } else {
        Get.snackbar(
          'Unable to submit',
          (result.message?.trim().isNotEmpty ?? false)
              ? result.message!
              : 'Unexpected response (code ${result.httpCode}).',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void onDiscard() => Get.back();
}

/// Simple view model for the return screen
class SpareItem {
  final String name;
  final String code; // use a real id if available
  final double cost;
  final int requested; // max returnable
  final RxInt returning;

  SpareItem({
    required this.name,
    required this.code,
    required this.cost,
    required this.requested,
    int initialReturning = 0,
  }) : returning = initialReturning.obs;
}
