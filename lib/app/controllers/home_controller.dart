import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  UsersProvider usersProvider = UsersProvider();
  User userSession = User.safeFromStorage();
  var tabIndex = 1.obs;

  /// Saldo: referencia directa al BalanceController (fuente única de verdad)
  BalanceController get balanceController => Get.find<BalanceController>();
  Rx<double> get balanceUser => balanceController.balance;

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
    usersProvider.logout();
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

  Future<void> getProducts() async {
    var response = await productsProvider.getProducts();

    if (response.statusCode == 200) {
      productsFromApi.assignAll(productFromJson(response.body));
      productsFromApi.refresh();
    }
  }

  /// Pull-to-refresh: refresca productos y saldo en paralelo.
  Future<void> refreshHome() async {
    await Future.wait([
      getProducts(),
      balanceController.fetchBalance(),
    ]);
  }

  @override
  void onInit() {
    super.onInit();
    getProducts();
    // Refrescar saldo desde el servidor (lo hace BalanceController)
    balanceController.fetchBalance();
  }
}
