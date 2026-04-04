import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/category/data/datasources/category_remote_data_source.dart';
import 'package:prueba_buffet/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remote;

  CategoryRepositoryImpl(this._remote);

  @override
  Future<List<Product>> getProductsByCategory(String category) {
    return _remote.getProductsByCategory(category);
  }
}
