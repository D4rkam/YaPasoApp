import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/products/data/datasources/product_remote_data_source.dart';
import 'package:prueba_buffet/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;

  ProductRepositoryImpl(this._remote);

  @override
  Future<Product> getProductById(String id) {
    return _remote.getProductById(id);
  }
}
