import 'package:get/get.dart';

class PayController extends GetxController {
  void goToSuccessPage() {
    Get.offNamedUntil("/success", (route) => false);
  }

  void goToFailurePage() {
    Get.offNamedUntil("/failure", (route) => false);
  }

  void goToPendingPage() {
    Get.offNamedUntil("/pending", (route) => false);
  }
}
