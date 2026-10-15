import 'package:intl/intl.dart';
import 'package:true_leaf_inventory_app/app/models/get_all_data_model.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/controllers/inventory_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/models/stock_movement.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/widgets/adjust_stock_sheet.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/widgets/restock_sheet.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.greyLightColor,
        appBar: AppBar(
          title: const Text('Inventory'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Overview'), Tab(text: 'History')],
          ),
        ),
        body: Column(
          children: [
            _searchAndSort(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.value.isNotEmpty &&
                    controller.products.isEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }
                return TabBarView(
                  children: [_overview(), _history()],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchAndSort() {
    return Padding(
      padding: EdgeInsets.fromLTRB(1.5.h, 1.h, 0.5.h, 0),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              hint: 'Search products...',
              onChanged: controller.onSearchChanged,
            ),
          ),
          Obx(
            () => PopupMenuButton<InventorySortMode>(
              tooltip: 'Sort products',
              initialValue: controller.sortMode.value,
              onSelected: controller.setSortMode,
              icon: const Icon(Icons.sort, color: AppColors.primaryColor),
              itemBuilder: (context) => [
                for (final entry in const {
                  InventorySortMode.name: 'Sort by Name',
                  InventorySortMode.stockLowToHigh: 'Stock: Low to High',
                  InventorySortMode.stockHighToLow: 'Stock: High to Low',
                }.entries)
                  CheckedPopupMenuItem<InventorySortMode>(
                    value: entry.key,
                    checked: controller.sortMode.value == entry.key,
                    child: Text(entry.value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final _money = NumberFormat.currency(symbol: '\$');
  static final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

  Widget _overview() {
    final outOfStock = controller.outOfStock;
    final lowStock = controller.lowStock;
    // Strings are section headers, products are rows; built lazily below.
    final rows = <Object>[
      if (outOfStock.isNotEmpty) 'Out of stock',
      ...outOfStock,
      if (lowStock.isNotEmpty)
        'Low stock (${InventoryController.lowStockThreshold} or fewer)',
      ...lowStock,
    ];

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView.builder(
        padding: EdgeInsets.all(2.h),
        itemCount: rows.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Wrap(
                spacing: 1.h,
                runSpacing: 1.h,
                children: [
                  _stat('Products', '${controller.totalProducts}'),
                  _stat('Units in stock', '${controller.totalUnits.value}'),
                  _stat('Stock value',
                      _money.format(controller.inventoryValue.value)),
                  _stat('Low stock', '${controller.lowStockCount.value}',
                      color: Colors.orange),
                  _stat('Out of stock', '${controller.outOfStockCount.value}',
                      color: Colors.red),
                ],
              ),
            );
          }
          final row = rows[i - 1];
          if (row is String) {
            return Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(row,
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.w600)),
            );
          }
          return _productRow(row as GetDataListResponseData);
        },
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) {
    return SizedBox(
      width: 22.h,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11.sp)),
              SizedBox(height: 0.5.h),
              Text(value,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productRow(GetDataListResponseData p) {
    return Card(
      child: ListTile(
        title: Text(p.name ?? 'Unnamed'),
        subtitle: Text('Stock: ${p.stock ?? 0}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => showRestockSheet(
                productId: p.id!,
                productName: p.name ?? '',
                currentStock: p.stock ?? 0,
              ),
              child: const Text('Restock'),
            ),
            TextButton(
              onPressed: () => showAdjustStockSheet(
                productId: p.id!,
                productName: p.name ?? '',
                currentStock: p.stock ?? 0,
              ),
              child: const Text('Adjust'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _history() {
    final movements = controller.visibleMovements;
    if (movements.isEmpty) {
      return const Center(child: Text('No stock adjustments found'));
    }
    final format = _dateFormat;
    return ListView.builder(
      padding: EdgeInsets.all(2.h),
      itemCount: movements.length,
      itemBuilder: (_, i) => _movementTile(movements[i], format),
    );
  }

  Widget _movementTile(StockMovement m, DateFormat format) {
    final positive = m.delta > 0;
    return Card(
      child: ListTile(
        title: Text(m.productName),
        subtitle: Text([
          '${m.reason.label} - ${format.format(m.createdAt)}',
          '${m.previousStock} -> ${m.newStock}',
          if (m.supplierName.isNotEmpty) 'Supplier: ${m.supplierName}',
          if (m.unitCost != null) 'Unit cost: ${m.unitCost!.toStringAsFixed(2)}',
          if (m.note.isNotEmpty) m.note,
        ].join('\n')),
        trailing: Text(
          '${positive ? '+' : ''}${m.delta}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: positive ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
