import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/models/category.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';
import 'package:prueba_buffet/app/ui/global_widgets/update_dialog.dart';
import 'package:prueba_buffet/utils/helpers/version_herlper.dart';

import 'package:prueba_buffet/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  ProductsProvider productsProvider = ProductsProvider();
  UsersProvider usersProvider = UsersProvider();
  User userSession = User.safeFromStorage();

  /// Saldo: referencia directa al BalanceController (fuente única de verdad)
  BalanceController get balanceController => Get.find<BalanceController>();
  Rx<double> get balanceUser => balanceController.balance;

  RxBool isSearchingApi = false.obs;
  RxBool hasConnectionError = false.obs;
  RxBool isInitialLoading = true.obs;

  var productsFromApi = <Product>[].obs;
  RxList<Category> listaCategorias = <Category>[].obs;
  RxBool isLoadingCategories = true.obs;

  Future<void> fetchCategorias() async {
    isLoadingCategories.value = true;
    try {
      var response = await productsProvider.getCategoriesWithStock();
      if (response.statusCode == 200) {
        listaCategorias.assignAll(categoryFromJson(response.data));
      }
    } catch (e) {
      logger.e("Error cargando categorias: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void signOut() {
    if (Get.isRegistered<ShoppingCartController>()) {
      Get.delete<ShoppingCartController>();
    }
    GetStorage().remove("user");
    usersProvider.logout();
    Get.offNamedUntil("/login", (route) => false);
  }

  void goToMyBalance() {
    final enableBalanceV2 =
        GetStorage().read<bool>('enable_balance_v2') ?? false;
    if (enableBalanceV2) {
      Get.toNamed(Routes.MY_BALANCE_V2);
      return;
    }

    Get.find<MainShellController>().goToBalance();
  }

  void goToProduct() {
    final enableProductsV2 =
        GetStorage().read<bool>('enable_products_v2') ?? false;
    Get.toNamed(
      enableProductsV2 ? Routes.PRODUCT_V2 : "/product",
    );
  }

  void goToAllProducts() {
    final enableAllProductsV2 =
        GetStorage().read<bool>('enable_all_products_v2') ?? false;
    Get.toNamed(
      enableAllProductsV2 ? Routes.PRODUCTS_V2 : "/products",
    );
  }

  void goToShoppingCart() {
    final enableCartV2 = GetStorage().read<bool>('enable_cart_v2') ?? false;
    Get.toNamed(enableCartV2 ? Routes.SHOPPING_CART_V2 : Routes.SHOPPING_CART);
  }

  void goToCategory(Category category) {
    if (category.tieneStock) {
      final enableCategoryV2 =
          GetStorage().read<bool>('enable_category_v2') ?? false;
      if (enableCategoryV2) {
        Get.toNamed(Routes.CATEGORY_V2, arguments: category.nombre);
      } else {
        Get.find<MainShellController>().goToCategory(category.nombre);
      }
    }
  }

  void goToPay() {
    final enablePaymentsV2 =
        GetStorage().read<bool>('enable_payments_v2') ?? false;
    Get.toNamed(enablePaymentsV2 ? Routes.PAY_V2 : Routes.PAY);
  }

  Future<void> getProducts() async {
    var response = await productsProvider.getProducts();

    if (response.statusCode == 200) {
      productsFromApi.assignAll(productFromJson(response.data["products"]));
      productsFromApi.refresh();
    }
  }

  Future<void> getTopSellingProducts() async {
    isInitialLoading.value = true;
    hasConnectionError.value = false;

    try {
      var response = await productsProvider.getTopSellingProducts();

      if (response.statusCode == 200) {
        productsFromApi.assignAll(productFromJson(response.data));
      } else {
        hasConnectionError.value = true;
      }
    } catch (e) {
      hasConnectionError.value = true;
      logger.e("Error cargando top selling: $e");
    } finally {
      isInitialLoading.value = false;
    }
  }

  /// Pull-to-refresh: refresca productos y saldo en paralelo.
  Future<void> refreshHome() async {
    await Future.wait([
      getTopSellingProducts(),
      balanceController.fetchBalance(),
      fetchCategorias(),
    ]);
  }

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxBool isSearchFocused = false.obs;

  var searchQuery = ''.obs;

  var searchResultsFromApi = <Product>[].obs;

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
    _checkSoftUpdate();
  }

  @override
  void onReady() {
    super.onReady();
    _checkTokenBackground();
    getTopSellingProducts(); // Trae los productos más vendidos
    balanceController.fetchBalance();
    fetchCategorias();
  }

  Future<void> _checkSoftUpdate() async {
    try {
      // 1. Obtenemos nuestra versión actual instalada
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // 2. Le pegamos a la API (Reemplazá 'dio' por cómo llames a tu cliente HTTP)
      // Nota: Esta petición NO debe tener el interceptor que tira error 426
      final response = await usersProvider.checkVersion();

      String latestVersion = response.data['latest_version'];
      String updateMessage = response.data['update_message'];

      // 3. Verificamos si la versión de la API es mayor
      if (isUpdateAvailable(currentVersion, latestVersion)) {
        // 4. Regla de UX: No ser pesados. Revisamos si ya le avisamos hoy.
        final box = GetStorage();
        String today =
            DateTime.now().toString().substring(0, 10); // Ej: 2026-03-23
        String lastPrompt = box.read('last_update_prompt') ?? '';

        if (lastPrompt != today) {
          // Si no le avisamos hoy, mostramos el cartelito
          _showUpdateDialog(updateMessage);

          // Anotamos en la libreta que ya lo fastidiamos por hoy
          box.write('last_update_prompt', today);
        }
      }
    } catch (e) {
      // Si el servidor falla o no hay internet, ignoramos el error silenciosamente.
      // El alumno vino a comprar comida, no a debuguear.
      print("Error buscando actualizaciones opcionales: $e");
    }
  }

  void _showUpdateDialog(String mensaje) {
    Get.dialog(
      UpdateDialogWidget(
        mensaje: mensaje,
        onConfirm: () {
          Get.back(); // Cerramos el popup
          _launchStore(); // Ejecutamos la función de abrir URL
        },
        onCancel: () {
          Get.back(); // Solo cerramos
        },
      ),
      // barrierDismissible: false, // Opcional: si querés evitar que lo cierren tocando afuera
    );
  }

  Future<void> _launchStore() async {
    final Uri url = Uri.parse('https://yapaso.app');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'No se pudo abrir el navegador');
    }
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
    hasConnectionError.value = false;

    try {
      var response = await productsProvider.searchProducts(query: query);

      if (response.statusCode == 200) {
        searchResultsFromApi.assignAll(productFromJson(response.data));
      } else {
        hasConnectionError.value = true;
      }
    } catch (e) {
      hasConnectionError.value = true;
      logger.e("Error buscando productos: $e");
    } finally {
      isSearchingApi.value = false;
    }
  }

  void retryFetch() {
    // Si estaba buscando algo, reintenta la búsqueda.
    // Si el input está vacío, reintenta cargar el Home inicial.
    if (searchQuery.value.trim().isNotEmpty) {
      searchProductsInBackend(searchQuery.value);
    } else {
      getTopSellingProducts();
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
    final enableProductsV2 =
        GetStorage().read<bool>('enable_products_v2') ?? false;
    Get.toNamed(
      enableProductsV2 ? Routes.PRODUCT_V2 : "/product",
      arguments: product.id.toString(),
    );
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
