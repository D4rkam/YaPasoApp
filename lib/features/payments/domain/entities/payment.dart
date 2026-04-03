class PaymentItem {
  final String productId;
  final String title;
  final int quantity;
  final double unitPrice;
  final String? categoryId;
  final String? description;

  const PaymentItem({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.categoryId,
    this.description,
  });
}

class PaymentOrderDraft {
  final List<PaymentItem> items;
  final DateTime pickupDateTime;

  const PaymentOrderDraft({required this.items, required this.pickupDateTime});

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + (item.unitPrice * item.quantity));
}
