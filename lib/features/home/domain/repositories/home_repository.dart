import 'package:prueba_buffet/app/data/models/category.dart';
import 'package:prueba_buffet/app/data/models/product.dart';

abstract class HomeRepository {
  Future<List<Product>> getTopSellingProducts({int limit = 4});
  Future<List<Category>> getCategoriesWithStock();
  Future<List<Product>> searchProducts(String query);
  Future<Map<String, dynamic>> checkVersion();
}
