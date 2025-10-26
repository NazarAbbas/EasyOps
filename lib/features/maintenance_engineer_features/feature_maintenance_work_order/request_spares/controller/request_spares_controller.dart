import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/api_result.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/utils/utils.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/WorkTabsController.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/models/spare_parts_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/controller/spare_cart_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/models/spares_models.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:get/get.dart';

import '../../maintenance_wotk_order_management/models/work_order.dart';

/// One shared SpareCartController (bound in GlobalBindings).
class MaintenanceEnginnerSparesRequestController extends GetxController {
  final cartCtrl = Get.find<MaintenanceEnginnerSpareCartController>();
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  // -------- Inputs to the query --------
  String assetId = '';

  // -------- Lookups --------
  final _all = <LookupValues>[].obs;
  final cat1Options = <LookupValues>[].obs; // ASSETCAT1
  final cat2Options = <LookupValues>[].obs; // filtered by selected Cat1.code

  final selectedCat1 = Rxn<LookupValues>();
  final selectedCat2 = Rxn<LookupValues>();

  // -------- UI state / results --------
  final showResults = false.obs;

  /// UI expects SpareItem for list rendering
  final results = <SpareItem>[].obs;

  final qtyDraft = <String, int>{}.obs; // itemId -> qty
  final stockLeft = <String, int>{}.obs; // itemId -> remaining stock (UI only)
  final isSubmitting = false.obs;
  WorkOrders? workOrderInfo;
  // -------- Derived --------
  int get cartCount => cartCtrl.cart.length;

  int get draftTotal => qtyDraft.values.fold(0, (s, v) => s + v);

  int leftFor(String id) {
    final base = stockLeft[id] ??
        results.firstWhereOrNull((e) => e.id == id)?.stock ??
        0;

    final inCart =
        cartCtrl.cart.firstWhereOrNull((l) => l.item.id == id)?.qty ?? 0;

    final remaining = base - inCart;
    return remaining < 0 ? 0 : remaining;
  }

