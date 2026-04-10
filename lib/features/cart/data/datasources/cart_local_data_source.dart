import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/cart/data/models/cart_item_model.dart';

class CartLocalDataSource {
  static const String cartItemsKey = 'cart_items';

  final GetStorage _storage;

  CartLocalDataSource(this._storage);

  Future<void> saveCartItems(List<CartItemModel> items) async {
    final payload = items.map((item) => item.toJson()).toList();
    await _storage.write(cartItemsKey, jsonEncode(payload));
  }

  Future<void> clearPersistedCart() async {
    await _storage.remove(cartItemsKey);
  }
}
