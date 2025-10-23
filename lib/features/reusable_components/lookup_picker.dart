// reason_picker.dart
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/reusable_components/picker_bottom_sheet.dart';

class LookupPicker {
  static Future<LookupValues?> show({
    required BuildContext context,
    required String lookupType, // e.g. "resolution"
    required LookupValues? selected,
    String lookupCode = '',
    String title = 'Select',
  }) async {
    //final lookupRepository = Get.find<LookupRepository>();
    final repository = Get.find<DBRepository>();
    List<LookupValues>? serverItems;
    if (lookupCode.isEmpty) {
      final type = _parseLookupType(lookupType);
      serverItems = await repository.getLookupByType(type);
    } else {
      serverItems = await repository.getLookupByCode(lookupCode);
    }

    // Remove any placeholder-like entries + empty IDs (safety)
    final items = serverItems!
        .where((e) =>
            e.id.isNotEmpty &&
            e.displayName.trim().toLowerCase() != 'select reason')
        .toList();

    // Try to match currently selected by id inside this list
    final LookupValues? initialSelected =
        (selected == null || selected.id.isEmpty)
            ? null
            : items.firstWhereOrNull((e) => e.id == selected.id);

    // Show sheet without a “Select reason” row
    return PickerBottomSheet.show<LookupValues>(
      // ignore: use_build_context_synchronously
      context: context,
      title: title,
      items: items,
      selected: initialSelected, // can be null if none yet
      labelOf: (lv) => lv.displayName,
      codeOf: (lv) => lv.code,
      avatarTextOf: (lv) =>
          (lv.displayName.isNotEmpty ? lv.displayName[0].toUpperCase() : '?'),
    );
  }

  static LookupType _parseLookupType(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'resolution':
        return LookupType.resolution;
      case 'department':
        return LookupType.department;
      case 'issuetype':
        return LookupType.department;
      case 'impact':
        return LookupType.impact;
      case 'assetcat1':
        return LookupType.assetcat1;
      default:
        return LookupType.resolution;
    }
  }
}
