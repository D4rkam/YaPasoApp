import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' show Response;
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/payment_response.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/pay_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
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

  final LocalAuthentication _auth = LocalAuthentication();

  // ---> NUEVA FUNCIÓN: Verifica la huella si está activada en Configuración
  Future<bool> _authenticateIfRequired() async {
    // Leemos si el usuario activó la opción en configuraciones
    bool requireBiometrics =
        GetStorage().read<bool>('requireBiometricsForPay') ?? false;

    // Si la tiene apagada, lo dejamos pasar gratis
    if (!requireBiometrics) return true;

    try {
      // Verificamos si el celular tiene hardware de huella/cara
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (canAuthenticate) {
        // Desplegamos el popup nativo de huella
        final bool didAuthenticate = await _auth.authenticate(
          localizedReason:
              'Por favor, verificá tu identidad para confirmar la compra',
          options: const AuthenticationOptions(
            biometricOnly: true, // Fuerza huella/cara (sin pin numérico)
            stickyAuth:
                true, // Mantiene el popup si la app va al fondo un segundo
          ),
          // ---> FIX: Va entre corchetes [ ] porque es una lista de plataformas
          authMessages: const [
            AndroidAuthMessages(
              signInTitle: 'Confirmar pago', // Título principal del popup
              biometricHint: '',
              biometricNotRecognized:
                  'No se reconoció la huella, intentá de nuevo',
              biometricRequiredTitle: 'Se requiere huella',
              biometricSuccess: '¡Pago autorizado!',
              cancelButton: 'Cancelar',
            ),
            // Si algún día exportás a iOS, ya te queda configurado:
            IOSAuthMessages(
              cancelButton: 'Cancelar',
            ),
          ],
        );
        return didAuthenticate; // Retorna true si puso bien el dedo
      }
      return true; // Si su celular no tiene lector, lo dejamos pasar por defecto
    } catch (e) {
      print("Error con la biometría: $e");
      // Si falla algo técnico, permitimos el pago para no bloquearle el uso de la app
      return true;
    }
  }

  Future<void> executePaymentFlow() async {
    // 1. Pedimos huella (si aplica)
    bool isAuthorized = await _authenticateIfRequired();

    // Si canceló la huella, cortamos todo el proceso
    if (!isAuthorized) {
      CustomToast.showError(
          title: "Error de autenticación",
          message: "Pago cancelado por falta de autenticación");
      return;
    }

    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none) ||
        connectivityResult.isEmpty) {
      CustomToast.showError(
          title: "Sin conexión",
          message:
              "No podés realizar pagos sin internet. Verificá tu Wi-Fi o datos.");
      return;
    }

    // 2. Si pasó la seguridad, creamos la orden en el servidor
    bool orderCreated = await createOrder();

    // 3. Si la orden se creó con éxito, pagamos con el saldo
    if (orderCreated) {
      await pay_with_balance();
    }
  }

  Future<void> _launchMercadoPago(String initPoint) async {
    final uri = Uri.parse(initPoint);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      CustomToast.showError(
          title: 'Error', message: 'No se pudo abrir Mercado Pago');
    }
  }

  void pay(List<ProductForCart> items) async {
    var _totalAmount = items.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity.value));

    print('Total a pagar vía MP: $_totalAmount');
    final rawDatetime = GetStorage().read("order_datetime");
    String datetimeOrder =
        rawDatetime?.toString() ?? DateTime.now().toIso8601String();

    Response? response = await payProvider.pay(items.toList(), datetimeOrder);

    if (response?.statusCode == 200 || response?.statusCode == 201) {
      final paymentResponse = PaymentResponse.fromJson(response!.data);
      final initPoint = paymentResponse.preference.initPoint;

      if (initPoint.isNotEmpty) {
        GetStorage().write("pending_cart_total", _totalAmount);
        await _launchMercadoPago(initPoint);
      } else {
        CustomToast.showError(
            title: 'Error', message: 'No se recibió un enlace de pago válido');
      }
    } else {
      CustomToast.showError(
          title: 'Error', message: 'No se pudo iniciar el proceso de pago');
    }
  }

  // ---> NUEVO: Ahora retorna un bool para saber si la orden se creó con éxito
  Future<bool> createOrder() async {
    try {
      final rawCart = GetStorage().read("cart_items");
      final String jsonString = (rawCart != null) ? rawCart.toString() : "";
      if (jsonString.isEmpty) return false;

      List<dynamic> jsonList = jsonDecode(jsonString);
      cartItems =
          jsonList.map((json) => ProductForCart.fromJson(json)).toList();

      // ---> FIX: Limpiamos la lista antes de llenarla para no duplicar
      productsForOrder.clear();
      cartItems.forEach((item) {
        productsForOrder.add(ProductForOrder(
            id: int.tryParse(item.id) ?? 0, quantity: item.quantity.value));
      });

      final rawDatetime = GetStorage().read("order_datetime");
      datetime = rawDatetime?.toString() ?? "";
      if (datetime.isEmpty) {
        await usersProvider.refreshUserData();
        return false;
      }

      DateTime datetime_type_datetime = DateTime.parse(datetime);

      final schoolId = userSession.schoolId;
      if (schoolId == null) {
        await usersProvider.refreshUserData();
        return false;
      }

      Order order = Order(
        school_id: schoolId,
        products: productsForOrder,
        datetime:
            DateFormat("yyyy-MM-dd'T'HH:mm").format(datetime_type_datetime),
      );

      // ---> DEBUG: Imprimimos el JSON exacto para ver por qué da 422
      print("📤 Payload enviado a /api/order/ : ${jsonEncode(order.toJson())}");

      Response response = await usersProvider.createOrder(order.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        GetStorage().write("order", response.data);
        return true; // ÉXITO
      } else {
        if (response.statusCode == 400 && response.data != null) {
          String errorMessage = response.data['detail'] ??
              "El buffet no puede recibir pedidos ahora.";

          CustomToast.showError(
            title: "Buffet Cerrado",
            message: errorMessage,
          );
        } else {
          // Un error genérico por si es un 422 (problemas de datos) o un 500
          CustomToast.showError(
            title: "Error",
            message: "No pudimos procesar tu pedido. Intentá de nuevo.",
          );
        }
        GetStorage().write("order", {"message": response.data});
        return false; // FRACASO
      }
    } catch (e, stack) {
      print("⚠️ Crash en createOrder: $e\n$stack");
      return false;
    }
  }

  Future<void> pay_with_balance() async {
    final order = GetStorage().read("order");
    print(order);

    // 1. Verificamos que la orden exista y tenga la estructura correcta
    if (order == null || order["id"] == null || order["seller_id"] == null) {
      CustomToast.showError(
          title: "Error de orden",
          message: "No se encontró la orden válida para procesar el pago");
      return;
    }

    // 2. Extraemos los IDs directamente desde el diccionario (Mapa)
    final int seller_id = order["seller_id"];
    final int order_id = order["id"];

    // 3. Extraemos el total
    final double totalToDeduct = (order["total"] is int)
        ? (order["total"] as int).toDouble()
        : (order["total"] is double)
            ? order["total"]
            : double.tryParse(order["total"].toString()) ?? 0.0;

    print(
        "💰 Iniciando pago con saldo - Orden: $order_id, Vendedor: $seller_id, Total: \$$totalToDeduct");

    // 4. Llamamos a la API de pago
    Response? response =
        await payProvider.payWithBalance(totalToDeduct, seller_id, order_id);

    if (response?.statusCode == 200) {
      // 5. Descontamos el saldo visualmente
      if (Get.isRegistered<BalanceController>()) {
        final balanceCtrl = Get.find<BalanceController>();
        balanceCtrl.balance.value -= totalToDeduct;
        balanceCtrl.transactions.insert(0, {
          "type": "PAGO",
          "amount": totalToDeduct,
          "created_at": DateTime.now().toIso8601String(),
        });
      }

      // 6. Limpiamos carrito y storage
      shoppingCartController.clearCart();
      GetStorage().remove("order_datetime");
      GetStorage().remove("order");

      // 7. Actualizamos stock en el Home
      if (Get.isRegistered<HomeController>()) {
        final homeCtrl = Get.find<HomeController>();
        for (final cartItem in cartItems) {
          final localProduct = homeCtrl.productsFromApi.firstWhereOrNull(
            (p) => p.id.toString() == cartItem.id,
          );
          if (localProduct != null) {
            localProduct.quantity =
                (localProduct.quantity - cartItem.quantity.value)
                    .clamp(0, localProduct.quantity);
          }
        }
        homeCtrl.productsFromApi.refresh();
        homeCtrl.getProducts(); // Vuelve a pedir stock real
      }

      goToSuccess();
    } else {
      print("❌ Error al pagar con saldo: ${response?.data}");
      CustomToast.showError(
          title: 'Error',
          message: 'No se pudo procesar el pago con saldo virtual.');
    }
  }

  void goToSuccess() {
    Get.offNamed("/success");
  }
}
