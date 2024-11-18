import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/product.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/providers/products_provider.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  User userSession = User.fromJson(GetStorage().read("user") ?? {});
  var productsFromApi = <Product>[].obs;
  var categoryProducts = <String>[].obs;

  void signOut() {
    GetStorage().remove("user");
    Get.offNamedUntil("/", (route) => false);
  }

  void goToProduct() {
    Get.toNamed(
      "/product",
    );
  }

  void goToShoppingCart() {
    Get.toNamed(
      "/shopping_cart",
    );
  }

  void goToPay() {
    Get.toNamed(
      "/pay",
    );
  }

  int getBalance() {
    return userSession.balance!;
  }

  void getCategoryOfProducts() {
    final List<String> categorys = [
      "Snacks",
      "Galletitas",
      "Bebidas",
      "Golosinas",
    ];
    categoryProducts.assignAll(categorys);
  }

  void getProducts() async {
    var response = await productsProvider.getProducts();

    if (response.statusCode == 200) {
      log("products: ${productsFromApi}");
      productsFromApi.assignAll(productFromJson(response.body));

      productsFromApi.refresh();
    }
  }
}
