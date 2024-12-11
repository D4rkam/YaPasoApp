import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/bindings/initial_binding.dart';
import 'package:prueba_buffet/app/routes/app_pages.dart';
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/app/ui/theme/app_theme.dart';
import 'package:prueba_buffet/app/data/models/user.dart';

User userSession = User.fromJson(GetStorage().read("user") ?? {});

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
      title: 'Ya paso',
      initialRoute: userSession.id != null ? Routes.SECURITY : Routes.INITIAL,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      theme: AppTheme(enableDarkMode: false).theme(),
    );
  }
}
