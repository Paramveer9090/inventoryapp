import 'package:get_storage/get_storage.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/models/stock_movement.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

/// Device-local movement log until the backend exposes a stock history endpoint.
class StockMovementStore {
  static const _key = 'stock_movements';
  static const _maxEntries = 500;

  // Shared across instances so the JSON is decoded once, not on every build.
  static List<StockMovement>? _cache;

  List<StockMovement> readAll() =>
      List<StockMovement>.unmodifiable(_cache ??= _load());

  List<StockMovement> readForProduct(int productId) =>
      readAll().where((m) => m.productId == productId).toList();

  Future<void> add(StockMovement movement) {
    final all = <StockMovement>[movement, ...(_cache ??= _load())]
        .take(_maxEntries)
        .toList();
    _cache = all;
    return GetStorage()
        .write(_key, jsonEncode(all.map((m) => m.toJson()).toList()));
  }

  List<StockMovement> _load() {
    final raw = GetStorage().read(_key);
    if (raw is! String) return <StockMovement>[];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => StockMovement.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <StockMovement>[];
    }
  }
}
