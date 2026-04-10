import 'package:prueba_buffet/core/data/providers/products_provider.dart';
import 'package:prueba_buffet/core/models/product.dart';

class CategoryRemoteDataSource {
  final ProductsProvider _productsProvider;

  CategoryRemoteDataSource(this._productsProvider);

  Future<List<Product>> getProductsByCategory(String category) async {
    final response =
        await _productsProvider.getProductsByCategory(category.toLowerCase());
    if (response.statusCode == 200) {
      return productFromJson(response.data["products"]);
    }
    return [];
  }
}
