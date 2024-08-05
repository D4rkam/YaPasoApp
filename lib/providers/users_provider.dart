import 'package:get/get.dart';
import 'package:prueba_buffet/models/response_api.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class UsersProvider extends GetConnect {
  String urlCreate = ApiUrl.REGISTER;
  String urlLogin = ApiUrl.LOGIN;

  Future<Response> create(User user) async {
    Response response = await post(
      urlCreate,
      user.toJson(),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<ResponseApi> login(String username, String password) async {
    print("${ApiUrl.LOGIN}");
    Response response = await post(
      urlLogin,
      headers: {
        "Content-Type": "application/json",
      },
      {
        "username": username,
        "password": password,
      },
    );

    if (response.body == null) {
      Get.snackbar("Error", "No se pudo ejecutar la peticion");
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(
      response.body,
      response.statusCode == 200,
    );
    return responseApi;
  }
}
