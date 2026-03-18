import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/order_controller.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class MainShellBinding implements Bindings {
  @override
  void dependencies() {
    // 1. Controlador principal del esqueleto
    Get.lazyPut<MainShellController>(() => MainShellController());

    // 2. Provider compartido (usamos fenix para que reviva si se destruye)
    Get.lazyPut<UsersProvider>(() => UsersProvider(), fenix: true);

    // 3. Controladores de las Pestañas (TABS)
    // Usamos lazyPut para que NO llamen a sus onInit() hasta que el usuario abra la pestaña
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);

    // NOTA: BalanceController NO va acá, ya pertenece al InitialBinding (es global)
  }
}
