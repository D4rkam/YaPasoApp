import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:uni_links/uni_links.dart';

class SecurityFingerController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  Rxn<String> paymentStatus = Rxn<String>();
  bool _isNavigating = false;
  final GetStorage _storage = GetStorage();

  // Navegación
  void goToHomeScreen() {
    Get.offAllNamed('/home');
  }

  void goToSuccessPage() {
    Get.offNamedUntil("/success_pay", (route) => false);
  }

  void goToFailurePage() {
    Get.offNamedUntil("/failure_pay", (route) => false);
  }

  void goToPendingPage() {
    Get.offNamedUntil("/pending_pay", (route) => false);
  }

  // Verifica el token y actualiza el estado de autenticación
  Future<void> checkToken() async {
    ResponseApi response = await usersProvider.checkToken();
    if (response.success) {
      initDeepLinkListener();
    } else {
      _storage.remove("user");
      Get.offNamedUntil('/login', (route) => false);
    }
  }

  // Manejo de enlaces profundos
  Future<void> initDeepLinkListener() async {
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      _processDeepLink(initialUri);
    }

    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _processDeepLink(uri);
        goToHomeScreen();
      }
      goToHomeScreen();
    }, onError: (err) {
      print("Error al procesar Deep Links: $err");
    });
    goToHomeScreen();
  }

  void _processDeepLink(Uri uri) {
    print("dentro de la funcion");
    if (_isNavigating) return;

    _isNavigating = true;
    late String status;

    if (uri.pathSegments.contains("success")) {
      status = "approved";
      paymentStatus.value = status;
    } else if (uri.pathSegments.contains("failure")) {
      status = "failure";
      paymentStatus.value = status;
    } else if (uri.pathSegments.contains("pending")) {
      status = "pending";
      paymentStatus.value = status;
    } else {
      goToHomeScreen();
    }

    if (status == 'approved') {
      goToSuccessPage();
    } else if (status == 'failure') {
      goToFailurePage();
    } else if (status == 'pending') {
      goToPendingPage();
    }
    _isNavigating = false;
  }
}
