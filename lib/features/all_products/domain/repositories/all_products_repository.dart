import 'package:prueba_buffet/core/models/product.dart';

/// Resultado de una petición paginada de productos.
class AllProductsPage {
  final List<Product> products;
  final String? nextCursor;
  final bool hasMore;

  const AllProductsPage({
    required this.products,
    this.nextCursor,
    this.hasMore = false,
  });
}

abstract class AllProductsRepository {
  Future<AllProductsPage> getProducts({int limit, String? cursor});
}
