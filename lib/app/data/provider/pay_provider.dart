import 'dart:convert';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class PayProvider extends BaseProvider {
  String urlPay = ApiUrl.PAY;

  Future<Response> pay(List<ProductForCart> items) async {
    final List<Map<String, Object>> mappedItems = items.map((item) {
      return {
        "id": item.id,
        "title": item.name,
        "unit_price": item.price,
        "quantity": item.quantity.value,
      };
    }).toList();

    String itemsForRequest = jsonEncode(mappedItems);

    // Los headers de Authorization/Cookie se manejarán automáticamente por
    // el BaseProvider
    Response response = await post(
      urlPay,
      itemsForRequest,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.body == null) {
      Get.snackbar("Error", "No se pudo ejecutar la peticion");
      return const Response();
    }
    return response;
  }

  Future<Response> pay_with_balance(
      double amount, int seller_id, int order_id) async {
    Response response = await post(
      ApiUrl.PAY_BALANCE,
      jsonEncode({
        "amount": amount,
        "seller_id": seller_id,
        "order_id": order_id,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.body == null) {
      Get.snackbar("Error", "No se pudo ejecutar la peticion");
      return const Response();
    }
    return response;
  }
}
