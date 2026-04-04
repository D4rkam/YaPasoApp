import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class HomeRemoteDataSource {
  final ProductsProvider _productsProvider;
  final UsersProvider _usersProvider;

  HomeRemoteDataSource(this._productsProvider, this._usersProvider);

  Future<dynamic> getTopSellingProducts({int limit = 4}) async {
    return await _productsProvider.getTopSellingProducts(limit: limit);
  }

  Future<dynamic> getCategoriesWithStock() async {
    return await _productsProvider.getCategoriesWithStock();
  }

  Future<dynamic> searchProducts(String query) async {
    return await _productsProvider.searchProducts(query: query);
  }

  Future<dynamic> checkVersion() async {
    return await _usersProvider.checkVersion();
  }
}
