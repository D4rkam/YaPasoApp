import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/repositories/auth_repository.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';

class CheckSessionUseCase {
  final AuthRepository _repository;

  CheckSessionUseCase(this._repository);

  Future<AuthResult<AuthSession>> call() {
    return _repository.checkSession();
  }
}

class IsBiometricEnabledUseCase {
  final AuthRepository _repository;

  IsBiometricEnabledUseCase(this._repository);

  Future<bool> call() {
    return _repository.isBiometricEnabled();
  }
}

class GetSchoolsUseCase {
  final AuthRepository _repository;

  GetSchoolsUseCase(this._repository);

  Future<List<Map<String, dynamic>>> call() {
    return _repository.getSchools();
  }
}
