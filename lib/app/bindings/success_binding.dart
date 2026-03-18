import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/pay_state_controller.dart';

class SuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayStateController>(() => PayStateController());
  }
}
