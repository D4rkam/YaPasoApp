import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';

import 'package:prueba_buffet/utils/logger.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  UsersProvider usersProvider = UsersProvider();
  User userSession = User.safeFromStorage();

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
    Get.find<MainShellController>().goToBalance();
  }

  void goToProduct() {
    Get.toNamed(
      "/product",
    );
  }

  void goToAllProducts() {
    Get.toNamed(
      "/products",
    );
  }

  void goToShoppingCart() {
    Get.toNamed(
      "/shopping_cart",
    );
  }

  void goToCategory(String category) {
    Get.find<MainShellController>().goToCategory(category);
  }

  void goToPay() {
    Get.toNamed(
      "/pay",
    );
  }

  Future<void> getProducts() async {
    var response = await productsProvider.getProducts();

    if (response.statusCode == 200) {
      productsFromApi.assignAll(productFromJson(response.data["products"]));
      productsFromApi.refresh();
    }
  }

  Future<void> getTopSellingProducts() async {
    var response = await productsProvider.getTopSellingProducts();

    if (response.statusCode == 200) {
      productsFromApi.assignAll(productFromJson(response.data));
      productsFromApi.refresh();
    }
  }

  /// Pull-to-refresh: refresca productos y saldo en paralelo.
  Future<void> refreshHome() async {
    await Future.wait([
      getTopSellingProducts(),
      balanceController.fetchBalance(),
    ]);
  }

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxBool isSearchFocused = false.obs;

  var searchQuery = ''.obs;

  // ---> NUEVO: Lista separada que guarda los resultados que manda la API
  var searchResultsFromApi = <Product>[].obs;

  // Para mostrar un circulito de carga mientras el servidor busca (opcional)
  RxBool isSearchingApi = false.obs;

  RxBool hasConnectionError = false.obs;

  @override
  void onInit() {
    super.onInit();

    searchFocusNode.addListener(() {
      isSearchFocused.value = searchFocusNode.hasFocus;
    });

    // ---> LA MAGIA DEL DEBOUNCE <---
    // Observa 'searchQuery'. Si cambia, espera 500 milisegundos.
    // Si el usuario vuelve a escribir antes de los 500ms, el reloj se reinicia.
    debounce(searchQuery, (String query) {
      if (query.trim().isNotEmpty) {
        searchProductsInBackend(query);
      } else {
        searchResultsFromApi.clear(); // Si borró todo, vaciamos la lista
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onReady() {
    super.onReady();
    _checkTokenBackground();
    getTopSellingProducts(); // Trae los productos más vendidos
    balanceController.fetchBalance();
  }

  Future<void> _checkTokenBackground() async {
    ResponseApi response = await usersProvider.checkToken();
    if (!response.success) {
      // Si el token es inválido, cerramos la sesión y lo mandamos al Login
      GetStorage().remove("user");
      Get.offNamedUntil('/login', (route) => false);
    }
  }

  // Cuando el usuario escribe, solo actualizamos la variable.
  // El "debounce" de arriba se encarga de llamar a la API automáticamente.
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  // ---> NUEVA FUNCIÓN: Busca en la base de datos real <---
  Future<void> searchProductsInBackend(String query) async {
    isSearchingApi.value = true;
    hasConnectionError.value = false; // Reiniciamos el error antes de buscar

    try {
      var response = await productsProvider.searchProducts(query: query);

      if (response.statusCode == 200) {
        searchResultsFromApi.assignAll(productFromJson(response.data));
      } else {
        // Si el backend tiró error 500, 404, etc.
        hasConnectionError.value = true;
      }
    } catch (e) {
      // Si falló por Timeout o no hay internet
      hasConnectionError.value = true;
    } finally {
      isSearchingApi.value = false;
    }
  }

  // ---> LOS GETTERS PARA LA VISTA <---
  // Sugerencias flotantes (Máximo 5)
  List<Product> get searchSuggestions {
    if (searchQuery.value.isEmpty || !isSearchFocused.value) return [];
    return searchResultsFromApi.take(5).toList();
  }

  // Grilla principal de abajo
  List<Product> get filteredProducts {
    // Si no está buscando, muestra los 10 iniciales del Home
    if (searchQuery.value.isEmpty) return productsFromApi;
    // Si buscó algo, muestra TODO lo que encontró la API
    return searchResultsFromApi;
  }

  void goToProductDetail(Product product) {
    searchQuery.value = '';
    searchController.clear();
    searchResultsFromApi.clear(); // Limpiamos para el próximo uso
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed("/product", arguments: product.id.toString());
  }

  RxBool isUpdatingProfile = false.obs;

  Future<void> updateProfile(Map<String, dynamic> newInfo) async {
    isUpdatingProfile.value = true;
    try {
      // 1. Mandar al backend
      final response = await usersProvider.updateUserInfo(newInfo);

      if (response.statusCode == 200 || response.statusCode == 202) {
        // 2. Actualizar el modelo localmente
        if (newInfo.containsKey('age'))
          userSession.age = int.parse(newInfo['age'].toString());
        if (newInfo.containsKey('curse_year'))
          userSession.curse_year = int.parse(newInfo['curse_year'].toString());
        if (newInfo.containsKey('curse_division'))
          userSession.curse_division = newInfo['curse_division'];
        if (newInfo.containsKey('turn')) userSession.turn = newInfo['turn'];

        // 3. Guardar en memoria (GetStorage)
        GetStorage().write("user", userSession.toJson());

        // 4. Refrescar la UI
        update(['profile_info']); // Actualiza los widgets envueltos con este ID

        Get.back(); // Cierra el BottomSheet
        CustomToast.showSuccess(
            title: "Perfil actualizado",
            message: "Tus datos se han actualizado correctamente");
      } else {
        CustomToast.showError(
            title: "Error", message: "No se pudo actualizar el perfil");
      }
    } catch (e) {
      logger.e("Error al actualizar perfil: $e");
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  RxBool isUpdatingEmail = false.obs;
  RxBool isUpdatingPassword = false.obs;

  Future<void> updateEmail(String newEmail) async {
    if (newEmail.isEmpty || !newEmail.contains('@')) {
      CustomToast.showError(title: "Error", message: "Ingresa un email válido");
      return;
    }

    isUpdatingEmail.value = true;
    try {
      final response = await usersProvider.updateEmail(newEmail);

      if (response.statusCode == 200 || response.statusCode == 202) {
        userSession.email = newEmail; // Actualizamos modelo local
        GetStorage().write("user", userSession.toJson()); // Guardamos
        update(['profile_info']); // Refrescamos la vista

        Get.back(); // Cerramos modal
        CustomToast.showSuccess(
            title: "Email actualizado",
            message: "Tu email se ha actualizado correctamente");
      } else {
        CustomToast.showError(
            title: "Error", message: "No se pudo actualizar el email");
      }
    } catch (e) {
      logger.e("Error al actualizar email: $e");
    } finally {
      isUpdatingEmail.value = false;
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    if (newPassword.length < 6) {
      CustomToast.showError(
          title: "Error",
          message: "La contraseña debe tener al menos 6 caracteres");
      return;
    }

    isUpdatingPassword.value = true;
    try {
      final response =
          await usersProvider.updatePassword(oldPassword, newPassword);

      if (response.statusCode == 200 || response.statusCode == 202) {
        Get.back(); // Cerramos modal
        CustomToast.showSuccess(
            title: "Contraseña actualizada",
            message: "Tu contraseña se ha actualizado de forma segura");
      } else {
        // En un caso real, el backend podría tirar un 401 si la contraseña vieja es incorrecta
        CustomToast.showError(
            title: "Error", message: "Verifica tu contraseña actual");
      }
    } catch (e) {
      logger.e("Error al actualizar contraseña: $e");
    } finally {
      isUpdatingPassword.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      // 1. Llamas a tu endpoint de Python (ej: DELETE /api/users/me)
      final response = await usersProvider.deleteMyAccount();

      if (response.statusCode == 204) {
        // 2. Borras todo rastro local
        GetStorage().erase();

        // 3. Lo mandas al login sin posibilidad de volver atrás
        Get.offAllNamed('/login');

        CustomToast.showSuccess(
            title: "Cuenta eliminada",
            message: "Tu cuenta ha sido eliminada correctamente");
      }
    } catch (e) {
      CustomToast.showError(
          title: "Error", message: "No se pudo eliminar la cuenta");
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
