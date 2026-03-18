import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response; // Ocultamos Response de Get
import 'package:dio/dio.dart'; // Importamos Dio
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:flutter/services.dart';

class FakeUsersProvider extends UsersProvider {
  @override
  Future<Response> getOrders(
      {int limit = 10,
      String? cursor,
      String? status,
      DateTime? filter_date,
      bool? desc}) async {
    // Adaptamos a Dio
    return Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {"orders": []}); // data en vez de body
  }
}

void main() {
  late MainShellController controller;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (methodCall) async => '.');
    Get.testMode = true;
  });

  setUp(() {
    Get.testMode = true;
    Get.put<UsersProvider>(FakeUsersProvider());
    Get.put(OrderController());

    controller = MainShellController();
    Get.put(controller);
  });

  tearDown(() => Get.reset());

  test('goToOrdersTab debe cambiar el pageIndex a 1 y refrescar órdenes', () {
    controller.pageIndex.value = 0;

    controller.goToOrdersTab();

    expect(controller.pageIndex.value, 1);
    expect(controller.tabIndex.value, 0);
  });

  test('goToCategory debe actualizar la categoría seleccionada y navegar', () {
    controller.goToCategory("Snacks");

    expect(controller.selectedCategory.value, "Snacks");
    expect(controller.pageIndex.value, 3);
  });
}
