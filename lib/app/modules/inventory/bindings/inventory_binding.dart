import 'package:true_leaf_inventory_app/app/modules/inventory/controllers/inventory_controller.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryController>(() => InventoryController());
  }
}
