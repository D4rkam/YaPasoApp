import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/product.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/providers/products_provider.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  User userSession = User.fromJson(GetStorage().read("user") ?? {});
  var products = <Product>[].obs;

  void signOut() {
    GetStorage().remove("user");
    Get.offNamedUntil("/", (route) => false);
  }

  void goToProduct() {
    Get.toNamed(
      "/product",
    );
  }

  double getBalance() {
    return userSession.balance!;
  }

  void getProducts() async {
    var response = await productsProvider.getProducts();

    products.addAllIf(
      response.statusCode == 200,
      productFromJson(response.body),
    );
    // if (response.statusCode == 200) {
    //   products.assignAll(productFromJson(response.body));
    // }
    log(products.toString());
  }
}
