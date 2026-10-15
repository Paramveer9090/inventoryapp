import 'dart:async';

import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/models/stock_movement.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/repositories/stock_movement_store.dart';
import 'package:true_leaf_inventory_app/app/modules/products/repositories/products_repository.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

enum InventorySortMode { name, stockLowToHigh, stockHighToLow }

class InventoryController extends GetxController {
  InventoryController({
    ProductsRepository? productsRepository,
    StockMovementStore? store,
  })  : _productsRepository = productsRepository ?? ApiProductsRepository(),
        _store = store ?? StockMovementStore();

  static const int lowStockThreshold = 10;

  final ProductsRepository _productsRepository;
  final StockMovementStore _store;

  final products = <GetDataListResponseData>[].obs;
  final movements = <StockMovement>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final sortMode = InventorySortMode.name.obs;
  Timer? _debounce;

  // Derived state is computed once per change, not on every widget build.
  final outOfStock = <GetDataListResponseData>[].obs;
  final lowStock = <GetDataListResponseData>[].obs;
  final visibleMovements = <StockMovement>[].obs;
  final totalUnits = 0.obs;
  final inventoryValue = 0.0.obs;
  final outOfStockCount = 0.obs;
  final lowStockCount = 0.obs;

  int get totalProducts => products.length;

  void _recompute() {
    final query = searchQuery.value.trim().toLowerCase();
    final out = <GetDataListResponseData>[];
    final low = <GetDataListResponseData>[];
    var units = 0;
    var value = 0.0;
    var outCount = 0;
    var lowCount = 0;

    for (final p in products) {
      final stock = p.stock ?? 0;
      units += stock;
      value += stock * (double.tryParse('${p.sellingPrice}') ?? 0);

      final isOut = stock <= 0;
      final isLow = !isOut && stock <= lowStockThreshold;
      if (!isOut && !isLow) continue;
      if (isOut) {
        outCount++;
      } else {
        lowCount++;
      }
      if (query.isNotEmpty && !(p.name ?? '').toLowerCase().contains(query)) {
        continue;
      }
      (isOut ? out : low).add(p);
    }

    totalUnits.value = units;
    inventoryValue.value = value;
    outOfStockCount.value = outCount;
    lowStockCount.value = lowCount;
    outOfStock.assignAll(_sorted(out));
    lowStock.assignAll(_sorted(low));
    visibleMovements.assignAll(query.isEmpty
        ? movements
        : movements.where((m) => m.productName.toLowerCase().contains(query)));
  }

  List<GetDataListResponseData> _sorted(List<GetDataListResponseData> list) {
    switch (sortMode.value) {
      case InventorySortMode.name:
        final keys = {for (final p in list) p: (p.name ?? '').toLowerCase()};
        list.sort((a, b) => keys[a]!.compareTo(keys[b]!));
      case InventorySortMode.stockLowToHigh:
        list.sort((a, b) => (a.stock ?? 0).compareTo(b.stock ?? 0));
      case InventorySortMode.stockHighToLow:
        list.sort((a, b) => (b.stock ?? 0).compareTo(a.stock ?? 0));
    }
    return list;
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = value;
    });
  }

  void setSortMode(InventorySortMode mode) => sortMode.value = mode;

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    everAll([products, movements, searchQuery, sortMode], (_) => _recompute());
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final model = await _productsRepository.fetchProducts();
      products.assignAll(model.data ?? <GetDataListResponseData>[]);
    } catch (_) {
      errorMessage.value = 'Unable to load inventory. Please try again.';
    } finally {
      movements.assignAll(_store.readAll());
      isLoading.value = false;
    }
  }

  /// Called by StockService after a successful stock change.
  void onStockChanged(int productId, int newStock) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products[index].stock = newStock;
      products.refresh();
    }
    movements.assignAll(_store.readAll());
  }
}
