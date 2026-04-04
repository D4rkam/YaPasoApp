import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/products_provider.dart';
import 'package:prueba_buffet/features/category/data/datasources/category_remote_data_source.dart';
import 'package:prueba_buffet/features/category/data/repositories/category_repository_impl.dart';
import 'package:prueba_buffet/features/category/domain/repositories/category_repository.dart';
import 'package:prueba_buffet/features/category/presentation/controllers/category_controller_v2.dart';

class CategoryBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSource(ProductsProvider()),
      fenix: true,
    );

    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<CategoryRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<CategoryControllerV2>(
      () => CategoryControllerV2(repository: Get.find<CategoryRepository>()),
      fenix: true,
    );
  }
}
