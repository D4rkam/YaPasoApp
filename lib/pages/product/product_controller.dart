import 'package:get/get.dart';
import 'package:prueba_buffet/models/product.dart';
import 'package:prueba_buffet/providers/products_provider.dart';

class ProductController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();

  final Rx<Product?> product = Rx<Product?>(null);

  void getProduct(int id) async {
    Response response = await productsProvider.getProductById(id);
    product.value = Product.fromJson(response.body);
    product.refresh();
  }
}
