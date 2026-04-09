import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_buffet/core/data/providers/users_provider.dart';
import 'package:prueba_buffet/core/models/category.dart';
import 'package:prueba_buffet/core/models/product.dart';
import 'package:prueba_buffet/features/balance/presentation/controllers/balance_controller_v2.dart';
import 'package:prueba_buffet/features/home/domain/usecases/check_version_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_top_selling_products_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/search_products_use_case.dart';
import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';

class MockGetTopSellingProductsUseCase extends Mock implements GetTopSellingProductsUseCase {}
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}
class MockCheckVersionUseCase extends Mock implements CheckVersionUseCase {}
class MockUsersProvider extends Mock implements UsersProvider {}
class MockBalanceControllerV2 extends Mock implements BalanceControllerV2 {}

void main() {
  late HomeControllerV2 controller;
  late MockGetTopSellingProductsUseCase mockGetTopSelling;
  late MockGetCategoriesUseCase mockGetCategories;
  late MockSearchProductsUseCase mockSearchProducts;
  late MockCheckVersionUseCase mockCheckVersion;
  late MockUsersProvider mockUsersProvider;
  late MockBalanceControllerV2 mockBalanceController;

  setUp(() {
    mockGetTopSelling = MockGetTopSellingProductsUseCase();
    mockGetCategories = MockGetCategoriesUseCase();
    mockSearchProducts = MockSearchProductsUseCase();
    mockCheckVersion = MockCheckVersionUseCase();
    mockUsersProvider = MockUsersProvider();
    mockBalanceController = MockBalanceControllerV2();

    // Register dependencies in Get
    Get.put<UsersProvider>(mockUsersProvider);
    // Stub GetX lifecycle callbacks for Mock
    when(() => mockBalanceController.onStart).thenReturn(InternalFinalCallback<void>(callback: () {}));
    when(() => mockBalanceController.onDelete).thenReturn(InternalFinalCallback<void>(callback: () {}));

    // Mock balance controller behavior (required because used in getter)
    when(() => mockBalanceController.balance).thenReturn(1000.0.obs);
    when(() => mockBalanceController.fetchBalance()).thenAnswer((_) async {});

    Get.put<BalanceControllerV2>(mockBalanceController);

    controller = HomeControllerV2(
      getTopSelling: mockGetTopSelling,
      getCategories: mockGetCategories,
      searchProducts: mockSearchProducts,
      checkVersion: mockCheckVersion,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeControllerV2 Tests', () {
    test('initial state should be correct', () {
      expect(controller.isInitialLoading.value, true);
      expect(controller.isLoadingCategories.value, true);
      expect(controller.productsFromApi, isEmpty);
      expect(controller.listaCategorias, isEmpty);
    });

    test('fetchCategorias should update listaCategorias when successful', () async {
      // arrange
      final categories = [
        Category(id: 1, nombre: 'Bebidas', orden: 1, activa: true, tieneStock: true),
      ];
      when(() => mockGetCategories()).thenAnswer((_) async => categories);

      // act
      await controller.fetchCategorias();

      // assert
      expect(controller.listaCategorias.length, 1);
      expect(controller.listaCategorias.first.nombre, 'Bebidas');
      expect(controller.isLoadingCategories.value, false);
      verify(() => mockGetCategories()).called(1);
    });

    test('getTopSellingProducts should update productsFromApi when successful', () async {
      // arrange
      final products = [
        Product(
          id: 1,
          name: 'Coca Cola',
          description: 'Desc',
          price: 1500,
          imageUrl: '',
          quantity: 10,
          category: 'Bebidas',
          sellerId: 1,
        ),
      ];
      when(() => mockGetTopSelling()).thenAnswer((_) async => products);

      // act
      await controller.getTopSellingProducts();

      // assert
      expect(controller.productsFromApi.length, 1);
      expect(controller.productsFromApi.first.name, 'Coca Cola');
      expect(controller.isInitialLoading.value, false);
      verify(() => mockGetTopSelling()).called(1);
    });

    test('searchProductsInBackend should update searchResultsFromApi when successful', () async {
      // arrange
      final query = 'Coca';
      final results = [
        Product(
          id: 1,
          name: 'Coca Cola',
          description: 'Desc',
          price: 1500,
          imageUrl: '',
          quantity: 10,
          category: 'Bebidas',
          sellerId: 1,
        ),
      ];
      when(() => mockSearchProducts(query)).thenAnswer((_) async => results);

      // act
      await controller.searchProductsInBackend(query);

      // assert
      expect(controller.searchResultsFromApi.length, 1);
      expect(controller.searchResultsFromApi.first.name, 'Coca Cola');
      expect(controller.isSearchingApi.value, false);
      verify(() => mockSearchProducts(query)).called(1);
    });

    test('searchSuggestions should return limited results when searching', () {
      // arrange
      controller.isSearchFocused.value = true;
      controller.searchQuery.value = 'a';
      controller.searchResultsFromApi.assignAll(List.generate(10, (i) => Product(
        id: i, name: 'P$i', description: '', price: 0, imageUrl: '', quantity: 1, category: '', sellerId: 1,
      )));

      // act
      final suggestions = controller.searchSuggestions;

      // assert
      expect(suggestions.length, 5);
    });
   group('searchProductsInBackend Error handling', () {
      test('should set hasConnectionError to true on exception', () async {
        // arrange
        when(() => mockSearchProducts(any())).thenThrow(Exception('Error'));

        // act
        await controller.searchProductsInBackend('test');

        // assert
        expect(controller.hasConnectionError.value, true);
        expect(controller.isSearchingApi.value, false);
      });
    });
  });
}
