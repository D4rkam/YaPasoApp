import 'package:prueba_buffet/app/data/models/category.dart';
import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/features/home/data/datasources/home_remote_data_source.dart';
import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;

  HomeRepositoryImpl(this._remote);

  @override
  Future<List<Product>> getTopSellingProducts({int limit = 4}) async {
    final response = await _remote.getTopSellingProducts(limit: limit);
    if (response.statusCode == 200) {
      return productFromJson(response.data);
    }
    throw Exception("Error fetching top selling products");
  }

  @override
  Future<List<Category>> getCategoriesWithStock() async {
    final response = await _remote.getCategoriesWithStock();
    if (response.statusCode == 200) {
      return categoryFromJson(response.data);
    }
    throw Exception("Error fetching categories");
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final response = await _remote.searchProducts(query);
    if (response.statusCode == 200) {
      return productFromJson(response.data);
    }
    throw Exception("Error searching products");
  }

  @override
  Future<Map<String, dynamic>> checkVersion() async {
    final response = await _remote.checkVersion();
    if (response.statusCode == 200 && response.data != null) {
      return Map<String, dynamic>.from(response.data);
    }
    throw Exception("Error checking version");
  }
}
