import 'package:prueba_buffet/features/payments/domain/entities/payment.dart';

class OrderItem {
  final int id;
  final int quantity;

  const OrderItem({required this.id, required this.quantity});
}

class CreateOrderDraft {
  final int schoolId;
  final List<OrderItem> products;
  final DateTime pickupDateTime;
  final String? paymentId;

  const CreateOrderDraft({
    required this.schoolId,
    required this.products,
    required this.pickupDateTime,
    this.paymentId,
  });

  factory CreateOrderDraft.fromPaymentDraft(
    PaymentOrderDraft draft,
    int schoolId,
  ) {
    return CreateOrderDraft(
      schoolId: schoolId,
      pickupDateTime: draft.pickupDateTime,
      products: draft.items
          .map(
            (item) => OrderItem(
              id: int.tryParse(item.productId) ?? 0,
              quantity: item.quantity,
            ),
          )
          .toList(),
    );
  }
}

class CreatedOrder {
  final int id;
  final int sellerId;
  final double total;

  const CreatedOrder({
    required this.id,
    required this.sellerId,
    required this.total,
  });
}
