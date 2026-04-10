import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/entities/register_command.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult<AuthSession>> login(LoginCredentials credentials);

  Future<AuthResult<void>> register(RegisterCommand command);

  Future<AuthResult<AuthSession>> checkSession();

  Future<void> clearSession();

  Future<bool> isBiometricEnabled();

  Future<List<Map<String, dynamic>>> getSchools();
}
