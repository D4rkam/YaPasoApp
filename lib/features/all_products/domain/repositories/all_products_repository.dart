import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

/// Resultado de una petición paginada de productos.
class AllProductsPage {
  final List<ProductForCart> products;
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
