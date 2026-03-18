import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/product_controller.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.delete<ProductController>(force: true);
    Get.put<ProductController>(ProductController());
  }
}
