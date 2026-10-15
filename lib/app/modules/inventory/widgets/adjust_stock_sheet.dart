import 'package:true_leaf_inventory_app/app/modules/inventory/models/stock_movement.dart';
import 'package:true_leaf_inventory_app/app/modules/inventory/services/stock_service.dart';
import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

/// Returns true if stock was changed.
Future<bool?> showAdjustStockSheet({
  required int productId,
  required String productName,
  required int currentStock,
}) {
  return Get.bottomSheet<bool>(
    _AdjustStockSheet(
      productId: productId,
      productName: productName,
      currentStock: currentStock,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

class _AdjustStockSheet extends StatefulWidget {
  const _AdjustStockSheet({
    required this.productId,
    required this.productName,
    required this.currentStock,
  });

  final int productId;
  final String productName;
  final int currentStock;

  @override
  State<_AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends State<_AdjustStockSheet> {
  final _quantity = TextEditingController();
  final _note = TextEditingController();
  bool _isAdd = true;
  bool _saving = false;
  StockMovementReason _reason = StockMovementReason.restock;

  int get _qty => int.tryParse(_quantity.text.trim()) ?? 0;
  int get _newStock => widget.currentStock + (_isAdd ? _qty : -_qty);

  List<StockMovementReason> get _reasons => _isAdd
      ? const [
          StockMovementReason.restock,
          StockMovementReason.returned,
          StockMovementReason.correction,
          StockMovementReason.other,
        ]
      : const [
          StockMovementReason.damaged,
          StockMovementReason.correction,
          StockMovementReason.other,
        ];

  @override
  void dispose() {
    _quantity.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_qty <= 0) {
      EasyLoading.showError('Enter a quantity greater than 0');
      return;
    }
    if (_newStock < 0) {
      EasyLoading.showError('Stock cannot go below 0');
      return;
    }

    setState(() => _saving = true);
    final ok = await StockService().applyDelta(
      productId: widget.productId,
      productName: widget.productName,
      delta: _isAdd ? _qty : -_qty,
      reason: _reason,
      note: _note.text,
    );
    if (!mounted) return;
    if (ok) {
      EasyLoading.showSuccess('Stock updated');
      Get.back(result: true);
    } else {
      setState(() => _saving = false);
      EasyLoading.showError('Could not update stock');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 2.h,
        right: 2.h,
        top: 2.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adjust stock',
                style:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 0.5.h),
            Text('${widget.productName} - current stock ${widget.currentStock}'),
            SizedBox(height: 2.h),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Add')),
                ButtonSegment(value: false, label: Text('Remove')),
              ],
              selected: {_isAdd},
              onSelectionChanged: (s) => setState(() {
                _isAdd = s.first;
                _reason = _reasons.first;
              }),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _quantity,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 1.5.h),
            DropdownButtonFormField<StockMovementReason>(
              value: _reason,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final r in _reasons)
                  DropdownMenuItem(value: r, child: Text(r.label)),
              ],
              onChanged: (r) => setState(() => _reason = r ?? _reason),
            ),
            SizedBox(height: 1.5.h),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              'New stock: ${_newStock < 0 ? 'invalid' : _newStock}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving...' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
