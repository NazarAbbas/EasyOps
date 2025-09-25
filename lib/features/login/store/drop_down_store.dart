import 'package:easy_ops/features/work_order_management/create_work_order/models/drop_down_data.dart';
import 'package:get/get.dart';

// Holds your DropDownData in one place
class DropDownStore extends GetxService {
  final data = Rxn<DropDownData>(); // null until loaded

  Future<void> load(Future<DropDownData> Function() fetcher) async {
    data.value = await fetcher();
  }

  // helpers (optional)
  List<DropDownValues> ofType(LookupType t) =>
      (data.value?.content.where((e) => e.lookupType == t).toList() ?? [])
        ..sort((a, b) {
          final by = a.sortOrder.compareTo(b.sortOrder);
          return by != 0 ? by : a.displayName.compareTo(b.displayName);
        });
}
