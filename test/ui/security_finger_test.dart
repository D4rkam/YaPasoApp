import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/app/controllers/security_finger_controller.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:get_storage/get_storage.dart';

class MockUsersProvider extends Mock implements UsersProvider {}

void main() {
  late SecurityFingerController controller;
  late MockUsersProvider mockUsersProvider;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true; // Fundamental para que Get.offAllNamed no explote

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (methodCall) async => '.');

    await GetStorage.init();
  });

  setUp(() {
    mockUsersProvider = MockUsersProvider();
    controller = SecurityFingerController();
    controller.usersProvider = mockUsersProvider;
    Get.put(controller);
  });

  tearDown(() => Get.reset());

  test('checkToken llama a la API una vez y redirige si falla', () async {
    // Simulamos que el interceptor de Dio se rindió y devuelve false
    when(() => mockUsersProvider.checkToken())
        .thenAnswer((_) async => ResponseApi(success: false));

    await controller.checkToken();

    // Verificamos que se llamó UNA sola vez (el interceptor maneja los reintentos ocultos)
    verify(() => mockUsersProvider.checkToken()).called(1);

    // Como falló, debería haber borrado el usuario del storage
    expect(GetStorage().read("user"), isNull);
  });
}
