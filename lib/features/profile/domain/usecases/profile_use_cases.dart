import 'package:prueba_buffet/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;
  UpdateProfileUseCase(this._repository);
  Future<bool> call(Map<String, dynamic> data) => _repository.updateProfile(data);
}

class UpdateEmailUseCase {
  final ProfileRepository _repository;
  UpdateEmailUseCase(this._repository);
  Future<bool> call(String newEmail) => _repository.updateEmail(newEmail);
}

class UpdatePasswordUseCase {
  final ProfileRepository _repository;
  UpdatePasswordUseCase(this._repository);
  Future<bool> call(String oldPassword, String newPassword) =>
      _repository.updatePassword(oldPassword, newPassword);
}

class DeleteAccountUseCase {
  final ProfileRepository _repository;
  DeleteAccountUseCase(this._repository);
  Future<bool> call() => _repository.deleteAccount();
}
