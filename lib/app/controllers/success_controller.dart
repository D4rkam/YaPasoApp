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
  void goToHomeScreen() =>
      Get.offNamedUntil("/home", (route) => route.settings.name != "/success");
  void goToOrderScreen() => Get.offNamedUntil(
      "/orders", (route) => route.settings.name != "/success");

  final List<ProductForOrder> productsForOrder = [];
  late List<dynamic> cartItems;
  late String datetime;

  static const String paymentBalance = "CARGA_SALDO";

  String paymentId = "";
  String externalReference = "";
  bool isPaymentForBalance = false;
  @override
  void onInit() {
    super.onInit();
    paymentId = Get.parameters['payment_id'] ?? "";
    externalReference =
        Get.parameters['external_reference']?.split("|")[0] ?? "";
    isPaymentForBalance = externalReference == paymentBalance;

    if (isPaymentForBalance) {
      print("Pago de carga de saldo detectado");
      refreshBalance();
    } else {
      print("Pago de compra detectado → creando orden");
      createOrder();
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
        print("⚠️ SuccessController: order_datetime vacío");
        await usersProvider.refreshUserData();
        return;
      }

      DateTime datetime_type_datetime = DateTime.parse(datetime);

      final schoolId = userSession.schoolId;
      if (schoolId == null) {
        print("⚠️ SuccessController: userSession.id o schoolId es null");
        await usersProvider.refreshUserData();
        return;
      }

      Order order = Order(
        school_id: schoolId,
        products: productsForOrder,
        datetime:
            DateFormat("yyyy-MM-dd'T'HH:mm").format(datetime_type_datetime),
        payment_id: paymentId,
      );

      print(order.toJson());
      Response response = await usersProvider.createOrder(order.toJson());
      if (response.body["detail"] != null) {
        GetStorage().write("order", {"message": response.body});
      } else {
        GetStorage().write("order", response.body);
      }
      // Refrescar solo el saldo desde el endpoint liviano
      await refreshBalance();
    } catch (e, stack) {
      print("⚠️ SuccessController.createOrder CRASH: $e");
      print("Stack: $stack");
      // Intentar refrescar el saldo al menos
      try {
        await refreshBalance();
      } catch (_) {}
    }
  }

  /// Refresca únicamente el saldo usando el endpoint liviano /api/users/balance
  Future<void> refreshBalance() async {
    if (Get.isRegistered<BalanceController>()) {
      await Get.find<BalanceController>().fetchBalance();
    }
  }
}
