import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/success_controller.dart';

class SuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessController>(() => SuccessController());
  }
}
