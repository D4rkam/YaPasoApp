import 'package:get/get.dart';

class ProductForCart {
  final int id;
  final String name;
  final String imagePath;
  final int price;
  final RxInt quantity;

  ProductForCart({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });
}

class ShoppingCartController extends GetxController {
  // Lista de productos en el carrito con datos ficticios
  var cartItems = <ProductForCart>[].obs;

  bool isInCart(int productId) {
    return cartItems.any((item) => item.id == productId);
  }

  // Añadir producto al carrito
  void addItemToCart(ProductForCart product) {
    cartItems.add(product);
    cartItems.refresh();
  }

  void goPayScreen() {
    Get.toNamed("/pay");
  }

  // Eliminar producto del carrito
  void removeItemFromCart(int productId) {
    final product = cartItems.firstWhereOrNull((item) => item.id == productId);
    if (product != null) {
      cartItems.remove(product);
      product.quantity.value = 1;
      cartItems.refresh();
    }
  }

  // Actualizar la cantidad de un producto en el carrito
  void updateQuantity(int productId, int quantity) {
    var product = cartItems.firstWhereOrNull((item) => item.id == productId);
    if (product != null && quantity > 0) {
      product.quantity.value = quantity;
      cartItems.refresh();
    }
  }

  // Calcular el precio total
  int get totalPrice {
    return cartItems.fold(
        0, (sum, item) => sum + item.price * item.quantity.value);
  }
}
