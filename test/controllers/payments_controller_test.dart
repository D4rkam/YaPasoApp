import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response; // Ocultamos Response de Get
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart'; // Importamos Dio
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/pay_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/pay_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/data/provider/wallet_provider.dart';
import 'package:prueba_buffet/app/data/models/product.dart';

class MockWalletProvider extends Mock implements WalletProvider {}

class MockUsersProvider extends Mock implements UsersProvider {}

class MockPayProvider extends Mock implements PayProvider {}

class TestShoppingCartController extends ShoppingCartController {
  @override
  void onInit() {
    cartItems = <ProductForCart>[].obs;
  }
}

class TestBalanceController extends BalanceController {
  @override
  void onInit() {
    balance = 0.0.obs;
  } // Evitamos que haga llamadas HTTP reales al arrancar
}

void main() {
  late BalanceController balanceController;
  late PayController payController;
  late TestShoppingCartController shoppingCartController;

  late MockWalletProvider mockWalletProvider;
  late MockUsersProvider mockUsersProvider;
  late MockPayProvider mockPayProvider;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );

    await GetStorage.init();
  });

  setUp(() {
    GetStorage().erase();

    GetStorage().write("user", {
      "name": "Thomas",
      "last_name": "Ingeniero",
      "balance": 2500.0,
      "school_id": 1,
      "file_num": "12345"
    });

    GetStorage().write('requireBiometricsForPay', false);

    mockWalletProvider = MockWalletProvider();
    mockUsersProvider = MockUsersProvider();
    mockPayProvider = MockPayProvider();

    shoppingCartController = TestShoppingCartController();
    Get.put<ShoppingCartController>(shoppingCartController);

    balanceController = TestBalanceController();
    Get.put<BalanceController>(balanceController);

    payController = PayController();
    payController.payProvider = mockPayProvider;
    payController.usersProvider = mockUsersProvider;
    Get.put<PayController>(payController);
  });

  tearDown(() {
    Get.reset();
  });

  group('BalanceController Tests', () {
    test('updateBalance debe sumar el saldo correctamente', () {
      balanceController.balance.value = 2500.0;
      balanceController.updateBalance(500.0);
      expect(balanceController.balance.value, 3000.0);
    });
  });

  group('PayController Tests', () {
    test('onInit debe habilitar el pago con saldo si alcanza el dinero', () {
      Get.delete<PayController>();

      shoppingCartController.cartItems.add(ProductForCart(
          id: "1", name: "Café", price: 1500, quantity: 1.obs, imagePath: ""));

      expect(shoppingCartController.totalPrice, 1500);

      final newPayController = PayController();
      Get.put<PayController>(newPayController);

      expect(newPayController.balanceSufficient, true);
    });

    test('createOrder debe fallar si el carrito está vacío en Storage',
        () async {
      final result = await payController.createOrder();
      expect(result, false);
    });

    test('createOrder debe retornar true si el backend responde 201', () async {
      GetStorage().write(
          "cart_items",
          jsonEncode([
            {
              "id": "1",
              "name": "A",
              "price": 10,
              "quantity": 1,
              "imagePath": ""
            }
          ]));
      GetStorage().write("order_datetime", "2026-05-10T09:30:00.000");

      // FakeResponse de Dio
      final fakeResponse = Response<dynamic>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 201,
          data: {
            "id": 99,
            "total": 1000,
            "seller_id": 2
          }); // data en vez de body

      when(() => mockUsersProvider.createOrder(any()))
          .thenAnswer((_) async => fakeResponse);

      final result = await payController.createOrder();

      expect(result, true);
      expect(GetStorage().read("order")["id"], 99);
    });
  });
}
