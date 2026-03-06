import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/payment_response.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/pay_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PayController extends GetxController {
  PayProvider payProvider = PayProvider();
  UsersProvider usersProvider = UsersProvider();
  ShoppingCartController shoppingCartController =
      Get.find<ShoppingCartController>();
  List<ProductForCart> cartItems = [];
  String datetime = "";
  List<ProductForOrder> productsForOrder = [];
  User userSession = User.safeFromStorage();

  bool balanceSufficient = false;

  @override
  onInit() {
    super.onInit();
    final total = shoppingCartController.totalPrice;

    balanceSufficient =
        (userSession.balance != null && userSession.balance! >= total);
  }

  Future<void> _launchMercadoPago(String initPoint) async {
    final uri = Uri.parse(initPoint);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'No se pudo abrir Mercado Pago',
          backgroundColor: const Color(0xFFFF5252),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  void pay(List<ProductForCart> items) async {
    Response response = await payProvider.pay(items);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final paymentResponse = PaymentResponse.fromJson(response.body);
      final initPoint = paymentResponse.preference.initPoint;

      if (initPoint.isNotEmpty) {
        await _launchMercadoPago(initPoint);
      } else {
        Get.snackbar('Error', 'No se recibió el link de pago');
      }
    } else {
      Get.snackbar('Error', response.bodyString ?? 'Error al procesar el pago');
    }
  }

  void createOrder() async {
    try {
      // Si no hay carrito guardado, es una carga de saldo (no una compra)
      final rawCart = GetStorage().read("cart_items");
      final String jsonString = (rawCart != null) ? rawCart.toString() : "";

      List<dynamic> jsonList = jsonDecode(jsonString);
      cartItems =
          jsonList.map((json) => ProductForCart.fromJson(json)).toList();

      // Construir la lista de productos para la orden
      cartItems.forEach((item) {
        productsForOrder.add(ProductForOrder(id: int.tryParse(item.id) ?? 0));
      });

      final rawDatetime = GetStorage().read("order_datetime");
      datetime = rawDatetime?.toString() ?? "";
      if (datetime.isEmpty) {
        await usersProvider.refreshUserData();
        return;
      }

      DateTime datetime_type_datetime = DateTime.parse(datetime);

      final schoolId = userSession.schoolId;
      if (schoolId == null) {
        await usersProvider.refreshUserData();
        return;
      }

      Order order = Order(
        school_id: schoolId,
        products: productsForOrder,
        datetime:
            DateFormat("yyyy-MM-dd'T'HH:mm").format(datetime_type_datetime),
      );

      Response response = await usersProvider.createOrder(order.toJson());
      if (response.body["detail"] != null) {
        GetStorage().write("order", {"message": response.body});
      } else {
        GetStorage().write("order", response.body);
      }
      // Refrescar solo el saldo desde el endpoint liviano
      await refreshBalance();
    } catch (e) {
      // Intentar refrescar el saldo al menos
      try {
        await refreshBalance();
      } catch (_) {}
    }
  }

  Future<void> pay_with_balance() async {
    final order = GetStorage().read("order");
    final seller_id = order["products"][0]["seller_id"];
    Response response = await payProvider.pay_with_balance(
      order["total"],
      seller_id,
      order["id"],
    );

    if (response.statusCode == 200) {
      shoppingCartController.clearCart();
      GetStorage().remove("order_datetime");
      GetStorage().remove("order");

      goToSuccess();
    } else {
      Get.snackbar('Error', response.bodyString ?? 'Error al procesar el pago',
          backgroundColor: const Color(0xFFFF5252),
          colorText: const Color(0xFFFFFFFF));
    }
    refreshBalance();
  }

  Future<void> refreshBalance() async {
    if (Get.isRegistered<BalanceController>()) {
      await Get.find<BalanceController>().fetchBalance();
    }
  }

  void goToSuccess() {
    Get.offNamed(
      "/success",
    );
  }
}
