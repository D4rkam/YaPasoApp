import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/features/analytics/domain/constants/analytics_constants.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:prueba_buffet/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:prueba_buffet/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:prueba_buffet/features/cart/domain/entities/cart_item.dart';
import 'package:prueba_buffet/features/cart/domain/repositories/cart_repository.dart';
import 'package:prueba_buffet/features/cart/domain/usecases/cart_use_cases.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity.value,
      'price': price,
      'imagePath': imagePath,
      'maxQuantity': maxQuantity,
    };
  }

  factory ProductForCart.fromJson(Map<String, dynamic> json) {
    return ProductForCart(
      id: json['id'].toString(),
      name: json['name'],
      quantity: RxInt(json['quantity']),
      imagePath: json['imagePath'] ?? json['image_url'],
      price: double.tryParse(json['price'].toString())?.toInt() ?? 0,
      maxQuantity: json['maxQuantity'] ?? 99,
    );
  }
}

class ShoppingCartControllerV2 extends GetxController {
  late final CartRepository _repository;
  late final GetCartItemsUseCase _getCartItems;
  late final IsCartItemPresentUseCase _isCartItemPresent;
  late final AddCartItemUseCase _addCartItem;
  late final RemoveCartItemUseCase _removeCartItem;
  late final UpdateCartItemQuantityUseCase _updateCartItemQuantity;
  late final ReplaceCartItemsUseCase _replaceCartItems;
  late final ClearCartUseCase _clearCart;
  late final GetCartTotalPriceUseCase _getCartTotalPrice;
  late final SaveCartItemsUseCase _saveCartItems;

  ShoppingCartControllerV2({CartRepository? repository}) {
    _repository =
        repository ?? CartRepositoryImpl(CartLocalDataSource(GetStorage()));

    _getCartItems = GetCartItemsUseCase(_repository);
    _isCartItemPresent = IsCartItemPresentUseCase(_repository);
    _addCartItem = AddCartItemUseCase(_repository);
    _removeCartItem = RemoveCartItemUseCase(_repository);
    _updateCartItemQuantity = UpdateCartItemQuantityUseCase(_repository);
    _replaceCartItems = ReplaceCartItemsUseCase(_repository);
    _clearCart = ClearCartUseCase(_repository);
    _getCartTotalPrice = GetCartTotalPriceUseCase(_repository);
    _saveCartItems = SaveCartItemsUseCase(_repository);
  }

  @override
  void onReady() {
    super.onReady();
    _trackViewCart();
  }

  void _trackViewCart() {
    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.viewCart,
      properties: <String, Object>{
        AnalyticsProperties.totalAmount: totalPrice.toDouble(),
        AnalyticsProperties.productCount: cartItems.length,
      },
    );
  }

  final cartItems = <ProductForCart>[].obs;

  CartItem _toEntity(ProductForCart product) {
    return CartItem(
      id: product.id,
      name: product.name,
      imagePath: product.imagePath,
      price: product.price,
      quantity: product.quantity.value,
      maxQuantity: product.maxQuantity,
    );
  }

  ProductForCart _toPresentation(CartItem item) {
    return ProductForCart(
      id: item.id,
      name: item.name,
      imagePath: item.imagePath,
      price: item.price,
      quantity: RxInt(item.quantity),
      maxQuantity: item.maxQuantity,
    );
  }

  void _syncFromRepository() {
    final items = _getCartItems();
    cartItems.assignAll(items.map(_toPresentation));
    cartItems.refresh();
  }

  bool isInCart(String productId) {
    return _isCartItemPresent(productId);
  }

  void addItemToCart(ProductForCart product) {
    _addCartItem(_toEntity(product));
    _syncFromRepository();

    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.addToCart,
      properties: <String, Object>{
        'product_id': product.id,
        'product_name': product.name,
        'price': product.price.toDouble(),
      },
    );
  }

  void saveCartItems(List<ProductForCart> items) {
    _replaceCartItems(items.map(_toEntity).toList());
    _syncFromRepository();
    _saveCartItems();
  }

  void goPayScreen() {
    _saveCartItems();

    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.startCheckout,
      properties: <String, Object>{
        AnalyticsProperties.totalAmount: totalPrice.toDouble(),
        AnalyticsProperties.productCount: cartItems.length,
      },
    );

    Get.toNamed(Routes.PAY);
  }

  void removeItemFromCart(String productId) {
    _removeCartItem(productId);
    _syncFromRepository();

    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.removeFromCart,
      properties: <String, Object>{
        'product_id': productId,
      },
    );
  }

  void clearCart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearCart();
      _syncFromRepository();
    });
  }

  void updateQuantity(String productId, int quantity) {
    _updateCartItemQuantity(productId, quantity);
    _syncFromRepository();
  }

  int get totalPrice {
    return _getCartTotalPrice();
  }
}
