import 'package:true_leaf_inventory_app/app/modules/inventory/models/stock_movement.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/services/stock_service.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

/// Returns true if stock was received.
Future<bool?> showRestockSheet({
  required int productId,
  required String productName,
  required int currentStock,
}) {
  return Get.bottomSheet<bool>(
    _RestockSheet(
      productId: productId,
      productName: productName,
      currentStock: currentStock,
    ),
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

class _RestockSheet extends StatefulWidget {
  const _RestockSheet({
    required this.productId,
    required this.productName,
    required this.currentStock,
  });

  final int productId;
  final String productName;
  final int currentStock;

  @override
  State<_RestockSheet> createState() => _RestockSheetState();
}

class _RestockSheetState extends State<_RestockSheet> {
  final _quantity = TextEditingController();
  final _unitCost = TextEditingController();
  final _reference = TextEditingController();
  List<String> _suppliers = <String>[];
  String? _supplier;
  bool _saving = false;

  final _service = StockService();

  int get _qty => int.tryParse(_quantity.text.trim()) ?? 0;

  @override
  void initState() {
    super.initState();
    _service.fetchSupplierNames().then((names) {
      if (mounted) setState(() => _suppliers = names);
    });
  }

  @override
  void dispose() {
    _quantity.dispose();
    _unitCost.dispose();
    _reference.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_qty <= 0) {
      EasyLoading.showError('Enter a quantity greater than 0');
      return;
    }
    final costText = _unitCost.text.trim();
    final cost = costText.isEmpty ? null : double.tryParse(costText);
    if (costText.isNotEmpty && (cost == null || cost < 0)) {
      EasyLoading.showError('Enter a valid unit cost');
      return;
    }

    setState(() => _saving = true);
    final ok = await _service.applyDelta(
      productId: widget.productId,
      productName: widget.productName,
      delta: _qty,
      reason: StockMovementReason.restock,
      note: _reference.text,
      supplierName: _supplier ?? '',
      unitCost: cost,
    );
    if (!mounted) return;
    if (ok) {
      EasyLoading.showSuccess('Stock received');
      Get.back(result: true);
    } else {
      setState(() => _saving = false);
      EasyLoading.showError('Could not update stock');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Text('Receive stock',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 0.5.h),
          Text('${widget.productName} - current stock ${widget.currentStock}'),
          SizedBox(height: 2.h),
          DropdownButtonFormField<String>(
            value: _supplier,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Supplier (optional)',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final s in _suppliers)
                DropdownMenuItem(value: s, child: Text(s)),
            ],
            onChanged: (s) => setState(() => _supplier = s),
          ),
          SizedBox(height: 1.5.h),
          TextField(
            controller: _quantity,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Quantity received',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 1.5.h),
          TextField(
            controller: _unitCost,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Unit cost (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 1.5.h),
          TextField(
            controller: _reference,
            decoration: const InputDecoration(
              labelText: 'Invoice / reference (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            'New stock: ${widget.currentStock + _qty}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving...' : 'Receive'),
            ),
          ),
        ],
      ),
    );
  }
}
