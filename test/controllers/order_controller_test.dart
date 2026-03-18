import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response; // Ocultamos Response de Get
import 'package:dio/dio.dart'; // Importamos Dio
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
        data: {"orders": [], "next_cursor": null}); // Usamos data
  }
}

void main() {
  late OrderController controller;

  setUp(() {
    Get.put<UsersProvider>(FakeUsersProvider());
    controller = OrderController();
    Get.put(controller);
  });

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );
  });

  tearDown(() => Get.reset());

  test('switchTab debe cambiar la pestaña activa', () async {
    controller.activeTab.value = 'ENCARGADO';
    controller.switchTab('LISTO');
    expect(controller.activeTab.value, 'LISTO');
  });
}
