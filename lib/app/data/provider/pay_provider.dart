import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart'
    show Response, Options; // Importamos Response de Dio
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class PayProvider extends BaseProvider {
  String urlPay = ApiUrl.PAY;

  Future<Response?> pay(
      List<ProductForCart> items, String datetimeOrder) async {
    final List<Map<String, Object>> mappedItems = items.map((item) {
      return {
        "id": item.id,
        "title": item.name,
        "unit_price": item.price,
        "quantity": item.quantity.value,
      };
    }).toList();

    Map<String, dynamic> requestBody = {
      "items": mappedItems,
      "datetime_order": datetimeOrder,
    };

    try {
      // Usamos dio.post y pasamos el map directamente a 'data'
      Response response = await dio.post(
        urlPay,
        data: requestBody,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      return response;
    } catch (e) {
      Get.snackbar("Error", "No se pudo ejecutar la petición de pago");
      return null;
    }
  }

  Future<Response?> payWithBalance(
      double amount, int seller_id, int order_id) async {
    try {
      Response response = await dio.post(
        ApiUrl.PAY_BALANCE,
        data: {
          "amount": amount,
          "seller_id": seller_id,
          "order_id": order_id,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      return response;
    } catch (e) {
      Get.snackbar("Error", "No se pudo ejecutar el pago con saldo");
      return null;
    }
  }
}
