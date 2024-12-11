import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}


/* 
Get.put() -> inyecta la dependencia directo en memoria, ideal para estados globales. Ejemplo: carrito de compras
Get.lazyPut() -> crea una nueva instancia con cada llamado, aumenta el rendimiento de la app
 */
