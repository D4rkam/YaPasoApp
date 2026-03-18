import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';

class CategoryController extends GetxController {
  final productsProvider = ProductsProvider();
  RxList<Product> products = <Product>[].obs;
  RxBool isLoading = true.obs;

  Future<void> getProducts(String category) async {
    isLoading.value = true;
    try {
      final response =
          await productsProvider.getProductsByCategory(category.toLowerCase());
      if (response.statusCode == 200) {
        products.assignAll(productFromJson(response.data["products"]));
      } else {
        // Handle error
      }
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
