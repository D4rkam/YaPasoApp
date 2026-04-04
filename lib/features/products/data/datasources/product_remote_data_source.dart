import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';

class ProductRemoteDataSource {
  final ProductsProvider _productsProvider;

  ProductRemoteDataSource(this._productsProvider);

  Future<Product> getProductById(String id) async {
    final response = await _productsProvider.getProductById(id);
    return Product.fromJson(response.data);
  }
}
