import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/controllers/inventory_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/models/stock_movement.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/repositories/stock_movement_store.dart';
import 'package:true_leaf_inventory_app/app/modules/product_details/repositories/product_details_repository.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

/// Applies stock changes without needing the inventory screen's state.
class StockService {
  StockService({
    ProductDetailsRepository? repository,
    StockMovementStore? store,
  })  : _repository = repository ?? ApiProductDetailsRepository(),
        _store = store ?? StockMovementStore();

  final ProductDetailsRepository _repository;
  final StockMovementStore _store;

  /// Applies [delta] to the server's current stock so concurrent changes are not overwritten.
  Future<bool> applyDelta({
    required int productId,
    required String productName,
    required int delta,
    required StockMovementReason reason,
    String note = '',
    String supplierName = '',
    double? unitCost,
  }) async {
    if (delta == 0) return false;

    final details = await _repository.fetchProductDetails(productId.toString());
    final current = int.tryParse('${details.data?.stock}');
    if (current == null) return false;

    final newStock = current + delta;
    if (newStock < 0) {
      EasyLoading.showError('Only $current in stock');
      return false;
    }

    final response =
        await _repository.updateProduct(productId.toString(), {'stock': newStock});
    if (response == null) return false;

    await _store.add(StockMovement(
      productId: productId,
      productName: productName,
      previousStock: current,
      newStock: newStock,
      reason: reason,
      note: note.trim(),
      supplierName: supplierName,
      unitCost: unitCost,
      createdAt: DateTime.now(),
    ));

    if (Get.isRegistered<InventoryController>()) {
      Get.find<InventoryController>().onStockChanged(productId, newStock);
    }
    if (Get.isRegistered<ProductsController>()) {
      Get.find<ProductsController>().getProductAPI(isLoading: false);
    }
    return true;
  }

  Future<List<String>> fetchSupplierNames() async {
    try {
      final data = await APIFunction().apiCall(
        apiName: Constants.suppliers,
        context: Get.context!,
        token: accessToken,
        type: 'get',
        isLoading: false,
      );
      final model = GetDataListResponseModel.fromJson(data);
      return <String>{
        ...?model.suppliers?.map((s) => s.supplierName ?? ''),
        ...?model.data?.map((s) => s.supplierName ?? ''),
      }.where((n) => n.trim().isNotEmpty).toList()
        ..sort();
    } catch (_) {
      return <String>[];
    }
  }
}
