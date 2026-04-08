import 'package:prueba_buffet/core/data/providers/products_provider.dart';
import 'package:prueba_buffet/core/models/product.dart';

class AllProductsRemoteDataSource {
  final ProductsProvider _productsProvider;

  AllProductsRemoteDataSource(this._productsProvider);

  /// Retorna un mapa con 'products', 'next_cursor' y 'has_more'
  Future<Map<String, dynamic>> getProducts({int limit = 10, String? cursor}) async {
    final response = await _productsProvider.getProducts(
      limit: limit,
      cursor: cursor,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      final products = data['products']
              ?.map<Product>((p) => Product.fromJson(p))
              .toList() ??
          <Product>[];

      return {
        'products': products,
        'next_cursor': data['next_cursor'],
        'has_more': data['has_more'] ?? false,
      };
    }

    return {
      'products': <Product>[],
      'next_cursor': null,
      'has_more': false,
    };
  }
}
