import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:app_links/app_links.dart'; // Asegurate de tener esto en pubspec.yaml
import 'dart:async';

class SecurityFingerController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  Rxn<String> paymentStatus = Rxn<String>();
  bool _isNavigating = false;
  final GetStorage _storage = GetStorage();

  // Instancia de AppLinks y suscripción para limpieza
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onClose() {
    // Es importante cancelar la escucha cuando el controlador se destruye
    _linkSubscription?.cancel();
    super.onClose();
  }

  // Navegación
  void goToHomeScreen() {
    Get.offAllNamed('/home');
  }

  void goToSuccessPage() => Get.offNamedUntil("/success_pay", (route) => false);
  void goToFailurePage() => Get.offNamedUntil("/failure_pay", (route) => false);
  void goToPendingPage() => Get.offNamedUntil("/pending_pay", (route) => false);

  Future<void> checkToken() async {
    ResponseApi response = await usersProvider.checkToken();
    if (response.success) {
      initDeepLinkListener();
    } else {
      _storage.remove("user");
      Get.offNamedUntil('/login', (route) => false);
    }
  }

  // Manejo de enlaces profundos con AppLinks
  Future<void> initDeepLinkListener() async {
    // 1. Manejar el link inicial (si la app se abrió desde un link)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _processDeepLink(initialUri);
      } else {
        // Si no hay link inicial, vamos al home después de un breve delay
        // para asegurar que el checkToken terminó
        goToHomeScreen();
      }
    } catch (e) {
      print("Error obteniendo el link inicial: $e");
      goToHomeScreen();
    }

    // 2. Escuchar links mientras la app está en segundo plano o abierta
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print("Nuevo Deep Link recibido: $uri");
        _processDeepLink(uri);
      }
    }, onError: (err) {
      print("Error en el stream de Deep Links: $err");
    });
  }

  void _processDeepLink(Uri uri) {
    if (_isNavigating) return;
    _isNavigating = true;

    print("Procesando path: ${uri.path}");
    String? status;

    // Usamos path o queryParameters según cómo lo envíe Mercado Pago
    if (uri.path.contains("success") || uri.toString().contains("success")) {
      status = "approved";
    } else if (uri.path.contains("failure") ||
        uri.toString().contains("failure")) {
      status = "failure";
    } else if (uri.path.contains("pending") ||
        uri.toString().contains("pending")) {
      status = "pending";
    }

    if (status != null) {
      paymentStatus.value = status;
      if (status == 'approved')
        goToSuccessPage();
      else if (status == 'failure')
        goToFailurePage();
      else if (status == 'pending') goToPendingPage();
    } else {
      goToHomeScreen();
    }

    _isNavigating = false;
  }
}
