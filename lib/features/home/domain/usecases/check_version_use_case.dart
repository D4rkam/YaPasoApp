import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';

class CheckVersionUseCase {
  final HomeRepository _repository;
  CheckVersionUseCase(this._repository);
  Future<Map<String, dynamic>> call() => _repository.checkVersion();
}
