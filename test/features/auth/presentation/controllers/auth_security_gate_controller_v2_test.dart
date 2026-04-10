import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';
import 'package:prueba_buffet/features/auth/domain/errors/auth_failure.dart';
import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/clear_session_use_case.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_security_gate_controller_v2.dart';

class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}
class MockClearSessionUseCase extends Mock implements ClearSessionUseCase {}
class MockIsBiometricEnabledUseCase extends Mock implements IsBiometricEnabledUseCase {}

void main() {
  late AuthSecurityGateControllerV2 controller;
  late MockCheckSessionUseCase mockCheckSession;
  late MockClearSessionUseCase mockClearSession;
  late MockIsBiometricEnabledUseCase mockIsBiometric;

  setUp(() {
    mockCheckSession = MockCheckSessionUseCase();
    mockClearSession = MockClearSessionUseCase();
    mockIsBiometric = MockIsBiometricEnabledUseCase();

    controller = AuthSecurityGateControllerV2(
      mockCheckSession,
      mockClearSession,
      mockIsBiometric,
    );
  });

  group('AuthSecurityGateControllerV2 Tests', () {
    test('validateSession should return home if session is valid', () async {
      // arrange
      const session = AuthSession(userId: 1, username: 'test', name: 'Test', email: 't@t.com', hasToken: true);
      when(() => mockCheckSession()).thenAnswer((_) async => AuthResult.success(session));

      // act
      final destination = await controller.validateSession();

      // assert
      expect(destination, AuthGateDestination.home);
      expect(controller.isLoading.value, false);
      verify(() => mockCheckSession()).called(1);
    });

    test('validateSession should return login and clear session if invalid', () async {
      // arrange
      when(() => mockCheckSession()).thenAnswer((_) async => AuthResult.error(AuthFailure.invalidSession));
      when(() => mockClearSession()).thenAnswer((_) async {});

      // act
      final destination = await controller.validateSession();

      // assert
      expect(destination, AuthGateDestination.login);
      verify(() => mockClearSession()).called(1);
    });

    test('loadGateConfig should update requiresBiometric', () async {
      // arrange
      when(() => mockIsBiometric()).thenAnswer((_) async => true);

      // act
      await controller.loadGateConfig();

      // assert
      expect(controller.requiresBiometric.value, true);
    });
  });
}
