import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/config/theme/app_theme.dart';
import 'package:prueba_buffet/models/user.dart';
import 'package:prueba_buffet/pages/home/home.dart';
import 'package:prueba_buffet/pages/intro/intro.dart';
import 'package:prueba_buffet/pages/login/login.dart';
import 'package:prueba_buffet/pages/register/register.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Ya paso',
      initialRoute: userSession.id != null ? "/home" : "/",
      getPages: [
        GetPage(name: "/", page: () => IntroScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/register", page: () => RegisterScreen()),
        GetPage(name: "/home", page: () => HomeScreen()),
      ],
      navigatorKey: Get.key,
      theme: AppTheme(enableDarkMode: false).theme(),
    );
  }
}
