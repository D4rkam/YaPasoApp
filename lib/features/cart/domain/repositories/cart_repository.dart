import 'package:prueba_buffet/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  List<CartItem> getItems();
  bool isInCart(String productId);
  void addItem(CartItem item);
  void removeItem(String productId);
  void updateQuantity(String productId, int quantity);
  void replaceItems(List<CartItem> items);
  void clearItems();
  int getTotalPrice();
  Future<void> persistItems();
}
