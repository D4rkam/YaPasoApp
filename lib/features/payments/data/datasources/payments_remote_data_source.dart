import 'package:dio/dio.dart' show Response;
import 'package:prueba_buffet/features/payments/data/providers/payments_api_provider.dart';

class PaymentsRemoteDataSource {
  final PaymentsApiProvider _provider;

  PaymentsRemoteDataSource(this._provider);

  Future<Response> startMercadoPagoPayment(Map<String, dynamic> payload) {
    return _provider.startMercadoPagoPayment(payload);
  }

  Future<Response> createOrder(Map<String, dynamic> payload) {
    return _provider.createOrder(payload);
  }

  Future<Response> payWithBalance({
    required double amount,
    required int sellerId,
    required int orderId,
  }) {
    return _provider.payWithBalance(
      amount: amount,
      sellerId: sellerId,
      orderId: orderId,
    );
  }
}
