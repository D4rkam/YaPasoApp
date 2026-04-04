import 'package:prueba_buffet/app/data/models/product.dart';
import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';

class GetTopSellingProductsUseCase {
  final HomeRepository _repository;
  GetTopSellingProductsUseCase(this._repository);
  Future<List<Product>> call({int limit = 4}) =>
      _repository.getTopSellingProducts(limit: limit);
}
