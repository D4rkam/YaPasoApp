import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductForCart {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final RxInt quantity;
  final int maxQuantity;

  ProductForCart({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
    this.maxQuantity = 99,
  });

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity.value,
      "price": price,
      "imagePath": imagePath,
      "maxQuantity": maxQuantity,
    };
  }

  // Método para crear una instancia desde JSON
  factory ProductForCart.fromJson(Map<String, dynamic> json) {
    return ProductForCart(
      id: json['id'].toString(),
      name: json['name'],
      quantity: RxInt(json['quantity']),
      imagePath: json["imagePath"] ?? json["image_url"],
      price: double.tryParse(json["price"].toString())?.toInt() ?? 0,
      maxQuantity: json["maxQuantity"] ?? 99,
    );
  }
}

class ShoppingCartController extends GetxController {
  // Lista de productos en el carrito con datos ficticios
  var cartItems = <ProductForCart>[].obs;

  bool isInCart(String productId) {
    return cartItems.any((item) => item.id == productId);
  }

  // Añadir producto al carrito
  void addItemToCart(ProductForCart product) {
    // Validación: no duplicar y verificar stock
    if (isInCart(product.id)) return;
    if (product.maxQuantity <= 0) return;
    if (product.quantity.value <= 0) return;

    cartItems.add(product);
    cartItems.refresh();
  }

  void saveCartItems(List<ProductForCart> items) {
    List<Map<String, dynamic>> jsonItems =
        items.map((item) => item.toJson()).toList();
    GetStorage()
        .write("cart_items", jsonEncode(jsonItems)); // Guardar como JSON
  }

  void goPayScreen() {
    saveCartItems(cartItems);
    Get.toNamed("/pay");
  }

  // Eliminar producto del carrito
  void removeItemFromCart(String productId) {
    cartItems.removeWhere((item) => item.id == productId);
    cartItems.refresh();
  }

  void clearCart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartItems.clear();
      cartItems.refresh();
      GetStorage().remove("cart_items");
    });
  }

  // Actualizar la cantidad de un producto en el carrito
  void updateQuantity(String productId, int quantity) {
    var product = cartItems.firstWhereOrNull((item) => item.id == productId);
    if (product != null && quantity > 0 && quantity <= product.maxQuantity) {
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
