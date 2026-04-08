import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';

import 'package:prueba_buffet/features/cart/presentation/controllers/shopping_cart_controller_v2.dart';
import 'package:prueba_buffet/core/models/category.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/core/data/providers/users_provider.dart';
import 'package:prueba_buffet/core/presentation/widgets/update_dialog.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/features/home/domain/usecases/check_version_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_top_selling_products_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/search_products_use_case.dart';
import 'package:prueba_buffet/utils/helpers/version_herlper.dart';
import 'package:prueba_buffet/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeControllerV2 extends GetxController {
  late final GetTopSellingProductsUseCase _getTopSelling;
  late final GetCategoriesUseCase _getCategories;
  late final SearchProductsUseCase _searchProducts;
  late final CheckVersionUseCase _checkVersion;

  final UsersProvider _usersProvider = Get.find<UsersProvider>();

  HomeControllerV2({
    required GetTopSellingProductsUseCase getTopSelling,
    required GetCategoriesUseCase getCategories,
    required SearchProductsUseCase searchProducts,
    required CheckVersionUseCase checkVersion,
  }) {
    _getTopSelling = getTopSelling;
    _getCategories = getCategories;
    _searchProducts = searchProducts;
    _checkVersion = checkVersion;
  }

  BalanceControllerV2 get balanceController => Get.find<BalanceControllerV2>();
  Rx<double> get balanceUser => balanceController.balance;

  RxBool isSearchingApi = false.obs;
  RxBool hasConnectionError = false.obs;
  RxBool isInitialLoading = true.obs;

  var productsFromApi = <Product>[].obs;
  RxList<Category> listaCategorias = <Category>[].obs;
  RxBool isLoadingCategories = true.obs;

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

    debounce(searchQuery, (String query) {
      if (query.trim().isNotEmpty) {
        searchProductsInBackend(query);
      } else {
        searchResultsFromApi.clear();
      }
    }, time: const Duration(milliseconds: 500));
    _checkSoftUpdate();
  }

  @override
  void onReady() {
    super.onReady();
    _checkTokenBackground();
    getTopSellingProducts();
    balanceController.fetchBalance();
    fetchCategorias();
  }

  Future<void> fetchCategorias() async {
    isLoadingCategories.value = true;
    try {
      final categories = await _getCategories();
      listaCategorias.assignAll(categories);
    } catch (e) {
      logger.e("Error cargando categorias: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> getTopSellingProducts() async {
    isInitialLoading.value = true;
    hasConnectionError.value = false;

    try {
      final products = await _getTopSelling();
      productsFromApi.assignAll(products);
    } catch (e) {
      hasConnectionError.value = true;
      logger.e("Error cargando top selling: $e");
    } finally {
      isInitialLoading.value = false;
    }
  }

  Future<void> searchProductsInBackend(String query) async {
    isSearchingApi.value = true;
    hasConnectionError.value = false;

    try {
      final results = await _searchProducts(query);
      searchResultsFromApi.assignAll(results);
    } catch (e) {
      hasConnectionError.value = true;
      logger.e("Error buscando productos: $e");
    } finally {
      isSearchingApi.value = false;
    }
  }

  Future<void> refreshHome() async {
    await Future.wait([
      getTopSellingProducts(),
      balanceController.fetchBalance(),
      fetchCategorias(),
    ]);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void retryFetch() {
    if (searchQuery.value.trim().isNotEmpty) {
      searchProductsInBackend(searchQuery.value);
    } else {
      getTopSellingProducts();
    }
  }

  List<Product> get searchSuggestions {
    if (searchQuery.value.isEmpty || !isSearchFocused.value) return [];
    return searchResultsFromApi.take(5).toList();
  }

  List<Product> get filteredProducts {
    if (searchQuery.value.isEmpty) return productsFromApi;
    return searchResultsFromApi;
  }

  Future<void> _checkSoftUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final data = await _checkVersion();
      String latestVersion = data['latest_version'];
      String updateMessage = data['update_message'];

      if (isUpdateAvailable(currentVersion, latestVersion)) {
        final box = GetStorage();
        String today = DateTime.now().toString().substring(0, 10);
        String lastPrompt = box.read('last_update_prompt') ?? '';

        if (lastPrompt != today) {
          _showUpdateDialog(updateMessage);
          box.write('last_update_prompt', today);
        }
      }
    } catch (e) {
      logger.e("Error buscando updates: $e");
    }
  }

  void _showUpdateDialog(String mensaje) {
    Get.dialog(
      UpdateDialogWidget(
        mensaje: mensaje,
        onConfirm: () {
          Get.back();
          _launchStore();
        },
        onCancel: () {
          Get.back();
        },
      ),
    );
  }

  Future<void> _launchStore() async {
    final Uri url = Uri.parse('https://yapaso.app');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'No se pudo abrir el navegador');
    }
  }

  Future<void> _checkTokenBackground() async {
    final response = await _usersProvider.checkToken();
    if (!response.success) {
      GetStorage().remove("user");
      Get.offNamedUntil('/login', (route) => false);
    }
  }

  void signOut() {
    if (Get.isRegistered<ShoppingCartControllerV2>()) {
      Get.delete<ShoppingCartControllerV2>();
    }
    GetStorage().remove("user"); // Borramos localStorage
    _usersProvider.logout(); // Llamamos logout
    Get.offNamedUntil("/login", (route) => false);
  }

  void goToMyBalance() {
    Get.toNamed(Routes.MY_BALANCE);
  }

  void goToProductDetail(Product product) {
    searchQuery.value = '';
    searchController.clear();
    searchResultsFromApi.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    Get.toNamed(
      Routes.PRODUCT,
      arguments: product.id.toString(),
    );
  }

  void goToAllProducts() {
    Get.toNamed(Routes.PRODUCTS);
  }

  void goToCategory(Category category) {
    if (category.tieneStock) {
      Get.toNamed(Routes.CATEGORY, arguments: category.nombre);
    }
  }

  // Este getter es para la foto de perfil en el drawer
  User get userSession => User.safeFromStorage();

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
