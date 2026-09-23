class PriceBreakdown {
  final double amountWithoutTax;
  final double amountOnlyTax;
  final double finalAmount;

  const PriceBreakdown({
    required this.amountWithoutTax,
    required this.amountOnlyTax,
    required this.finalAmount,
  });
}

class PriceCalculator {
  static PriceBreakdown calculate({
    required dynamic quantity,
    required dynamic price,
    required dynamic tax,
    dynamic boxSize,
    dynamic isBox,
  }) {
    final itemQuantity = _number(quantity);
    final unitPrice = _number(price);
    final taxRate = _number(tax);
    final packageSize = _number(boxSize, fallback: 1);
    final effectiveQuantity =
        _isBox(isBox) ? itemQuantity * packageSize : itemQuantity;
    final amountWithoutTax = _round(effectiveQuantity * unitPrice);
    final amountOnlyTax = _round(amountWithoutTax * taxRate / 100);

    return PriceBreakdown(
      amountWithoutTax: amountWithoutTax,
      amountOnlyTax: amountOnlyTax,
      finalAmount: _round(amountWithoutTax + amountOnlyTax),
    );
  }

  static double _number(dynamic value, {double fallback = 0}) {
    return value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _isBox(dynamic value) =>
      value == 1 || value == '1' || value == true;

  static double _round(double value) => double.parse(value.toStringAsFixed(2));
}
