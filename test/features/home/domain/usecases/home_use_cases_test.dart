import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/core/models/category.dart';
import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_top_selling_products_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/search_products_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/check_version_use_case.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetTopSellingProductsUseCase getTopSelling;
  late GetCategoriesUseCase getCategories;
  late SearchProductsUseCase searchProducts;
  late CheckVersionUseCase checkVersion;

  setUp(() {
    mockRepository = MockHomeRepository();
    getTopSelling = GetTopSellingProductsUseCase(mockRepository);
    getCategories = GetCategoriesUseCase(mockRepository);
    searchProducts = SearchProductsUseCase(mockRepository);
    checkVersion = CheckVersionUseCase(mockRepository);
  });

  group('Home Use Cases Tests', () {
    test('GetTopSellingProductsUseCase should return products', () async {
      // arrange
      final products = <Product>[];
      when(() => mockRepository.getTopSellingProducts(limit: 4))
          .thenAnswer((_) async => products);

      // act
      final result = await getTopSelling();

      // assert
      expect(result, products);
      verify(() => mockRepository.getTopSellingProducts(limit: 4)).called(1);
    });

    test('GetCategoriesUseCase should return categories', () async {
      // arrange
      final categories = <Category>[];
      when(() => mockRepository.getCategoriesWithStock())
          .thenAnswer((_) async => categories);

      // act
      final result = await getCategories();

      // assert
      expect(result, categories);
      verify(() => mockRepository.getCategoriesWithStock()).called(1);
    });

    test('SearchProductsUseCase should return search results', () async {
      // arrange
      final products = <Product>[];
      when(() => mockRepository.searchProducts('query'))
          .thenAnswer((_) async => products);

      // act
      final result = await searchProducts('query');

      // assert
      expect(result, products);
      verify(() => mockRepository.searchProducts('query')).called(1);
    });

    test('CheckVersionUseCase should return version data', () async {
      // arrange
      final data = {'latest_version': '1.0.0'};
      when(() => mockRepository.checkVersion()).thenAnswer((_) async => data);

      // act
      final result = await checkVersion();

      // assert
      expect(result, data);
      verify(() => mockRepository.checkVersion()).called(1);
    });
  });
}
