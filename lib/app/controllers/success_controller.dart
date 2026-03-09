import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:intl/intl.dart';

class SuccessController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  User userSession = User.safeFromStorage();
  void goToHomeScreen() =>
      Get.offNamedUntil("/home", (route) => route.settings.name != "/success");
  void goToOrderScreen() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().goToOrdersTab();
      Get.offAllNamed("/home");
    } else {
      Get.offAllNamed("/home");
    }
  }

  final List<ProductForOrder> productsForOrder = [];
  late List<dynamic> cartItems;
  late String datetime;

  static const String paymentBalance = "CARGA_SALDO";

  String paymentId = "";
  String externalReference = "";
  bool isPaymentForBalance = false;
  String paymentStatus = "";

  @override
  void onInit() {
    super.onInit();
    paymentId = Get.parameters['payment_id'] ?? "";
    paymentStatus = Get.parameters['status'] ?? "";
    externalReference =
        Get.parameters['external_reference']?.split("|")[0] ?? "";
    isPaymentForBalance = externalReference == paymentBalance;

    if (isPaymentForBalance) {
      print("Pago de carga de saldo detectado (status: $paymentStatus)");
      if (paymentStatus == "approved") {
        _applyLocalBalanceLoad();
      } else {
        // Pago no aprobado → limpiar monto pendiente
        GetStorage().remove("pending_load_amount");
      }
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

        // Inyectar la orden localmente en OrderController para no volver a pedir al servidor
        if (Get.isRegistered<OrderController>()) {
          final Map<String, dynamic> newOrder =
              Map<String, dynamic>.from(response.body);
          if (!newOrder.containsKey('status')) {
            newOrder['status'] = 'ENCARGADO';
          }
          Get.find<OrderController>().addOrUpdateOrderLocally(newOrder);
        }

        // Inyectar transacción sintética (el backend no la devuelve en este flujo)
        if (Get.isRegistered<BalanceController>()) {
          final pendingTotal = GetStorage().read("pending_cart_total");
          if (pendingTotal != null) {
            final double amount = (pendingTotal as num).toDouble();
            Get.find<BalanceController>().transactions.insert(0, {
              "type": "PAGO",
              "amount": amount,
              "created_at": DateTime.now().toIso8601String(),
            });
            GetStorage().remove("pending_cart_total");
          }
        }
      }
    } catch (e, stack) {
      print("⚠️ SuccessController.createOrder CRASH: $e");
      print("Stack: $stack");
    }
  }

  /// Aplica la carga de saldo localmente sin llamar al servidor.
  /// Usa el monto guardado en storage antes de abrir Mercado Pago.
  void _applyLocalBalanceLoad() {
    try {
      final pendingAmount = GetStorage().read("pending_load_amount");
      if (pendingAmount != null && Get.isRegistered<BalanceController>()) {
        final balanceCtrl = Get.find<BalanceController>();
        final double amount = (pendingAmount as num).toDouble();

        balanceCtrl.balance.value += amount;

        GetStorage().remove("pending_load_amount");
        print("SuccessController: saldo actualizado localmente +$amount");
      }
    } catch (e) {
      print("⚠️ SuccessController._applyLocalBalanceLoad CRASH: $e");
    }
  }

  /// Refresca únicamente el saldo usando el endpoint liviano /api/users/balance
  Future<void> refreshBalance() async {
    if (Get.isRegistered<BalanceController>()) {
      await Get.find<BalanceController>().fetchBalance();
    }
  }
}
