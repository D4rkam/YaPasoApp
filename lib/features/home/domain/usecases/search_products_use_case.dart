import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';

class SearchProductsUseCase {
  final HomeRepository _repository;
  SearchProductsUseCase(this._repository);
  Future<List<Product>> call(String query) => _repository.searchProducts(query);
}
