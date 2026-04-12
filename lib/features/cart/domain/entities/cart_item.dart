class CartItem {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final int quantity;
  final int maxQuantity;
  final String? category;

  const CartItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
    this.maxQuantity = 99,
    this.category,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? imagePath,
    int? price,
    int? quantity,
    int? maxQuantity,
    String? category,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      category: category ?? this.category,
    );
  }
}
