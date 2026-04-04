import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';
import 'package:prueba_buffet/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:prueba_buffet/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:prueba_buffet/features/profile/domain/repositories/profile_repository.dart';
import 'package:prueba_buffet/features/profile/presentation/controllers/profile_controller_v2.dart';

class ProfileBindingV2 implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UsersProvider>()) {
      Get.lazyPut<UsersProvider>(() => UsersProvider(), fenix: true);
    }

    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(Get.find<UsersProvider>()),
      fenix: true,
    );

    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()),
      fenix: true,
    );

    if (!Get.isRegistered<ProfileControllerV2>()) {
      Get.put<ProfileControllerV2>(
        ProfileControllerV2(repository: Get.find<ProfileRepository>()),
      );
    }
  }
}
