// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class ProductsProvider extends BaseProvider {
  ProductsProvider() {
    print("--- Inicializando ProductsProvider (Hereda de BaseProvider) ---");
  }

  // --- MÉTODOS LIMPIOS ---

  Future<Response> getProducts() async {
    // Ya no necesitas pasar 'headers', el modifier de BaseProvider lo hace solo
    return await get(ApiUrl.PRODUCTS_GET);
  }

  Future<Response> getProductById(int id) async {
    return await get("${ApiUrl.PRODUCT_GET}$id");
  }

  Future<Response> getProductsByCategory(String category) async {
    return await get("${ApiUrl.PRODUCTS_GET}category/$category");
  }
}
