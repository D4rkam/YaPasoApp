import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  User userSession = User.fromJson(GetStorage().read("user") ?? {});
  var balanceUser = 0.obs;

  var productsFromApi = <Product>[].obs;
  List<String> listaCategorias = [
    "Snacks",
    "Galletitas",
    "Bebidas",
    "Golosinas"
  ];

  void signOut() {
    if (Get.isRegistered<ShoppingCartController>()) {
      Get.delete<ShoppingCartController>();
    }
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

  void goToCategory(String category) {
    Get.toNamed(
      "/category",
      arguments: category,
    );
  }

  void goToPay() {
    Get.toNamed(
      "/pay",
    );
  }

  void getBalance() {
    balanceUser.value = userSession.balance!;
  }

  void getProducts() async {
    var response = await productsProvider.getProducts();

    if (response.statusCode == 200) {
      productsFromApi.assignAll(productFromJson(response.body));
      productsFromApi.refresh();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProducts();
    getBalance();
  }
}
