import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';

class CategoryRemoteDataSource {
  final ProductsProvider _productsProvider;

  CategoryRemoteDataSource(this._productsProvider);

  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _productsProvider
        .getProductsByCategory(category.toLowerCase());
    if (response.statusCode == 200) {
      return productFromJson(response.data["products"]);
    }
    return [];
  }
}
