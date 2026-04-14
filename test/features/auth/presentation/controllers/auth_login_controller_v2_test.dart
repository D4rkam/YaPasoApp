import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/analytics/domain/usecases/identify_use_cases.dart';
import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/login_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/errors/auth_failure.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_login_controller_v2.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockIdentifyUseCases extends Mock implements IdentifyUseCases {}

class FakeLoginCredentials extends Fake implements LoginCredentials {}

void main() {
  late AuthLoginControllerV2 controller;
  late MockLoginUseCase mockLoginUseCase;
  late MockIdentifyUseCases mockIdentifyUseCases;

  setUpAll(() {
    registerFallbackValue(FakeLoginCredentials());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockIdentifyUseCases = MockIdentifyUseCases();
    controller = AuthLoginControllerV2(mockLoginUseCase, mockIdentifyUseCases);
  });

  group('AuthLoginControllerV2 Tests', () {
    test('validateForm should return false and set errors when empty', () {
      // act
      final result = controller.validateForm();

      // assert
      expect(result, false);
      expect(controller.usernameError.value, isNotNull);
      expect(controller.passwordError.value, isNotNull);
    });

    test('validateForm should return true when filled', () {
      // arrange
      controller.usernameController.text = 'user';
      controller.passwordController.text = 'pass';

      // act
      final result = controller.validateForm();

      // assert
      expect(result, true);
      expect(controller.usernameError.value, isNull);
    });

    test('submit should return true on success', () async {
      // arrange
      controller.usernameController.text = 'user';
      controller.passwordController.text = 'pass';
      const session = AuthSession(
          userId: 1, username: 'u', name: 'n', email: 'e', hasToken: true);
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => AuthResult.success(session));

      // act
      final result = await controller.submit();

      // assert
      expect(result, true);
      expect(controller.isLoading.value, false);
      verify(() => mockLoginUseCase(any())).called(1);
    });

    test('submit should set authError on failure', () async {
      // arrange
      controller.usernameController.text = 'user';
      controller.passwordController.text = 'pass';
      when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => AuthResult.error(AuthFailure.invalidCredentials));

      // act
      final result = await controller.submit();

      // assert
      expect(result, false);
      expect(controller.authError.value, contains('No se pudo iniciar sesion'));
    });
  });
}
