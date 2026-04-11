import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:prueba_buffet/core/presentation/bindings/app_binding_v2.dart';
import 'package:prueba_buffet/core/presentation/theme/app_theme.dart';
import 'package:prueba_buffet/core/data/services/push_notification_service.dart';
import 'package:prueba_buffet/core/routes/app_pages.dart';
import 'package:prueba_buffet/core/routes/routes.dart';
import 'package:prueba_buffet/features/auth/presentation/bindings/auth_binding_v2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prueba_buffet/core/models/user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:prueba_buffet/environment/enviroment.dart';
import 'package:prueba_buffet/features/analytics/data/datasources/posthog_datasource.dart';
import 'package:prueba_buffet/features/analytics/data/repositories/posthog_analytics_repository_impl.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';

late User userSession;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar PostHog con configuración de reporte de errores
  await _initPostHog();

  // Registrar AnalyticsRepository para que esté disponible desde el inicio
  Get.put<AnalyticsRepository>(
    PosthogAnalyticsRepositoryImpl(PosthogDatasource()),
    permanent: true,
  );

  await GetStorage.init();
  userSession = User.safeFromStorage();

  if (userSession.token != null) {
    PushNotificationService.initializeApp();

    // Identificar al usuario en PostHog si tiene sesión
    if (userSession.id != null) {
      Get.find<AnalyticsRepository>().identify(
        userId: userSession.id.toString(),
        userProperties: {
          'email': userSession.email,
          'name': userSession.name,
        },
      );
    }
  }

  runApp(const MyApp());
}

Future<void> _initPostHog() async {
  final config = PostHogConfig(Environment.posthogApiKey)
    ..host = Environment.posthogHost
    ..debug = !kReleaseMode
    ..errorTrackingConfig.inAppByDefault = true;

  // Asegura que los frames del stack trace se identifiquen como código de la app
  config.errorTrackingConfig.inAppIncludes.add('package:prueba_buffet');

  await Posthog().setup(config);

  // Captura global de errores de Flutter
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Posthog().captureException(
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Captura global de errores de la plataforma (Isolates, etc)
  PlatformDispatcher.instance.onError = (error, stack) {
    Posthog().captureException(
      error: error,
      stackTrace: stack,
    );
    return true; // Retorna true para que el error no se propague más allá
  };
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

Bindings? _resolveInitialBinding() {
  if (userSession.id != null) {
    // Si hay sesión, inyectamos todas las dependencias principales (Home, Perfil, etc)
    return AppBindingV2();
  }

  return AuthBindingV2();
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
          initialBinding: _resolveInitialBinding(),
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
