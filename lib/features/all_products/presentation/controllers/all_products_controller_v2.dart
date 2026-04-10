import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/core/presentation/widgets/custom_toast.dart';
import 'package:prueba_buffet/features/all_products/domain/repositories/all_products_repository.dart';
import 'package:prueba_buffet/features/all_products/domain/usecases/get_all_products_use_case.dart';

class AllProductsControllerV2 extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  late final GetAllProductsUseCase _getAllProducts;

  // Estados observables
  RxList<Product> products = <Product>[].obs;
  var isLoading = true.obs;
  var isFetchingMore = false.obs;

  // Paginación por Cursor
  String? nextCursor;
  var hasMore = false.obs;

  AllProductsControllerV2({required AllProductsRepository repository}) {
    _getAllProducts = GetAllProductsUseCase(repository);
  }

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

    try {
      final page = await _getAllProducts();
      products.assignAll(page.products);
      nextCursor = page.nextCursor;
      hasMore.value = page.hasMore;
    } catch (_) {
      CustomToast.showError(
          title: 'Error', message: "No se pudieron cargar los productos");
    }

    isLoading.value = false;
  }

  // 2. Carga Manual (Se llama desde el botón)
  void fetchMoreProducts() async {
    if (isFetchingMore.value || !hasMore.value || nextCursor == null) return;

    isFetchingMore.value = true;

    try {
      final page = await _getAllProducts(cursor: nextCursor);
      products.addAll(page.products);
      nextCursor = page.nextCursor;
      hasMore.value = page.hasMore;
    } catch (_) {
      // Silencioso en carga incremental
    }

    isFetchingMore.value = false;
  }
}
