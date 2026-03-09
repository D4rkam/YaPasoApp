import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class MainShellBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(() => MainShellController());
    Get.lazyPut<HomeController>(() => HomeController());
    // UsersProvider es requerido por OrderController – registrar antes
    if (!Get.isRegistered<UsersProvider>()) {
      Get.lazyPut<UsersProvider>(() => UsersProvider());
    }
    // put (no lazy) para que las órdenes se carguen al entrar al shell
    // y la inyección local funcione siempre
    if (!Get.isRegistered<OrderController>()) {
      Get.put<OrderController>(OrderController());
    }
  }
}
