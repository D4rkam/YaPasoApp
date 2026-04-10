import 'package:prueba_buffet/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:prueba_buffet/features/cart/data/models/cart_item_model.dart';
import 'package:prueba_buffet/features/cart/domain/entities/cart_item.dart';
import 'package:prueba_buffet/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _local;
  final List<CartItem> _items = [];

  CartRepositoryImpl(this._local);

  @override
  List<CartItem> getItems() => List<CartItem>.unmodifiable(_items);

  @override
  bool isInCart(String productId) {
    return _items.any((item) => item.id == productId);
  }

  @override
  void addItem(CartItem item) {
    if (isInCart(item.id)) return;
    if (item.maxQuantity <= 0 || item.quantity <= 0) return;
    _items.add(item);
  }

  @override
  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
  }

  @override
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) return;

    final index = _items.indexWhere((item) => item.id == productId);
    if (index < 0) return;

    final item = _items[index];
    if (quantity > item.maxQuantity) return;

    _items[index] = item.copyWith(quantity: quantity);
  }

  @override
  void replaceItems(List<CartItem> items) {
    _items
      ..clear()
      ..addAll(items);
  }

  @override
  void clearItems() {
    _items.clear();
    _local.clearPersistedCart();
  }

  @override
  int getTotalPrice() {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Future<void> persistItems() {
    final models = _items.map(CartItemModel.fromEntity).toList();
    return _local.saveCartItems(models);
  }
}
