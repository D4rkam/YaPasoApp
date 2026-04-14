import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:prueba_buffet/core/init/app_initializer.dart';
import 'package:prueba_buffet/core/data/services/auth_service.dart';
import 'package:prueba_buffet/core/presentation/theme/app_theme.dart';
import 'package:prueba_buffet/core/presentation/widgets/web_responsive_wrapper.dart';
import 'package:prueba_buffet/core/routes/app_pages.dart';

void main() async {
  await AppInitializer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return PostHogWidget(
          child: GetMaterialApp(
            enableLog: true,
            defaultTransition: Transition.fade,
            debugShowCheckedModeBanner: false,
            title: 'Ya paso',
            initialRoute: authService.resolveInitialRoute(),
            getPages: AppPages.pages,
            initialBinding: authService.resolveInitialBinding(),
            navigatorKey: Get.key,
            navigatorObservers: [PosthogObserver()],
            theme: AppTheme(enableDarkMode: false).theme(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale("es", ""),
              Locale("en", ""),
            ],
            locale: const Locale("es", ""),
            builder: (context, widget) {
              return WebResponsiveWrapper(child: widget!);
            },
          ),
        );
      },
    );
  }
}
