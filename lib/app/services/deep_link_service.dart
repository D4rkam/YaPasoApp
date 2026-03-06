import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/routes/routes.dart';

/// Manejo simple de deep links de MercadoPago.
///
/// MercadoPago redirige al usuario con una URL tipo:
///   yapaso://success?collection_status=approved&payment_id=123...
///   yapaso://failure?collection_status=rejected&...
///   yapaso://pending?collection_status=in_process&...
///
/// El **host** del URI (success/failure/pending) determina la pantalla.
class DeepLinkService extends GetxService {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void onInit() {
    super.onInit();
    _appLinks = AppLinks();
    _listen();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _listen() {
    // Solo escuchamos el stream. Esto cubre:
    //  - Warm start (app en background, vuelve al frente por el link)
    //  - Cold start (app cerrada, se abre por el link)
    //    En cold start, app_links entrega el initial link también por el stream
    //    una vez que hay un listener activo.
    _sub = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (e) => print('DeepLinkService: error en stream → $e'),
    );
  }

  void _handleUri(Uri uri) {
    print('DeepLinkService: recibido → $uri');

    final route = _resolveRoute(uri);
    final paymentId = _getPaymentId(uri);
    final externalRef = _getExternalReference(uri);

    if (route == null) {
      print('DeepLinkService: URI ignorado (host no reconocido: ${uri.host})');
      return;
    }

    print('DeepLinkService: navegando a $route');
    print('DeepLinkService: payment_id → $paymentId');
    print('DeepLinkService: external_reference → $externalRef');
    Get.offAllNamed(route, arguments: {
      'payment_id': paymentId,
      'external_reference': externalRef,
    });
  }

  /// Mapea el host del URI a una ruta de la app.
  String? _resolveRoute(Uri uri) {
    switch (uri.host.toLowerCase()) {
      case 'success':
        return Routes.SUCCESS_PAY;
      case 'failure':
        return Routes.FAILURE_PAY;
      case 'pending':
        return Routes.PENDING_PAY;
      default:
        return null;
    }
  }

  String? _getPaymentId(Uri uri) {
    print(uri.queryParameters['payment_id']);
    return uri.queryParameters['payment_id'];
  }

  String? _getExternalReference(Uri uri) {
    return uri.queryParameters['external_reference'];
  }
}
