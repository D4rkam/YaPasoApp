import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/features/all_products/data/datasources/all_products_remote_data_source.dart';
import 'package:prueba_buffet/features/all_products/domain/repositories/all_products_repository.dart';

class AllProductsRepositoryImpl implements AllProductsRepository {
  final AllProductsRemoteDataSource _remote;

  AllProductsRepositoryImpl(this._remote);

  @override
  Future<AllProductsPage> getProducts({int limit = 10, String? cursor}) async {
    final data = await _remote.getProducts(limit: limit, cursor: cursor);
    return AllProductsPage(
      products: data['products'] as List<ProductForCart>,
      nextCursor: data['next_cursor'] as String?,
      hasMore: data['has_more'] as bool,
    );
  }
}
