import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/register_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

// 👇 CAMBIO: Fake manual para evitar el error de Null subtype
class FakeUsersProviderForRegister extends UsersProvider {
  @override
  Future<List<Map<String, dynamic>>> getSchools() async => [];
}

void main() {
  late RegisterController controller;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (methodCall) async => '.');
  });

  setUp(() {
    Get.put<UsersProvider>(FakeUsersProviderForRegister());
    controller = RegisterController();
    Get.put(controller);
  });

  tearDown(() => Get.reset());

  test('validateCurrentStep retorna false si faltan datos en el paso 0', () {
    controller.currentStep.value = 0;
    controller.nameController.text = "";
    expect(controller.validateCurrentStep(), false);
  });
}
