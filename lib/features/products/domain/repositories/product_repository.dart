import 'package:prueba_buffet/core/models/product.dart';

abstract class ProductRepository {
  Future<Product> getProductById(String id);
}
