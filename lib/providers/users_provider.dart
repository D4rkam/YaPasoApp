import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/response_api.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class UsersProvider extends GetConnect {
  String urlCreate = ApiUrl.REGISTER;
  String urlLogin = ApiUrl.LOGIN;
  String urlUser = ApiUrl.USER;
  User userSession = User.fromJson(GetStorage().read("user") ?? {});

  Future<Response> create(User user) async {
    Response response = await post(
      urlCreate,
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

  Future<ResponseApi> checkToken() async {
    Response response = await get(
      urlUser,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userSession.token?["access_token"]}"
      },
    );
    if (response.body == null) {
      return ResponseApi();
    }
    ResponseApi responseApi =
        ResponseApi.fromJson(response.body, response.statusCode == 401);

    return responseApi;
  }
}
