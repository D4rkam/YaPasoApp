import 'package:intl/intl.dart';
import 'package:prueba_buffet/features/payments/domain/entities/order.dart';
import 'package:prueba_buffet/features/payments/domain/entities/payment.dart';

class PaymentItemRequestDto {
  final String id;
  final String title;
  final int quantity;
  final int unitPrice;

  const PaymentItemRequestDto({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
  });

  factory PaymentItemRequestDto.fromEntity(PaymentItem item) {
    return PaymentItemRequestDto(
      id: item.productId,
      title: item.title,
      quantity: item.quantity,
      unitPrice: item.unitPrice.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}

class PaymentRequestDto {
  final List<PaymentItemRequestDto> items;
  final String datetimeOrder;

  const PaymentRequestDto({
    required this.items,
    required this.datetimeOrder,
  });

  factory PaymentRequestDto.fromDraft(PaymentOrderDraft draft) {
    return PaymentRequestDto(
      items: draft.items.map(PaymentItemRequestDto.fromEntity).toList(),
      datetimeOrder: draft.pickupDateTime.toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'datetime_order': datetimeOrder,
    };
  }
}

class CreateOrderItemDto {
  final int id;
  final int quantity;

  const CreateOrderItemDto({required this.id, required this.quantity});

  factory CreateOrderItemDto.fromEntity(OrderItem item) {
    return CreateOrderItemDto(id: item.id, quantity: item.quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}

class CreateOrderRequestDto {
  final int schoolId;
  final List<CreateOrderItemDto> products;
  final String datetimeOrder;
  final String? paymentId;

  const CreateOrderRequestDto({
    required this.schoolId,
    required this.products,
    required this.datetimeOrder,
    this.paymentId,
  });

  factory CreateOrderRequestDto.fromEntity(CreateOrderDraft orderDraft) {
    return CreateOrderRequestDto(
      schoolId: orderDraft.schoolId,
      products: orderDraft.products.map(CreateOrderItemDto.fromEntity).toList(),
      datetimeOrder:
          DateFormat("yyyy-MM-dd'T'HH:mm").format(orderDraft.pickupDateTime),
      paymentId: orderDraft.paymentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_id': schoolId,
      'products': products.map((e) => e.toJson()).toList(),
      'datetime_order': datetimeOrder,
      'mp_payment_id': paymentId,
    };
  }
}

class MercadoPagoCheckoutDto {
  final String initPoint;

  const MercadoPagoCheckoutDto({required this.initPoint});

  factory MercadoPagoCheckoutDto.fromJson(Map<String, dynamic> json) {
    return MercadoPagoCheckoutDto(
      initPoint: json['init_point']?.toString() ?? '',
    );
  }
}

class CreatedOrderDto {
  final int id;
  final int sellerId;
  final double total;
  final Map<String, dynamic> raw;

  const CreatedOrderDto({
    required this.id,
    required this.sellerId,
    required this.total,
    required this.raw,
  });

  factory CreatedOrderDto.fromJson(Map<String, dynamic> json) {
    return CreatedOrderDto(
      id: _safeInt(json['id']) ?? 0,
      sellerId: _safeInt(json['seller_id']) ?? 0,
      total: _safeDouble(json['total']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  CreatedOrder toDomain() {
    return CreatedOrder(id: id, sellerId: sellerId, total: total);
  }
}

class StoredCartItemDto {
  final String id;
  final String title;
  final int quantity;
  final double unitPrice;
  final String? categoryId;
  final String? description;

  const StoredCartItemDto({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.categoryId,
    this.description,
  });

  factory StoredCartItemDto.fromJson(Map<String, dynamic> json) {
    return StoredCartItemDto(
      id: (json['id'] ?? '').toString(),
      title: (json['name'] ?? json['title'] ?? '').toString(),
      quantity: _safeInt(json['quantity']) ?? 0,
      unitPrice: _safeDouble(json['price'] ?? json['unit_price']),
      categoryId: json['category_id']?.toString(),
      description: json['description']?.toString(),
    );
  }

  PaymentItem toDomain() {
    return PaymentItem(
      productId: id,
      title: title,
      quantity: quantity,
      unitPrice: unitPrice,
      categoryId: categoryId,
      description: description,
    );
  }
}

int? _safeInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

double _safeDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
