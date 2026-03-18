import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/bindings/initial_binding.dart';
import 'package:prueba_buffet/app/routes/app_pages.dart';
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/app/ui/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';

late User userSession;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  userSession = User.safeFromStorage();
  runApp(const MyApp());
}

String _resolveInitialRoute() {
  if (userSession.id != null) {
    // 1. Leemos la preferencia guardada en Configuración
    bool useBiometrics = GetStorage().read<bool>('useBiometrics') ?? false;

    // 2. Si la tiene activada, vamos a la pantalla de huella
    if (useBiometrics) {
      return Routes.SECURITY;
    }
    // 3. Si no la activó, entramos directo al Home
    else {
      return Routes.HOME;
    }
  }
  // Si no hay sesión (ID nulo), va al Login a poner usuario y contraseña
  return Routes.INITIAL;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Tamaño base de diseño (ej. iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          enableLog: true,
          defaultTransition: Transition.fade,
          debugShowCheckedModeBanner: false,
          title: 'Ya paso',
          initialRoute: _resolveInitialRoute(),
          getPages: AppPages.pages,
          initialBinding: InitialBinding(),
          navigatorKey: Get.key,
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
            // 1. Verificamos si estamos en la Web
            if (kIsWeb) {
              double screenWidth = MediaQuery.of(context).size.width;
              // 2. Si es más ancho que un celular (600px), mostramos el mensaje
              if (screenWidth > 600) {
                return _pantallaPC();
              }
            }

            // 3. Si es celular (o web en ventana chica), dejamos pasar a ScreenUtil
            // (Envolvemos tu widget con MediaQuery para que ScreenUtil funcione bien)
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }

  Widget _pantallaPC() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phonelink_erase_rounded,
              size: 100,
              color: Color(0xFFFFE500),
            ),
            const SizedBox(height: 30),
            const Text(
              "¡Ups! Pantalla muy grande",
              style: TextStyle(
                fontSize: 35,
                fontFamily: "Lobster", // Usamos tu fuente
                color: Color(0xFF3F3F3F),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Ya Paso está diseñada exclusivamente para tu celular.\n\nAchicá la ventana de tu navegador para simular un teléfono,\no ingresá directamente desde tu dispositivo móvil.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
