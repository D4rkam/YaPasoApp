import 'package:dio/dio.dart' show Response;
import 'package:prueba_buffet/core/data/providers/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class PaymentsApiProvider extends BaseProvider {
  Future<Response> startMercadoPagoPayment(Map<String, dynamic> body) {
    return dio.post(ApiUrl.PAY, data: body);
  }

  Future<Response> createOrder(Map<String, dynamic> body) {
    return dio.post(ApiUrl.ORDER, data: body);
  }

  Future<Response> payWithBalance({
    required double amount,
    required int sellerId,
    required int orderId,
  }) {
    return dio.post(
      ApiUrl.PAY_BALANCE,
      data: {
        'amount': amount,
        'seller_id': sellerId,
        'order_id': orderId,
      },
    );
  }
}
