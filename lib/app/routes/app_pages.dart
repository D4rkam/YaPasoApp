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
import 'package:prueba_buffet/features/auth/presentation/bindings/auth_binding_v2.dart';
import 'package:prueba_buffet/features/auth/presentation/pages/login_v2_page.dart';
import 'package:prueba_buffet/features/auth/presentation/pages/register_v2_page.dart';
import 'package:prueba_buffet/features/auth/presentation/pages/security_finger_v2_page.dart';
import 'package:prueba_buffet/features/balance/presentation/bindings/balance_binding_v2.dart';
import 'package:prueba_buffet/features/balance/presentation/pages/my_balance_v2_page.dart';
import 'package:prueba_buffet/features/cart/presentation/bindings/cart_binding_v2.dart';
import 'package:prueba_buffet/features/cart/presentation/pages/shopping_cart_v2_page.dart';
import 'package:prueba_buffet/features/payments/presentation/bindings/payments_binding_v2.dart';
import 'package:prueba_buffet/features/payments/presentation/pages/pay_v2_page.dart';
import 'package:prueba_buffet/features/products/presentation/bindings/product_binding_v2.dart';
import 'package:prueba_buffet/features/products/presentation/pages/product_v2_page.dart';
import 'package:prueba_buffet/features/category/presentation/bindings/category_binding_v2.dart';
import 'package:prueba_buffet/features/category/presentation/pages/category_v2_page.dart';
import 'package:prueba_buffet/features/all_products/presentation/bindings/all_products_binding_v2.dart';
import 'package:prueba_buffet/features/all_products/presentation/pages/all_products_v2_page.dart';

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
      name: Routes.LOGIN_V2,
      page: () => const LoginV2Page(),
      binding: AuthBindingV2(),
    ),

    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.REGISTER_V2,
      page: () => const RegisterV2Page(),
      binding: AuthBindingV2(),
    ),
    GetPage(
      name: Routes.SECURITY_V2,
      page: () => const SecurityFingerV2Page(),
      binding: AuthBindingV2(),
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
    GetPage(
      name: Routes.MY_BALANCE_V2,
      page: () => MyBalanceV2Page(),
      binding: BalanceBindingV2(),
    ),
    // GetPage(
    //     name: Routes.CATEGORY,
    //     page: () => const CategoryScreen(),
    //     binding: CategoryBinding()),
    GetPage(name: Routes.PAY, page: () => const PayScreen()),
    GetPage(
      name: Routes.PAY_V2,
      page: () => const PayV2Page(),
      binding: PaymentsBindingV2(),
    ),
    // GetPage(name: Routes.ORDERS, page: () => Order(), binding: OrderBinding()),
    GetPage(name: Routes.SHOPPING_CART, page: () => ShoppingCartScreen()),
    GetPage(
      name: Routes.SHOPPING_CART_V2,
      page: () => ShoppingCartV2Page(),
      binding: CartBindingV2(),
    ),
    GetPage(
        name: Routes.SUCCESS_PAY,
        page: () => SuccessScreen(),
        binding: SuccessBinding()),
    GetPage(name: Routes.FAILURE_PAY, page: () => FailureScreen()),
    GetPage(name: Routes.PENDING_PAY, page: () => PendingScreen()),
    GetPage(name: Routes.PERFIL, page: () => const PerfilContent()),
    GetPage(name: Routes.PRODUCTS, page: () => AllProductsScreen()),
    GetPage(
      name: Routes.PRODUCTS_V2,
      page: () => AllProductsV2Page(),
      binding: AllProductsBindingV2(),
    ),
    GetPage(
      name: Routes.PRODUCT_V2,
      page: () => ProductV2Page(),
      binding: ProductBindingV2(),
    ),
    GetPage(
      name: Routes.CATEGORY_V2,
      page: () => const CategoryV2Page(),
      binding: CategoryBindingV2(),
    ),
    GetPage(
        name: Routes.UPDATE_REQUIRED, page: () => const UpdateRequiredView()),
  ];
}
