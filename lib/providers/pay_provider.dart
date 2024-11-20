import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class PayProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read("user") ?? {});
  String urlPay = ApiUrl.PAY;

  Future<Response> pay(List<Map<String, dynamic>> items) async {
    Response response = await post(
      urlPay,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userSession.token?["access_token"]}"
      },
      items,
    );

    if (response.body == null) {
      Get.snackbar("Error", "No se pudo ejecutar la peticion");
      return const Response();
    }
    return response;
  }
}
