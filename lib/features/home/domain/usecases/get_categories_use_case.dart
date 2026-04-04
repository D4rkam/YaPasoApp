import 'package:prueba_buffet/app/data/models/category.dart';
import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository _repository;
  GetCategoriesUseCase(this._repository);
  Future<List<Category>> call() => _repository.getCategoriesWithStock();
}
