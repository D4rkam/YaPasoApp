import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/features/auth/domain/entities/register_command.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/register_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_register_controller_v2.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';
import 'package:prueba_buffet/features/auth/domain/errors/auth_failure.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockGetSchoolsUseCase extends Mock implements GetSchoolsUseCase {}

void main() {
  late AuthRegisterControllerV2 controller;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGetSchoolsUseCase mockGetSchoolsUseCase;

  setUpAll(() {
    registerFallbackValue(RegisterCommand(
      username: '', name: '', lastName: '', password: '', email: '', fileNum: '', age: 0, schoolId: 0,
    ));
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockGetSchoolsUseCase = MockGetSchoolsUseCase();

    // Mock schools loading which happens on onInit
    when(() => mockGetSchoolsUseCase()).thenAnswer((_) async => []);

    controller = AuthRegisterControllerV2(mockRegisterUseCase, mockGetSchoolsUseCase);
    controller.onInit();
  });

  group('AuthRegisterControllerV2 Tests', () {
    test('validateCurrentStep should return false if name/lastName are empty in step 0', () {
      controller.currentStep.value = 0;
      controller.nameController.text = "";
      controller.lastNameController.text = "";

      expect(controller.validateCurrentStep(), false);
      expect(controller.nameError.value, isNotNull);
      expect(controller.lastNameError.value, isNotNull);
    });

    test('validateCurrentStep should return true if name/lastName are filled in step 0', () {
      controller.currentStep.value = 0;
      controller.nameController.text = "John";
      controller.lastNameController.text = "Doe";

      expect(controller.validateCurrentStep(), true);
      expect(controller.nameError.value, isNull);
      expect(controller.lastNameError.value, isNull);
    });

    test('submit should return false and set formError if result is failure', () async {
      // arrange
      controller.nameController.text = "John";
      controller.lastNameController.text = "Doe";
      controller.emailController.text = "john@example.com";
      controller.usernameController.text = "johndoe";
      controller.fileNumberController.text = "12345";
      controller.passwordController.text = "Password123";
      controller.confirmPasswordController.text = "Password123";
      controller.selectedSchoolId.value = 1;
      controller.acceptedTerms.value = true;

      when(() => mockRegisterUseCase(any())).thenAnswer((_) async => AuthResult.error(AuthFailure.registerFailed));

      // act
      final result = await controller.submit();

      // assert
      expect(result, false);
      expect(controller.formError.value, AuthFailure.registerFailed.message);
      expect(controller.isLoading.value, false);
    });

    test('submit should return true if use case succeeds', () async {
      // arrange
      controller.nameController.text = "John";
      controller.lastNameController.text = "Doe";
      controller.emailController.text = "john@example.com";
      controller.usernameController.text = "johndoe";
      controller.fileNumberController.text = "12345";
      controller.passwordController.text = "Password123";
      controller.confirmPasswordController.text = "Password123";
      controller.selectedSchoolId.value = 1;
      controller.acceptedTerms.value = true;

      when(() => mockRegisterUseCase(any())).thenAnswer((_) async => AuthResult.success(true));

      // act
      final result = await controller.submit();

      // assert
      expect(result, true);
      expect(controller.formError.value, isNull);
    });
  });
}
