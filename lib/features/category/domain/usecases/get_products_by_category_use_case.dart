import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/category/domain/repositories/category_repository.dart';

class GetProductsByCategoryUseCase {
  final CategoryRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  Future<List<Product>> call(String category) =>
      _repository.getProductsByCategory(category);
}
