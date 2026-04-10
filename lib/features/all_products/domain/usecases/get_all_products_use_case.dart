import 'package:prueba_buffet/features/all_products/domain/repositories/all_products_repository.dart';

class GetAllProductsUseCase {
  final AllProductsRepository _repository;

  GetAllProductsUseCase(this._repository);

  Future<AllProductsPage> call({int limit = 10, String? cursor}) =>
      _repository.getProducts(limit: limit, cursor: cursor);
}
