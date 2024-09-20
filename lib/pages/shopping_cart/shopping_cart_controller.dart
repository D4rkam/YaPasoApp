import 'package:get/get.dart';
import 'package:prueba_buffet/providers/pay_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoppingCartController extends GetxController {
  PayProvider payProvider = PayProvider();

  final List<Map<String, dynamic>> items = [
    {
      "title": "cafe",
      "quantity": 1,
      "unit_price": 600,
    },
  ];

  Future<void> transformarYAbrirLinkMercadoPago(String linkMercadoPago) async {
    // Extraer el ID de la preferencia
    final regex = RegExp(r'pref_id=([^&]+)');
    final match = regex.firstMatch(linkMercadoPago);

    if (match != null) {
      final preferenceId = match.group(1);
      final nuevoLink =
          'mercadopago://sandbox/payment?preference_id=$preferenceId';

      final uriLink = Uri.parse(nuevoLink);
      print(uriLink);
      await launchUrl(uriLink);
      if (await canLaunchUrl(Uri.parse(nuevoLink))) {
      } else {
        print('No se pudo abrir el link: $nuevoLink');
      }
    } else {
      print('No se encontró el ID de preferencia en el link');
    }
  }

  void pay() async {
    Response response = await payProvider.pay(items);
    String? url = response.body["sandbox_init_point"];
    if (url != null) {
      // transformarYAbrirLinkMercadoPago(url);
      Get.toNamed("/pay", arguments: Future.value(url));
    }
  }
}
