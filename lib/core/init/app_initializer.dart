import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/core/data/services/auth_service.dart';
import 'package:prueba_buffet/core/data/services/posthog_service.dart';
import 'package:prueba_buffet/core/data/services/push_notification_service.dart';
import 'package:prueba_buffet/features/analytics/data/datasources/posthog_datasource.dart';
import 'package:prueba_buffet/features/analytics/data/repositories/posthog_analytics_repository_impl.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:prueba_buffet/features/analytics/domain/usecases/identify_use_cases.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Analítica y Errores
    await PosthogService.init();

    // 2. Almacenamiento local
    await GetStorage.init();

    // 3. Registro de Repositorios Globales (Singletons)
    // Usamos Get.put para que estén disponibles antes de que se cree el primer binding
    Get.put<AnalyticsRepository>(
      PosthogAnalyticsRepositoryImpl(PosthogDatasource()),
      permanent: true,
    );

    // 4. Servicio de Autenticación (Reactive Session)
    final authService = await Get.putAsync(() => AuthService().init());

    // 5. Lógica de inicio de sesión (Push Notifications e Analytics)
    if (authService.isAuthenticated) {
      PushNotificationService.initializeApp();
      
      final user = authService.user!;
      if (user.id != null) {
        await IdentifyUseCases(Get.find<AnalyticsRepository>()).identify(user);
      }
    }
  }
}
