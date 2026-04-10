import 'package:prueba_buffet/features/auth/domain/repositories/auth_repository.dart';

class ClearSessionUseCase {
  final AuthRepository _repository;

  ClearSessionUseCase(this._repository);

  Future<void> call() {
    return _repository.clearSession();
  }
}