  String _lookupTypeAsString(LookupValues e) {
    final dynamic lt = e.lookupType; // lookupType can be String or LookupType
    if (lt == null) return '';

    if (lt is String) {
      return lt; // already a String
    } else if (lt is LookupType) {
      return lt.name; // convert enum to String
    } else {
      // Fallback: best-effort stringify; trims 'LookupType.xxx' to 'xxx'
      final s = lt.toString();
      final i = s.indexOf('.');
      return i >= 0 ? s.substring(i + 1) : s;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // get assetId from WorkTabsController
    final workTabsController =
        Get.find<MaintenanceEngineerWorkTabsController>();
    if (workTabsController.workOrder == null) {
      workOrderInfo = getWorkOrderFromArgs(Get.arguments);
    } else {
      workOrderInfo = workTabsController.workOrder;
    }
    assetId = workOrderInfo?.asset.id ?? '';

    // If you already have lookup values, call loadLookups(_yourList_)

    // Rebuild Cat-2 when Cat-1 changes (based on Cat-1.code)
    ever<LookupValues?>(selectedCat1, (c1) {
      selectedCat2.value = null;
      if (c1 == null) {
        cat2Options.clear();
        return;
      }
      final key = (c1.code ?? '').trim();
      if (key.isEmpty) {
        cat2Options.clear();
        return;
      }

      // Cat-2 rows use lookupType == selected Cat-1.code (e.g. "ASSET-CAT12")
      cat2Options.assignAll(
        _all.where((e) => _lookupTypeAsString(e).trim() == key),
      );
    });
  }

  /// Optional helper if you want to seed lookup lists locally
  void loadLookups(List<LookupValues> items) {
    _all.assignAll(items);
    cat1Options.assignAll(
      _all.where(
        (e) => _lookupTypeAsString(e).trim().toUpperCase() == 'ASSETCAT1',
      ),
    );
    // If Cat1 is already selected, rebuild Cat2 with its code
    final c1 = selectedCat1.value;
    if (c1 != null) {
      final key = (c1.code ?? '').trim();
      cat2Options.assignAll(
        _all.where((e) => _lookupTypeAsString(e).trim() == key),
      );
    }
  }

  // -------- Selections --------
  void selectCat1(LookupValues? v) => selectedCat1.value = v;

  void selectCat2(LookupValues? v) => selectedCat2.value = v;

  // -------- Search / Actions --------
  Future<void> go({bool prefillFromCart = false}) async {
    final c1 = selectedCat1.value;
    final c2 = selectedCat2.value;
    if (assetId.isEmpty || c1 == null || c2 == null) return;

    try {
      isSubmitting.value = true;

      final ApiResult<List<SparePartsResponse>> res =
          await repositoryImpl.spareParts(
        'AST-30Sep2025030526669006', //assetId
        'CLU-23Oct2025103143874011', //c1.id
        'CLU-23Oct2025103519159013', //c2.id
      );

      if (res.httpCode == 200 && res.data != null) {
        final items = res.data!
            .map((p) => SpareItem(
                id: p.id,
                name: p.partName,
                code: p.partNumber,
                stock: p.quantity!,
                cost: p.cost!))
            .toList();

        results
          ..clear()
          ..addAll(items);

        // stocks for UI
        for (final it in results) {
          stockLeft[it.id] = it.stock;
        }

        // IMPORTANT: don't wipe user draft when prefilling
        if (!prefillFromCart) qtyDraft.clear();
        for (final it in results) {
          qtyDraft.putIfAbsent(it.id, () => 0);
        }
        if (prefillFromCart) _seedDraftWithCart();

        showResults.value = true;
      } else {
        showResults.value = false;
        Get.snackbar('Error', res.message ?? 'Failed to fetch spares');
      }
    } catch (e) {
      showResults.value = false;
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void _seedDraftWithCart() {
    for (final l in cartCtrl.cart) {
      final id = l.item.id;
      final q = l.qty ?? 0;
      if (q > 0) qtyDraft[id] = q;
    }
    qtyDraft.refresh();
  }

  void inc(String id) {
    final it = results.firstWhereOrNull((e) => e.id == id);
    if (it == null) return;
    final cur = qtyDraft[id] ?? 0;
    final left = leftFor(id);
    if (left == 0 || cur >= left) return;
    qtyDraft[id] = cur + 1;
  }

  void dec(String id) {
    final cur = qtyDraft[id] ?? 0;
    if (cur <= 0) return;
    qtyDraft[id] = cur - 1;
  }

  /// Move draft quantities to SHARED cart and decrement local stock.
  void addToCart() {
    final c1Id = selectedCat1.value?.id;
    final c2Id = selectedCat2.value?.id;

    for (final it in results) {
      final draft = qtyDraft[it.id] ?? 0;
      if (draft <= 0) continue;

      final left = leftFor(it.id);
      final toAdd = draft <= left ? draft : left;
      if (toAdd <= 0) continue;

      // results already hold SpareItem, so pass directly
      cartCtrl.addOrMerge(it, toAdd, cat1: c1Id, cat2: c2Id);

      stockLeft[it.id] = left - toAdd;
      qtyDraft[it.id] = 0;
    }

    stockLeft.refresh();
    qtyDraft.refresh();
    showResults.value = false;
  }

  Future<void> addMore() async {
    if (results.isEmpty) {
      await go(prefillFromCart: true);
    } else {
      _seedDraftWithCart();
      showResults.value = true;
    }
  }

  void viewCart() => Get.toNamed(
        Routes.maintenanceEngeneersparesCartScreen,
        arguments: {
          Constant.workOrderInfo: workOrderInfo,
          Constant.workOrderStatus: WorkOrderStatus.open,
        },
      );

  // Optional: edit/remove by key if you expose keys in the cart
  void updateLineQty(String key, int qty) {
    final i = cartCtrl.cart.indexWhere((e) => e.key == key);
    if (i < 0) return;
    cartCtrl.cart[i].qty = qty < 1 ? 1 : qty;
    cartCtrl.cart.refresh();
  }

  void removeLine(String key) => cartCtrl.delete(key);

  void resetAll() => cartCtrl.resetCart();

  void removeCartLine(dynamic line) {
    cartCtrl.cart.remove(line);
    cartCtrl.cart.refresh();
  }

  void updateCartLineQty(dynamic line, int qty) {
    if (line == null) return;

    if (qty <= 0) {
      removeCartLine(line);
      return;
    }

    // cap to stock if your line carries stock on the item
    final int maxStock = (line.item?.stock ?? 999999) is int
        ? (line.item?.stock ?? 999999) as int
        : ((line.item?.stock ?? 999999).toInt());

    line.qty = qty > maxStock ? maxStock : qty;

    cartCtrl.cart.refresh();
  }
}
