import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/payment_response.dart';
import 'package:prueba_buffet/app/data/provider/pay_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PayController extends GetxController {
  PayProvider payProvider = PayProvider();

  Future<void> _launchMercadoPago(String initPoint) async {
    final uri = Uri.parse(initPoint);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'No se pudo abrir Mercado Pago',
          backgroundColor: const Color(0xFFFF5252),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  void pay(List<ProductForCart> items) async {
    Response response = await payProvider.pay(items);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final paymentResponse = PaymentResponse.fromJson(response.body);
      final initPoint = paymentResponse.preference.initPoint;

      if (initPoint.isNotEmpty) {
        await _launchMercadoPago(initPoint);
      } else {
        Get.snackbar('Error', 'No se recibió el link de pago');
      }
    } else {
      Get.snackbar('Error', response.bodyString ?? 'Error al procesar el pago');
    }
  }
}
