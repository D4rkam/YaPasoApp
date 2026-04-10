import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:prueba_buffet/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prueba_buffet/features/auth/data/providers/auth_api_provider.dart';
import 'package:prueba_buffet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prueba_buffet/features/auth/domain/repositories/auth_repository.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/clear_session_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/login_use_case.dart';
import 'package:prueba_buffet/features/auth/domain/usecases/register_use_case.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_login_controller_v2.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_register_controller_v2.dart';
import 'package:prueba_buffet/features/auth/presentation/controllers/auth_security_gate_controller_v2.dart';

class AuthBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthApiProvider>(() => AuthApiProvider(), fenix: true);

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(Get.find<AuthApiProvider>()),
      fenix: true,
    );

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSource(GetStorage()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSource>(),
        Get.find<AuthLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<CheckSessionUseCase>(
      () => CheckSessionUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<ClearSessionUseCase>(
      () => ClearSessionUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<IsBiometricEnabledUseCase>(
      () => IsBiometricEnabledUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<GetSchoolsUseCase>(
      () => GetSchoolsUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<AuthLoginControllerV2>(
      () => AuthLoginControllerV2(Get.find<LoginUseCase>()),
    );
    Get.lazyPut<AuthRegisterControllerV2>(
      () => AuthRegisterControllerV2(
        Get.find<RegisterUseCase>(),
        Get.find<GetSchoolsUseCase>(),
      ),
    );
    Get.lazyPut<AuthSecurityGateControllerV2>(
      () => AuthSecurityGateControllerV2(
        Get.find<CheckSessionUseCase>(),
        Get.find<ClearSessionUseCase>(),
        Get.find<IsBiometricEnabledUseCase>(),
      ),
    );
  }
}
