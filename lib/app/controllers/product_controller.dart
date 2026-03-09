import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';

class ProductController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();

  final Rx<Product?> product = Rx<Product?>(null);

  final RxInt quantitySelected = 0.obs;

  void getProduct(String id) async {
    Response response = await productsProvider.getProductById(id);
    product.value = Product.fromJson(response.body);
    product.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    getProduct(Get.arguments);
  }
}
