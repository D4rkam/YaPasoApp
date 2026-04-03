import 'package:get/get.dart';
import 'package:prueba_buffet/app/bindings/balance_binding.dart';
import 'package:prueba_buffet/app/bindings/login_binding.dart';
import 'package:prueba_buffet/app/bindings/main_shell_binding.dart';
import 'package:prueba_buffet/app/bindings/product_binding.dart';
import 'package:prueba_buffet/app/bindings/register_binding.dart';
import 'package:prueba_buffet/app/bindings/success_binding.dart';
import 'package:prueba_buffet/app/ui/pages/all_products/all_products.dart';
import 'package:prueba_buffet/app/ui/pages/category/category.dart';
import 'package:prueba_buffet/app/ui/pages/main_shell/main_shell.dart';
import 'package:prueba_buffet/app/ui/pages/intro/intro.dart';
import 'package:prueba_buffet/app/ui/pages/login/login.dart';
import 'package:prueba_buffet/app/ui/pages/my_balance/my_balance.dart';
import 'package:prueba_buffet/app/ui/pages/pay/pay.dart';
import 'package:prueba_buffet/app/ui/pages/pay_state/failure.dart';
import 'package:prueba_buffet/app/ui/pages/pay_state/pending.dart';
import 'package:prueba_buffet/app/ui/pages/pay_state/success.dart';
import 'package:prueba_buffet/app/ui/pages/perfil/perfil.dart';
import 'package:prueba_buffet/app/ui/pages/product/product.dart';
import 'package:prueba_buffet/app/ui/pages/register/register.dart';
import 'package:prueba_buffet/app/ui/pages/security/security_finger.dart';
import 'package:prueba_buffet/app/ui/pages/shopping_cart/shopping_cart.dart';
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/app/ui/pages/update_required/update_required.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => IntroScreen()),
    GetPage(name: Routes.SECURITY, page: () => const SecurityFinger()),
    GetPage(
      name: Routes.HOME,
      page: () => MainShell(),
      binding: MainShellBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
        name: Routes.PRODUCT,
        page: () => ProductScreen(),
        binding: ProductBinding()),
    GetPage(
      name: Routes.MY_BALANCE,
      page: () => MyBalance(),
      binding: BalanceBinding(),
    ),
    // GetPage(
    //     name: Routes.CATEGORY,
    //     page: () => const CategoryScreen(),
    //     binding: CategoryBinding()),
    GetPage(name: Routes.PAY, page: () => const PayScreen()),
    // GetPage(name: Routes.ORDERS, page: () => Order(), binding: OrderBinding()),
    GetPage(name: Routes.SHOPPING_CART, page: () => ShoppingCartScreen()),
    GetPage(
        name: Routes.SUCCESS_PAY,
        page: () => SuccessScreen(),
        binding: SuccessBinding()),
    GetPage(name: Routes.FAILURE_PAY, page: () => FailureScreen()),
    GetPage(name: Routes.PENDING_PAY, page: () => PendingScreen()),
    GetPage(name: Routes.PERFIL, page: () => const PerfilContent()),
    GetPage(name: Routes.PRODUCTS, page: () => AllProductsScreen()),
    GetPage(
        name: Routes.UPDATE_REQUIRED, page: () => const UpdateRequiredView()),
  ];
}
