import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/features/analytics/domain/constants/analytics_constants.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:prueba_buffet/features/analytics/domain/usecases/identify_use_cases.dart';

import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/login_use_case.dart';

class AuthLoginControllerV2 extends GetxController {
  final LoginUseCase _loginUseCase;
  final IdentifyUseCases _identifyUseCases;

  AuthLoginControllerV2(this._loginUseCase, this._identifyUseCases);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameError = RxnString();
  final passwordError = RxnString();
  final authError = RxnString();
  final isLoading = false.obs;

  bool validateForm() {
    usernameError.value = null;
    passwordError.value = null;

    var valid = true;
    if (usernameController.text.trim().isEmpty) {
      usernameError.value = 'Ingresa tu nombre de usuario';
      valid = false;
    }
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Ingresa tu contrasena';
      valid = false;
    }
    return valid;
  }

  Future<bool> submit() async {
    final stopwatch = Stopwatch()..start();
    authError.value = null;
    if (!validateForm()) return false;

    isLoading.value = true;
    final result = await _loginUseCase(
      LoginCredentials(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    isLoading.value = false;

    if (result.isSuccess) {
      final user = User.safeFromStorage();
      if (user.id != null) {
        await _identifyUseCases.identify(user);
        stopwatch.stop();
        _trackViewLogin(stopwatch);
      }
      return true;
    }

    authError.value = result.failure?.message;
    return false;
  }

  void _trackViewLogin(Stopwatch stopwatch) {
    Get.find<AnalyticsRepository>().capture(
      eventName: AnalyticsEvents.loginSuccess,
      properties: <String, Object>{
        AnalyticsProperties.loadingTimeMs: stopwatch.elapsedMilliseconds,
      },
    );
  }

}
