import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/entities/register_command.dart';
import 'package:prueba_buffet/features/auth/domain/errors/auth_failure.dart';
import 'package:prueba_buffet/features/auth/domain/repositories/auth_repository.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/login_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/register_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/clear_session_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeLoginCredentials extends Fake implements LoginCredentials {}
class FakeRegisterCommand extends Fake implements RegisterCommand {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginCredentials());
    registerFallbackValue(FakeRegisterCommand());
  });
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;
  late CheckSessionUseCase checkSessionUseCase;
  late ClearSessionUseCase clearSessionUseCase;
  late IsBiometricEnabledUseCase isBiometricEnabledUseCase;
  late GetSchoolsUseCase getSchoolsUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
    registerUseCase = RegisterUseCase(mockRepository);
    checkSessionUseCase = CheckSessionUseCase(mockRepository);
    clearSessionUseCase = ClearSessionUseCase(mockRepository);
    isBiometricEnabledUseCase = IsBiometricEnabledUseCase(mockRepository);
    getSchoolsUseCase = GetSchoolsUseCase(mockRepository);
  });

  group('Auth Use Cases Tests', () {
    test('LoginUseCase should return success from repository', () async {
      // arrange
      const credentials = LoginCredentials(username: 'u', password: 'p');
      const session = AuthSession(
        userId: 1, 
        username: 'u', 
        name: 'n', 
        email: 'e', 
        hasToken: true
      );
      final result = AuthResult.success(session);
      
      when(() => mockRepository.login(credentials))
          .thenAnswer((_) async => result);

      // act
      final actualResult = await loginUseCase(credentials);

      // assert
      expect(actualResult.isSuccess, true);
      expect(actualResult.data, session);
      verify(() => mockRepository.login(credentials)).called(1);
    });

    test('RegisterUseCase should return error from repository', () async {
      // arrange
      const command = RegisterCommand(
        name: 't', 
        lastName: 'l', 
        email: 'e', 
        username: 'u', 
        password: 'p', 
        age: 20, 
        fileNum: '1', 
        schoolId: 1
      );
      final result = AuthResult<void>.error(AuthFailure.registerFailed);
      
      when(() => mockRepository.register(command))
          .thenAnswer((_) async => result);

      // act
      final actualResult = await registerUseCase(command);

      // assert
      expect(actualResult.isSuccess, false);
      expect(actualResult.failure, AuthFailure.registerFailed);
      verify(() => mockRepository.register(command)).called(1);
    });

    test('CheckSessionUseCase should call repository', () async {
      // arrange
      const session = AuthSession(
        userId: 1, 
        username: 'u', 
        name: 'n', 
        email: 'e', 
        hasToken: true
      );
      when(() => mockRepository.checkSession())
          .thenAnswer((_) async => AuthResult.success(session));

      // act
      await checkSessionUseCase();

      // assert
      verify(() => mockRepository.checkSession()).called(1);
    });

    test('ClearSessionUseCase should call repository', () async {
      // arrange
      when(() => mockRepository.clearSession())
          .thenAnswer((_) async => Future.value());

      // act
      await clearSessionUseCase();

      // assert
      verify(() => mockRepository.clearSession()).called(1);
    });

    test('IsBiometricEnabledUseCase should return bool', () async {
      // arrange
      when(() => mockRepository.isBiometricEnabled()).thenAnswer((_) async => true);

      // act
      final result = await isBiometricEnabledUseCase();

      // assert
      expect(result, true);
    });

    test('GetSchoolsUseCase should return list', () async {
      // arrange
      final schools = [{'id': 1, 'name': 'School'}];
      when(() => mockRepository.getSchools()).thenAnswer((_) async => schools);

      // act
      final result = await getSchoolsUseCase();

      // assert
      expect(result, schools);
    });
  });
}
