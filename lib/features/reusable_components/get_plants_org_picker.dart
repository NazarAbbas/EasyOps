// lib/features/reusable_components/plants_org_picker.dart
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:easy_ops/features/reusable_components/picker_bottom_sheet.dart';

import '../production_manager_features/work_order_management/create_work_order/models/get_plants_org.dart';

// lib/features/reusable_components/plants_org_picker.dart// lib/features/reusable_components/plants_org_picker.dart
class PlantsOrgPicker {
  static Future<PlantsOrgItem?> show({
    required BuildContext context,
    required String organizationId, // or clientId based on your needs
    required PlantsOrgItem? selected,
    String title = 'Select Plant',
  }) async {
    final repository = Get.find<DBRepository>();

    // Use tenant-based filtering (or client-based based on your requirements)
    final plants = await repository.getPlantsByTenant(organizationId);

    // Filter out invalid entries
    final items = plants
        .where((e) => e.id.isNotEmpty && e.displayName.trim().isNotEmpty)
        .toList();

    // Match currently selected
    final PlantsOrgItem? initialSelected =
        (selected == null || selected.id.isEmpty)
            ? null
            : items.firstWhereOrNull((e) => e.id == selected.id);

    return PickerBottomSheet.show<PlantsOrgItem>(
      context: context,
      title: title,
      items: items,
      selected: initialSelected,
      labelOf: (plant) => plant.displayName,
      codeOf: (plant) => plant.id, // Using id as code since no code field
      avatarTextOf: (plant) => plant.displayName.isNotEmpty ? plant.displayName[0].toUpperCase() : 'P',
    );
  }
}