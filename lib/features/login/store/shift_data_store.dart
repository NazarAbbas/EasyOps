import 'package:get/get.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/models/shift_data.dart';

// If your page class is ShiftPage (as in my earlier model), use ShiftPage.
// If it's ShiftData in your codebase, just rename below accordingly.
class ShiftDataStore extends GetxService {
  final data = Rxn<ShiftData>(); // or Rxn<ShiftData>()

  Future<void> load(Future<ShiftData> Function() fetcher) async {
    data.value = await fetcher();
  }

  // Helpers (optional)
  List<Shift> all() => List<Shift>.from(data.value?.content ?? const []);
  Shift? byId(String id) =>
      data.value?.content.firstWhereOrNull((e) => e.id == id);

  // Sorted by start time then name
  List<Shift> sorted() {
    final list = all();
    list.sort((a, b) {
      int sa(String t) {
        final p = t.split(':');
        return (int.tryParse(p[0]) ?? 0) * 3600 +
            (int.tryParse(p[1]) ?? 0) * 60 +
            (p.length > 2 ? int.tryParse(p[2]) ?? 0 : 0);
      }

      final by = sa(a.startTime).compareTo(sa(b.startTime));
      return by != 0
          ? by
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return list;
  }
}
