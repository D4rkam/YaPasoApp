import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/products/domain/repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository _repository;

  GetProductByIdUseCase(this._repository);

  Future<Product> call(String id) => _repository.getProductById(id);
}
