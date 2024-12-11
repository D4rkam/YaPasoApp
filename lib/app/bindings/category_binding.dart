import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
