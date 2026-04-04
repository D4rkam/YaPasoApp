import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/features/all_products/data/datasources/all_products_remote_data_source.dart';
import 'package:prueba_buffet/features/all_products/data/repositories/all_products_repository_impl.dart';
import 'package:prueba_buffet/features/all_products/domain/repositories/all_products_repository.dart';
import 'package:prueba_buffet/features/all_products/presentation/controllers/all_products_controller_v2.dart';

class AllProductsBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllProductsRemoteDataSource>(
      () => AllProductsRemoteDataSource(ProductsProvider()),
      fenix: true,
    );

    Get.lazyPut<AllProductsRepository>(
      () => AllProductsRepositoryImpl(
          Get.find<AllProductsRemoteDataSource>()),
      fenix: true,
    );

    Get.put<AllProductsControllerV2>(
      AllProductsControllerV2(
          repository: Get.find<AllProductsRepository>()),
    );
  }
}
