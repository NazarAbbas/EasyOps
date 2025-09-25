// asset_store.dart
import 'package:easy_ops/features/work_order_management/create_work_order/models/assets_data.dart';
import 'package:get/get.dart';

class AssetDataStore extends GetxService {
  final data = Rxn<AssetsData>(); // null until loaded

  Future<void> load(Future<AssetsData> Function() fetcher) async {
    data.value = await fetcher();
  }

  // Helpers (minimal, like your DropDownStore.ofType)

  /// All assets, sorted by name ASC
  List<AssetItem> all() => (data.value?.content.toList() ?? [])
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  /// Filter by status (e.g. "ACTIVE"), sorted by name ASC
  List<AssetItem> byStatus(String status) => (data.value?.content
          .where((e) => e.status.toLowerCase() == status.toLowerCase())
          .toList() ??
      [])
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  /// Filter by criticality (e.g. "HIGH"), sorted by name ASC
  List<AssetItem> byCriticality(String criticality) => (data.value?.content
          .where(
              (e) => e.criticality.toLowerCase() == criticality.toLowerCase())
          .toList() ??
      [])
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}
