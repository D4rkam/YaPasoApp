import 'package:prueba_buffet/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.price,
    required super.quantity,
    super.maxQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imagePath': imagePath,
      'maxQuantity': maxQuantity,
    };
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      name: entity.name,
      imagePath: entity.imagePath,
      price: entity.price,
      quantity: entity.quantity,
      maxQuantity: entity.maxQuantity,
    );
  }
}
