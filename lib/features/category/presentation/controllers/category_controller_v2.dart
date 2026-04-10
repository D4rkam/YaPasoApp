import 'package:get/get.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/category/domain/repositories/category_repository.dart';
import 'package:prueba_buffet/features/category/domain/usecases/get_products_by_category_use_case.dart';

class CategoryControllerV2 extends GetxController {
  late final GetProductsByCategoryUseCase _getProductsByCategory;

  RxList<Product> products = <Product>[].obs;
  RxBool isLoading = true.obs;

  CategoryControllerV2({required CategoryRepository repository}) {
    _getProductsByCategory = GetProductsByCategoryUseCase(repository);
  }

  Future<void> getProducts(String category) async {
    isLoading.value = true;
    try {
      final result = await _getProductsByCategory(category);
      products.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Solo auto-fetch si se navega como ruta independiente con arguments
    if (Get.arguments != null) {
      getProducts(Get.arguments);
    }
  }
}
