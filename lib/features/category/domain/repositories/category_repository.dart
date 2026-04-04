import 'package:prueba_buffet/core/models/product.dart';

abstract class CategoryRepository {
  Future<List<Product>> getProductsByCategory(String category);
}
