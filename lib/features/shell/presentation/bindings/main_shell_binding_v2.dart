import 'package:get/get.dart';
import 'package:prueba_buffet/core/data/providers/users_provider.dart';
import 'package:prueba_buffet/core/presentation/bindings/app_binding_v2.dart';
import 'package:prueba_buffet/features/category/presentation/bindings/category_binding_v2.dart';
import 'package:prueba_buffet/features/home/presentation/bindings/home_binding_v2.dart';
import 'package:prueba_buffet/features/shell/presentation/controllers/main_shell_controller_v2.dart';
import 'package:prueba_buffet/features/all_products/presentation/bindings/all_products_binding_v2.dart';
import 'package:prueba_buffet/features/profile/presentation/bindings/profile_binding_v2.dart';

class MainShellBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.put<MainShellControllerV2>(MainShellControllerV2());
    Get.lazyPut<UsersProvider>(() => UsersProvider(), fenix: true);

    // Inyectamos las dependencias globales necesarias para la Shell (Balance, Cart, etc)
    AppBindingV2().dependencies();
    HomeBindingV2().dependencies();
    AllProductsBindingV2().dependencies();
    ProfileBindingV2().dependencies();
    CategoryBindingV2().dependencies();
  }
}
