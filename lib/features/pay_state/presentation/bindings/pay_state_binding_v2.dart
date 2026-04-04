import 'package:get/get.dart';
import 'package:prueba_buffet/features/pay_state/presentation/controllers/pay_state_controller_v2.dart';

class PayStateBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayStateControllerV2>(() => PayStateControllerV2());
  }
}
