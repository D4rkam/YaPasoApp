import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:intl/intl.dart';

class SuccessController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  User userSession = User.safeFromStorage();
  void goToHomeScreen() => Get.offNamedUntil("/home", (route) => false);
  void goToOrderScreen() => Get.offNamedUntil("/orders", (route) => false);

  final List<ProductForOrder> productsForOrder = [];
  late List<dynamic> cartItems;
  late String datetime;

  void createOrder() async {
    try {
      // Si no hay carrito guardado, es una carga de saldo (no una compra)
      final rawCart = GetStorage().read("cart_items");
      final String jsonString = (rawCart != null) ? rawCart.toString() : "";
      if (jsonString.isEmpty) {
        print("SuccessController: No hay carrito → es carga de saldo");
        // Refrescar solo el saldo desde el endpoint liviano
        await _refreshBalance();
        return;
      }

      List<dynamic> jsonList = jsonDecode(jsonString);
      cartItems =
          jsonList.map((json) => ProductForCart.fromJson(json)).toList();

      // Construir la lista de productos para la orden
      cartItems.forEach((item) {
        productsForOrder.add(ProductForOrder(id: item.id));
      });

      final rawDatetime = GetStorage().read("order_datetime");
      datetime = rawDatetime?.toString() ?? "";
      if (datetime.isEmpty) {
        print("⚠️ SuccessController: order_datetime vacío");
        await usersProvider.refreshUserData();
        return;
      }

      DateTime datetime_type_datetime = DateTime.parse(datetime);

      // userSession.id puede ser null si el parseo falló
      final userId = userSession.id ?? 0;
      Order order = Order(
          user_id: userId,
          seller_id: 1,
          products: productsForOrder,
          datetime:
              DateFormat("yyyy-MM-dd'T'HH:mm").format(datetime_type_datetime));

      print(order.toJson());
      Response response = await usersProvider.createOrder(order.toJson());
      GetStorage().write("order", response.body);

      // Refrescar solo el saldo desde el endpoint liviano
      await _refreshBalance();
    } catch (e, stack) {
      print("⚠️ SuccessController.createOrder CRASH: $e");
      print("Stack: $stack");
      // Intentar refrescar el saldo al menos
      try {
        await _refreshBalance();
      } catch (_) {}
    }
  }

  /// Refresca únicamente el saldo usando el endpoint liviano /api/users/balance
  Future<void> _refreshBalance() async {
    if (Get.isRegistered<BalanceController>()) {
      await Get.find<BalanceController>().fetchBalance();
    }
  }
}
