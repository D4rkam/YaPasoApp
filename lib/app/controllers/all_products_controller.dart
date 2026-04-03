import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_toast.dart';

class AllProductsController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final productProvider = ProductsProvider();

  // Estados observables
  RxList<ProductForCart> products = <ProductForCart>[].obs;
  var isLoading = true.obs; // Carga inicial
  var isFetchingMore = false.obs; // Carga al apretar el botón

  // Paginación por Cursor
  String? nextCursor;
  var hasMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  // 1. Carga inicial
  void fetchAllProducts() async {
    isLoading.value = true;
    hasMore.value = false;
    nextCursor = null;
    products.clear();

    final result = await productProvider.getProducts();

    if (result.statusCode == 200 && result.data != null) {
      final data = result.data;
      products.assignAll(data['products']
              ?.map<ProductForCart>((p) => ProductForCart.fromJson(p))
              .toList() ??
          <ProductForCart>[]);
      nextCursor = data['next_cursor'];
      hasMore.value = data['has_more'] ?? false;
    } else {
      CustomToast.showError(
          title: 'Error', message: "No se pudieron cargar los productos");
    }

    isLoading.value = false;
  }

  // 2. Carga Manual (Se llama desde el botón)
  void fetchMoreProducts() async {
    if (isFetchingMore.value || !hasMore.value || nextCursor == null) return;

    isFetchingMore.value = true;

    final result = await productProvider.getProducts(cursor: nextCursor);

    if (result.statusCode == 200 && result.data != null) {
      final data = result.data;
      final newProducts = data['products']
              ?.map<ProductForCart>((p) => ProductForCart.fromJson(p))
              .toList() ??
          <ProductForCart>[];

      products.addAll(newProducts);
      nextCursor = data['next_cursor'];
      hasMore.value = data['has_more'] ?? false;
    }

    isFetchingMore.value = false;
  }
}
