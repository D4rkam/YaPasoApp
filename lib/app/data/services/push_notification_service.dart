import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart'; // Importamos Dio
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/pages/main_shell/main_shell.dart';

import 'package:prueba_buffet/firebase_options.dart';
import 'package:prueba_buffet/app/data/provider/base_provider.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';
import 'package:prueba_buffet/utils/logger.dart'; // Ajustá la ruta de tu BaseProvider

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _getAndSaveToken();
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'pedidos_canal_alta',
        'Notificaciones de Pedidos',
        description:
            'Este canal se usa para avisar cuando el pedido está listo.',
        importance: Importance.max,
        playSound: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    //Este codigo maneja cuando la app está en segundo plano o cerrada y el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data['screen'] == 'orders') {
      logger.i("📲 Navegando a la pantalla de Pedidos por notificación.");
      if (Get.isRegistered<MainShellController>()) {
        Get.find<MainShellController>().goToOrdersTab();
      }
    } else {
      Get.lazyPut(() => MainShellController());
      Get.find<MainShellController>().goToOrdersTab();
    }
  }

  static Future<void> _getAndSaveToken() async {
    String? fcmToken;

    try {
      if (kIsWeb) {
        fcmToken = await _messaging.getToken(
            vapidKey:
                "BNojTEBqQbOWMAkVVLIQP94hMpamFoGTfi9X-xzrLCN2RFiBqDbW4z_-wqAR8-VTX2hdXdUIACqCdHl8ZB8Ytek");
      } else {
        fcmToken = await _messaging.getToken();
      }

      if (fcmToken != null) {
        logger.i("📱 Token FCM obtenido: $fcmToken");
        await _sendTokenToBackend(fcmToken);
      }

      _messaging.onTokenRefresh.listen((newToken) {
        _sendTokenToBackend(newToken);
      });
    } catch (e) {
      logger.e("❌ Error al obtener el token: $e");
    }
  }

  // --- LA CONEXIÓN CON TU FASTAPI USANDO DIO ---
  static Future<void> _sendTokenToBackend(String fcmToken) async {
    // 1. Instanciamos tu BaseProvider (ya trae los interceptores y cookies)
    final baseProvider = BaseProvider();

    // 2. Definimos la URL (Idealmente deberías usar tu ApiUrl si la tenés mapeada)
    final String url = ApiUrl.NOTIFICATIONS_DEVICE_TOKEN;

    try {
      // 3. Mandamos el POST.
      // ¡Magia! No pasamos headers de Auth. El interceptor de tu BaseProvider lo hace solo.
      final response = await baseProvider.dio.post(
        url,
        data: {
          'token': fcmToken,
          'platform': kIsWeb ? 'web' : 'android',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("✅ Celular/PC registrado en Ya Paso vía Dio.");
      } else {
        logger.w("⚠️ Error del backend al guardar token: ${response.data}");
      }
    } on DioException catch (e) {
      // Manejo de errores específico de Dio
      logger.e(
          "❌ Error de red al enviar token (Dio): ${e.response?.data ?? e.message}");
    } catch (e) {
      logger.e("❌ Error inesperado: $e");
    }
  }
}
