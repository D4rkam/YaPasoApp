import 'package:get/get.dart';
import 'package:prueba_buffet/models/product.dart';
import 'package:prueba_buffet/providers/products_provider.dart';

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
        products.assignAll(productFromJson(response.body));
      } else {
        // Handle error
      }
    } finally {
      isLoading.value = false;
    }
  }
}
