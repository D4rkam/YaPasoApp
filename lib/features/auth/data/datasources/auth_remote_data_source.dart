import 'package:dio/dio.dart' show Response;
import 'package:prueba_buffet/features/auth/data/providers/auth_api_provider.dart';

class AuthRemoteDataSource {
  final AuthApiProvider _provider;

  AuthRemoteDataSource(this._provider);

  Future<Response> login({
    required String username,
    required String password,
  }) {
    return _provider.login(username: username, password: password);
  }

  Future<Response> register(Map<String, dynamic> userPayload) {
    return _provider.register(userPayload);
  }

  Future<Response> checkToken() {
    return _provider.checkToken();
  }

  Future<List<Map<String, dynamic>>> getSchools() {
    return _provider.getSchools();
  }
}
