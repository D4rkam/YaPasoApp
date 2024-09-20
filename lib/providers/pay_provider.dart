import 'package:get/get.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class PayProvider extends GetConnect {
  String urlPay = ApiUrl.PAY;

  Future<Response> pay(List<Map<String, dynamic>> items) async {
    print(items);
    Response response = await post(
      urlPay,
      headers: {
        "Content-Type": "application/json",
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
