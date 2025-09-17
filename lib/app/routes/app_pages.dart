import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/bindings/category_binding.dart';
import 'package:prueba_buffet/app/bindings/home_binding.dart';
import 'package:prueba_buffet/app/bindings/login_binding.dart';
import 'package:prueba_buffet/app/bindings/product_binding.dart';
import 'package:prueba_buffet/app/bindings/register_binding.dart';
import 'package:prueba_buffet/app/ui/pages/category/category.dart';
import 'package:prueba_buffet/app/ui/pages/home/home.dart';
import 'package:prueba_buffet/app/ui/pages/intro/intro.dart';
import 'package:prueba_buffet/app/ui/pages/login/login.dart';
import 'package:prueba_buffet/app/ui/pages/order/order.dart';
import 'package:prueba_buffet/app/ui/pages/pay/pay.dart';
import 'package:prueba_buffet/app/ui/pages/pay_state/failure.dart';
import 'package:prueba_buffet/app/ui/pages/pay_state/pending.dart';
import 'package:prueba_buffet/app/ui/pages/pay_state/success/success.dart';
import 'package:prueba_buffet/app/ui/pages/product/product.dart';
import 'package:prueba_buffet/app/ui/pages/register/register.dart';
import 'package:prueba_buffet/app/ui/pages/security/security_finger.dart';
import 'package:prueba_buffet/app/ui/pages/shopping_cart/shopping_cart.dart';
import 'package:prueba_buffet/app/routes/routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => IntroScreen()),
    GetPage(name: Routes.SECURITY, page: () => const SecurityFinger()),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
        name: Routes.PRODUCT,
        page: () => const ProductScreen(),
        binding: ProductBinding()),
    GetPage(
        name: Routes.CATEGORY,
        page: () => const CategoryScreen(),
        binding: CategoryBinding()),
    GetPage(name: Routes.PAY, page: () => const PayScreen()),
    GetPage(name: Routes.ORDERS, page: () => Order()),
    GetPage(name: Routes.SHOPPING_CART, page: () => ShoppingCartScreen()),
    GetPage(name: Routes.SUCCESS_PAY, page: () => SuccessScreen()),
    GetPage(name: Routes.FAILURE_PAY, page: () => const FailureScreen()),
    GetPage(name: Routes.SUCCESS_PAY, page: () => const PendingScreen()),
  ];
}
