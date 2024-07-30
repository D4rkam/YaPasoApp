import 'package:get/get.dart';
import 'package:prueba_buffet/enviroment/enviroment.dart';
import 'package:prueba_buffet/models/response_api.dart';
import 'package:prueba_buffet/models/user.dart';

class UsersProvider extends GetConnect {
  String urlCreate = "${Enviroment.API_URL}api/auth";
  String urlLogin = "${Enviroment.API_URL}api/auth/login";

  Future<Response> create(User user) async {
    Response response = await post(
      "$urlCreate/",
      user.toJson(),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<ResponseApi> login(String username, String password) async {
    Response response = await post(
      urlLogin,
      headers: {
        "Content-Type": "application/json",
        // "accept": "application/json"
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
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
