import 'package:dio/dio.dart' show Response;
import 'package:prueba_buffet/core/data/providers/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class AuthApiProvider extends BaseProvider {
  Future<Response> login({
    required String username,
    required String password,
  }) {
    return dio.post(
      ApiUrl.LOGIN,
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  Future<Response> register(Map<String, dynamic> userPayload) {
    return dio.post(ApiUrl.REGISTER, data: userPayload);
  }

  Future<Response> checkToken() {
    return dio.get(ApiUrl.USER);
  }

  Future<List<Map<String, dynamic>>> getSchools() async {
    final response = await dio.get(ApiUrl.SCHOOLS);
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return const [];
  }
}
