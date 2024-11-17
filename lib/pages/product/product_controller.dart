import 'package:get/get.dart';
import 'package:prueba_buffet/models/product.dart';
import 'package:prueba_buffet/providers/products_provider.dart';

class ProductController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();

  Product? product;

  void getProduct(int id) async {
    var response = await productsProvider.getProductById(id);
    product = Product.fromJson(response.body);
  }
}
