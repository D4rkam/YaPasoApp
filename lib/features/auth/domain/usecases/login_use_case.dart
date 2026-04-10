import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/repositories/auth_repository.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResult<AuthSession>> call(LoginCredentials credentials) {
    return _repository.login(credentials);
  }
}
