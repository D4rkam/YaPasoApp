import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/config/theme/app_theme.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/pages/home/home.dart';
import 'package:prueba_buffet/pages/intro/intro.dart';
import 'package:prueba_buffet/pages/login/login.dart';
import 'package:prueba_buffet/pages/my_balance/my_balance.dart';
import 'package:prueba_buffet/pages/order/order.dart';
import 'package:prueba_buffet/pages/pay/pay.dart';
import 'package:prueba_buffet/pages/pay_state/failure.dart';
import 'package:prueba_buffet/pages/pay_state/pending.dart';
import 'package:prueba_buffet/pages/pay_state/success.dart';
import 'package:prueba_buffet/pages/product/product.dart';
import 'package:prueba_buffet/pages/register/register.dart';
import 'package:prueba_buffet/pages/security/security_finger.dart';
import 'package:prueba_buffet/pages/shopping_cart/shopping_cart.dart';

User userSession = User.fromJson(GetStorage().read("user") ?? {});

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: false,
      title: 'Ya paso',
      initialRoute: userSession.id != null ? "/security" : "/",
      getPages: [
        GetPage(name: "/", page: () => IntroScreen()),
        GetPage(name: "/security", page: () => const SecurityFinger()),
        GetPage(
            name: "/login",
            page: () => LoginScreen(),
            transitionDuration: Duration.zero),
        GetPage(name: "/register", page: () => RegisterScreen()),
        GetPage(name: "/home", page: () => HomeScreen()),
        GetPage(name: "/my_balance", page: () => const MyBalance()),
        GetPage(name: "/product", page: () => ProductScreen()),
        GetPage(name: "/shopping_cart", page: () => ShoppingCartScreen()),
        GetPage(name: "/pay", page: () => const PayScreen()),
        GetPage(name: "/orders", page: () => const Order()),
        GetPage(name: "/success_pay", page: () => const SuccessScreen()),
        GetPage(name: "/failure_pay", page: () => const FailureScreen()),
        GetPage(name: "/pending_pay", page: () => const PendingScreen())
      ],
      navigatorKey: Get.key,
      theme: AppTheme(enableDarkMode: false).theme(),
    );
  }
}
