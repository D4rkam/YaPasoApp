import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/models/product.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/providers/products_provider.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  User userSession = User.fromJson(GetStorage().read("user") ?? {});

  var productsFromApi = <Product>[].obs;
  List<String> listaCategorias = [
    "Snacks",
    "Galletitas",
    "Bebidas",
    "Golosinas"
  ];

  void signOut() {
    GetStorage().remove("user");
    Get.offNamedUntil("/login", (route) => false);
  }

  void goToMyBalance() {
    Get.toNamed(
      "/my_balance",
    );
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

  void goToMisPedidos() {
    Get.toNamed(
      "/orders",
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

  void getProducts() async {
    var response = await productsProvider.getProducts();

    if (response.statusCode == 200) {
      productsFromApi.assignAll(productFromJson(response.body));
      productsFromApi.refresh();
    }
  }
}
