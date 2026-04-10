import 'package:get/get.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/clear_session_use_case.dart';

enum AuthGateDestination { home, login }

class AuthSecurityGateControllerV2 extends GetxController {
  final CheckSessionUseCase _checkSessionUseCase;
  final ClearSessionUseCase _clearSessionUseCase;
  final IsBiometricEnabledUseCase _isBiometricEnabledUseCase;

  AuthSecurityGateControllerV2(
    this._checkSessionUseCase,
    this._clearSessionUseCase,
    this._isBiometricEnabledUseCase,
  );

  final isLoading = false.obs;
  final requiresBiometric = false.obs;

  Future<void> loadGateConfig() async {
    requiresBiometric.value = await _isBiometricEnabledUseCase();
  }

  Future<AuthGateDestination> validateSession() async {
    isLoading.value = true;
    try {
      final result = await _checkSessionUseCase();
      if (result.isSuccess) {
        return AuthGateDestination.home;
      }
      await _clearSessionUseCase();
      return AuthGateDestination.login;
    } finally {
      isLoading.value = false;
    }
  }
}
