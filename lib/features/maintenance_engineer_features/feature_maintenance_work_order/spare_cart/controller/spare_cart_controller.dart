import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/models/spares_models.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_order/controller/me_start_work_order_controller.dart';

class MaintenanceEnginnerSpareCartController extends GetxController {
  final RxList<CartLine> cart = <CartLine>[].obs;
  final RxSet<String> editingKeys = <String>{}.obs;

  static const _kCart = 'spare_cart_v1';
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadCart(); // load persisted cart
    ever<List<CartLine>>(cart, (_) => _saveCart()); // save on any change
  }

  /* ---------- public API (unchanged signatures) ---------- */

  /// Adds/merges by item + **category names** (cat1/cat2 are names).
  void addOrMerge(SpareItem it, int qty, {String? cat1, String? cat2}) {
    if (qty <= 0) return;

    final c1 = _clean(cat1); // treat as names
    final c2 = _clean(cat2);

    final key = _makeKey(it, c1, c2);
    final i = cart.indexWhere((e) => e.key == key);

    if (i >= 0) {
      cart[i].qty += qty;
      cart.refresh();
    } else {
      cart.add(CartLine(key: key, item: it, qty: qty, cat1: c1, cat2: c2));
    }
  }

  List<CartGroup> grouped() {
    final map = <String, CartGroup>{};
    for (final l in cart) {
      final k = '${l.cat1 ?? "-"}|${l.cat2 ?? "-"}'; // group by names
      map.putIfAbsent(k, () => CartGroup(l.cat1, l.cat2)).lines.add(l);
    }
    return map.values.toList();
  }

  void toggleEdit(String key) => editingKeys.contains(key)
      ? editingKeys.remove(key)
      : editingKeys.add(key);

  void inc(String key) {
    final i = cart.indexWhere((e) => e.key == key);
    if (i < 0) return;
    cart[i].qty++;
    cart.refresh();
  }

  void dec(String key) {
    final i = cart.indexWhere((e) => e.key == key);
    if (i < 0) return;
    if (cart[i].qty > 1) {
      cart[i].qty--;
      cart.refresh();
    }
  }

  void delete(String key) => cart.removeWhere((e) => e.key == key);

  Future<void> resetCart() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset Cart?'),
        content: const Text('This will remove all items from the cart.'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Reset')),
        ],
      ),
    );
    if (ok == true) cart.clear();
  }

  Future<void> placeOrder() async {
    if (cart.isEmpty) {
      Get.snackbar('Cart Empty', 'Please add items first.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final start =
        Get.isRegistered<MaintenanceEnginnerStartWorkOrderController>()
            ? Get.find<MaintenanceEnginnerStartWorkOrderController>()
            : Get.put(MaintenanceEnginnerStartWorkOrderController(),
                permanent: true);

    // hand over to WO
    start.addSparesFromCart(cart.toList());

    // clear & close
    cart.clear();
    editingKeys.clear();

    if (Get.key.currentState?.canPop() ?? false) Get.back();
    if (Get.key.currentState?.canPop() ?? false) Get.back();

    Get.snackbar('Order Placed', 'Spares added to Work Order.',
        snackPosition: SnackPosition.BOTTOM);
  }

  /* ---------- private ---------- */

  // Key uses item.id + **category names** (cat1/cat2 are names)
  String _makeKey(SpareItem it, String? cat1, String? cat2) =>
      '${it.id}__${cat1 ?? ""}__${cat2 ?? ""}';

  String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
    // ensures empty strings don't pollute keys/storage
  }

  void _saveCart() {
    _box.write(
      _kCart,
      cart
          .map((l) => {
                'key': l.key,
                'qty': l.qty,
                'cat1': l.cat1, // names persisted
                'cat2': l.cat2, // names persisted
                'item': {
                  'id': l.item.id,
                  'name': l.item.name,
                  'code': l.item.code,
                  'stock': l.item.stock,
                },
              })
          .toList(),
    );
  }

  void _loadCart() {
    final raw = _box.read<List<dynamic>>(_kCart);
    if (raw == null) return;

    final parsed = <CartLine>[];
    for (final x in raw) {
      if (x is! Map) continue;
      final m = Map<String, dynamic>.from(x);
      parsed.add(
        CartLine(
          key: m['key'] as String,
          qty: (m['qty'] as num).toInt(),
          cat1: m['cat1'] as String?, // names restored
          cat2: m['cat2'] as String?, // names restored
          item: SpareItem(
            id: (m['item']?['id'] ?? '') as String,
            name: (m['item']?['name'] ?? '') as String,
            code: (m['item']?['code'] ?? '') as String,
            stock: ((m['item']?['stock']) as num?)?.toInt() ?? 0,
          ),
        ),
      );
    }
    cart.assignAll(parsed);
  }
}

/* helper for grouped UI — unchanged API */
class CartGroup {
  final String? cat1; // NAME
  final String? cat2; // NAME
  final List<CartLine> lines = [];
  CartGroup(this.cat1, this.cat2);
}
