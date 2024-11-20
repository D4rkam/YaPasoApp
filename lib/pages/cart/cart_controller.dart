import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/user.dart';

class CartController extends GetxController {
  User userSession = User.fromJson(GetStorage().read("user") ?? {});

  // HomeController() {
  //   print("USUARIO SESION: ${userSession.toJson()}");
  // }

  void signOut() {
    GetStorage().remove("user");
    Get.offNamedUntil("/", (route) => false);
  }

  void goToProduct() {
    Get.toNamed(
      "/cart",
    );
  }
}
