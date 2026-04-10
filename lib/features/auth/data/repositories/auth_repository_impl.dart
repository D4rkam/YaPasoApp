import 'package:prueba_buffet/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:prueba_buffet/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prueba_buffet/features/auth/data/models/auth_session_model.dart';
import 'package:prueba_buffet/features/auth/data/models/auth_user_dto.dart';
import 'package:prueba_buffet/features/auth/domain/entities/auth_session.dart';
import 'package:prueba_buffet/features/auth/domain/entities/login_credentials.dart';
import 'package:prueba_buffet/features/auth/domain/entities/register_command.dart';
import 'package:prueba_buffet/features/auth/domain/errors/auth_failure.dart';
import 'package:prueba_buffet/features/auth/domain/repositories/auth_repository.dart';
import 'package:prueba_buffet/features/auth/domain/results/auth_result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<AuthResult<AuthSession>> login(LoginCredentials credentials) async {
    try {
      final response = await _remote.login(
        username: credentials.username,
        password: credentials.password,
      );

      if (response.statusCode != 200 || response.data == null) {
        return AuthResult.error(AuthFailure.invalidCredentials);
      }

      if (response.data is! Map) {
        return AuthResult.error(AuthFailure.invalidCredentials);
      }

      final userDto = AuthUserDto.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
      await _local.saveUser(userDto.toStorageMap());
      return AuthResult.success(AuthSessionModel.fromUserDto(userDto));
    } catch (_) {
      return AuthResult.error(AuthFailure.networkError);
    }
  }

  @override
  Future<AuthResult<void>> register(RegisterCommand command) async {
    try {
      final response = await _remote.register({
        'username': command.username,
        'name': command.name,
        'last_name': command.lastName,
        'password': command.password,
        'file_num': command.fileNum,
        'age': command.age,
        'email': command.email,
        'school_id': command.schoolId,
      });
      if (response.statusCode == 201) {
        return AuthResult.success(null);
      }
      return AuthResult.error(AuthFailure.registerFailed);
    } catch (_) {
      return AuthResult.error(AuthFailure.networkError);
    }
  }

  @override
  Future<AuthResult<AuthSession>> checkSession() async {
    try {
      final response = await _remote.checkToken();
      if (response.statusCode != 200 || response.data == null) {
        return AuthResult.error(AuthFailure.invalidSession);
      }

      if (response.data is! Map) {
        return AuthResult.error(AuthFailure.invalidSession);
      }

      final userDto = AuthUserDto.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
      await _local.saveUser(userDto.toStorageMap());
      return AuthResult.success(AuthSessionModel.fromUserDto(userDto));
    } catch (_) {
      return AuthResult.error(AuthFailure.networkError);
    }
  }

  @override
  Future<void> clearSession() {
    return _local.clearUser();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return _local.isBiometricEnabled();
  }

  @override
  Future<List<Map<String, dynamic>>> getSchools() {
    return _remote.getSchools();
  }
}
