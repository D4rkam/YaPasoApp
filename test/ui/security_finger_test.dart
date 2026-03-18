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

  test('checkToken reintenta si falla la primera vez', () async {
    // Simulamos fallo inicial y éxito en reintento
    when(() => mockUsersProvider.checkToken())
        .thenAnswer((_) async => ResponseApi(success: false));

    await controller.checkToken();

    // Verificamos que se llamó 2 veces por la lógica de reintento
    verify(() => mockUsersProvider.checkToken()).called(2);
  });
}
