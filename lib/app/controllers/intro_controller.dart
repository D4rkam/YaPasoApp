import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class IntroController extends GetxController {
  void goToLogin() {
    if (GetStorage().read<bool>('enable_auth_v2_login') ?? false) {
      Get.toNamed("/login_v2");
    } else {
      Get.toNamed("/login");
    }
  }
}
