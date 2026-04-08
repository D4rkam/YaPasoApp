import 'package:get/get.dart';
import 'package:prueba_buffet/core/routes/routes.dart';

// V2 Imports
import 'package:prueba_buffet/features/shell/presentation/pages/main_shell_v2.dart';
import 'package:prueba_buffet/features/shell/presentation/bindings/main_shell_binding_v2.dart';
import 'package:prueba_buffet/features/startup/presentation/pages/intro_v2_page.dart';
import 'package:prueba_buffet/features/startup/presentation/pages/update_required_v2_page.dart';

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

import 'package:prueba_buffet/features/profile/presentation/bindings/profile_binding_v2.dart';
import 'package:prueba_buffet/features/profile/presentation/pages/profile_v2_content.dart';

import 'package:prueba_buffet/features/pay_state/presentation/bindings/pay_state_binding_v2.dart';
import 'package:prueba_buffet/features/pay_state/presentation/pages/success_v2_screen.dart';
import 'package:prueba_buffet/features/pay_state/presentation/pages/failure_v2_screen.dart';
import 'package:prueba_buffet/features/pay_state/presentation/pages/pending_v2_screen.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => IntroV2Page()),
    GetPage(
      name: Routes.SECURITY,
      page: () => const SecurityFingerV2Page(),
      binding: AuthBindingV2(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => MainShellV2(),
      binding: MainShellBindingV2(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginV2Page(),
      binding: AuthBindingV2(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterV2Page(),
      binding: AuthBindingV2(),
    ),
    GetPage(
      name: Routes.PRODUCT,
      page: () => ProductV2Page(),
      binding: ProductBindingV2(),
    ),
    GetPage(
      name: Routes.MY_BALANCE,
      page: () => MyBalanceV2Page(),
      binding: BalanceBindingV2(),
    ),
    GetPage(
      name: Routes.CATEGORY,
      page: () => const CategoryV2Page(),
      binding: CategoryBindingV2(),
    ),
    GetPage(
      name: Routes.PAY,
      page: () => const PayV2Page(),
      binding: PaymentsBindingV2(),
    ),
    GetPage(
      name: Routes.SHOPPING_CART,
      page: () => ShoppingCartV2Page(),
      binding: CartBindingV2(),
    ),
    GetPage(
      name: Routes.SUCCESS_PAY,
      page: () => SuccessV2Screen(),
      binding: PayStateBindingV2(),
    ),
    GetPage(
      name: Routes.FAILURE_PAY,
      page: () => FailureV2Screen(),
      binding: PayStateBindingV2(),
    ),
    GetPage(
      name: Routes.PENDING_PAY,
      page: () => PendingV2Screen(),
      binding: PayStateBindingV2(),
    ),
    GetPage(
      name: Routes.PERFIL,
      page: () => const ProfileV2Content(),
      binding: ProfileBindingV2(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => AllProductsV2Page(),
      binding: AllProductsBindingV2(),
    ),
    GetPage(
      name: Routes.UPDATE_REQUIRED,
      page: () => const UpdateRequiredV2Page(),
    ),
  ];
}
