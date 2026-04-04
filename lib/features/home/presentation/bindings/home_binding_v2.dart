import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/features/home/data/datasources/home_remote_data_source.dart';
import 'package:prueba_buffet/features/home/data/repositories/home_repository_impl.dart';
import 'package:prueba_buffet/features/home/domain/repositories/home_repository.dart';
import 'package:prueba_buffet/features/home/domain/usecases/check_version_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/get_top_selling_products_use_case.dart';
import 'package:prueba_buffet/features/home/domain/usecases/search_products_use_case.dart';
import 'package:prueba_buffet/features/home/presentation/controllers/home_controller_v2.dart';

class HomeBindingV2 implements Bindings {
  @override
  void dependencies() {
    // Registramos providers base
    if (!Get.isRegistered<UsersProvider>()) {
      Get.lazyPut<UsersProvider>(() => UsersProvider(), fenix: true);
    }
    if (!Get.isRegistered<ProductsProvider>()) {
      Get.lazyPut<ProductsProvider>(() => ProductsProvider(), fenix: true);
    }

    // Datasource
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSource(
        Get.find<ProductsProvider>(),
        Get.find<UsersProvider>(),
      ),
      fenix: true,
    );

    // Repositorio
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(Get.find<HomeRemoteDataSource>()),
      fenix: true,
    );

    // Casos de uso
    Get.lazyPut(() => GetTopSellingProductsUseCase(Get.find<HomeRepository>()),
        fenix: true);
    Get.lazyPut(() => GetCategoriesUseCase(Get.find<HomeRepository>()),
        fenix: true);
    Get.lazyPut(() => SearchProductsUseCase(Get.find<HomeRepository>()),
        fenix: true);
    Get.lazyPut(() => CheckVersionUseCase(Get.find<HomeRepository>()),
        fenix: true);

    // HomeControllerV2
    if (!Get.isRegistered<HomeControllerV2>()) {
      Get.put<HomeControllerV2>(
        HomeControllerV2(
          getTopSelling: Get.find<GetTopSellingProductsUseCase>(),
          getCategories: Get.find<GetCategoriesUseCase>(),
          searchProducts: Get.find<SearchProductsUseCase>(),
          checkVersion: Get.find<CheckVersionUseCase>(),
        ),
        permanent: true,
      );
    }
  }
}
