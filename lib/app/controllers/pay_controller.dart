import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/pay_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PayController extends GetxController {
  PayProvider payProvider = PayProvider();

  Future<void> transformarYAbrirLinkMercadoPago(String linkMercadoPago) async {
    // Extraer el ID de la preferencia
    final regex = RegExp(r'pref_id=([^&]+)');
    final match = regex.firstMatch(linkMercadoPago);

    if (match != null) {
      final preferenceId = match.group(1);

      final nuevoLink =
          "https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=$preferenceId";

      final uriLink = Uri.parse(nuevoLink);
      if (await canLaunchUrl(uriLink)) {
        await launchUrl(uriLink);
      } else {
        print('No se pudo abrir el link: $nuevoLink');
      }
    } else {
      print('No se encontró el ID de preferencia en el link');
    }
  }

  void pay(List<ProductForCart> items) async {
    Response response = await payProvider.pay(items);
    if (response.statusCode == 200) {
      String? url = response.body["init_point"];
      if (url != null) {
        transformarYAbrirLinkMercadoPago(url);
      }
    }
  }
}
