enum StockMovementReason { restock, damaged, returned, correction, other }

extension StockMovementReasonX on StockMovementReason {
  String get label {
    switch (this) {
      case StockMovementReason.restock:
        return 'Restock';
      case StockMovementReason.damaged:
        return 'Damaged / Expired';
      case StockMovementReason.returned:
        return 'Customer return';
      case StockMovementReason.correction:
        return 'Stock count correction';
      case StockMovementReason.other:
        return 'Other';
    }
  }
}

class StockMovement {
  StockMovement({
    required this.productId,
    required this.productName,
    required this.previousStock,
    required this.newStock,
    required this.reason,
    required this.createdAt,
    this.note = '',
    this.supplierName = '',
    this.unitCost,
  });

  final int productId;
  final String productName;
  final int previousStock;
  final int newStock;
  final StockMovementReason reason;
  final DateTime createdAt;
  final String note;
  final String supplierName;
  final double? unitCost;

  int get delta => newStock - previousStock;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'previous_stock': previousStock,
        'new_stock': newStock,
        'reason': reason.name,
        'created_at': createdAt.toIso8601String(),
        'note': note,
        'supplier_name': supplierName,
        'unit_cost': unitCost,
      };

  factory StockMovement.fromJson(Map<String, dynamic> json) => StockMovement(
        productId: json['product_id'] as int,
        productName: json['product_name'] as String? ?? '',
        previousStock: json['previous_stock'] as int? ?? 0,
        newStock: json['new_stock'] as int? ?? 0,
        reason: StockMovementReason.values.firstWhere(
          (r) => r.name == json['reason'],
          orElse: () => StockMovementReason.other,
        ),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
        note: json['note'] as String? ?? '',
        supplierName: json['supplier_name'] as String? ?? '',
        unitCost: (json['unit_cost'] as num?)?.toDouble(),
      );
}
