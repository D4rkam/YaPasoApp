// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart' show Response; // Importamos Dio
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

import 'package:prueba_buffet/utils/logger.dart';

class ProductsProvider extends BaseProvider {
  ProductsProvider() {
    logger.i("--- Inicializando ProductsProvider (Hereda de BaseProvider) ---");
  }

  Future<Response> getProducts({int limit = 10, String? cursor}) async {
    final queryMap = {
      "limit": limit.toString(),
      if (cursor != null) "cursor": cursor,
    };
    return await dio.get(
      ApiUrl.PRODUCTS_GET,
      queryParameters: queryMap,
    );
  }

  Future<Response> getProductById(String id) async {
    return await dio.get("${ApiUrl.PRODUCT_GET}$id");
  }

  Future<Response> getCategoriesWithStock() async {
    return await dio.get(ApiUrl.CATEGORIES_WITH_STOCK);
  }

  Future<Response> getProductsByCategory(String category,
      {int limit = 20, String? cursor}) async {
    final queryMap = {
      "limit": limit.toString(),
      if (cursor != null) "cursor": cursor,
    };
    return await dio.get(
      "${ApiUrl.PRODUCTS_GET}category/$category",
      queryParameters: queryMap,
    );
  }

  Future<Response> searchProducts({required String query}) async {
    Map<String, String> queryParams = {"query": query};
    return await dio.get(ApiUrl.PRODUCT_SEARCH, queryParameters: queryParams);
  }

  Future<Response> getTopSellingProducts(
      {int limit = 4, bool only_active = true}) async {
    return await dio.get(
      ApiUrl.PRODUCT_TOP_SELLING,
      queryParameters: {
        "limit": limit.toString(),
        "only_active": only_active.toString(),
      },
    );
  }
}
