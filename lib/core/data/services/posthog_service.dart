import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:prueba_buffet/environment/enviroment.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';

class PosthogService {
  static Future<void> init() async {
    final config = PostHogConfig(Environment.posthogApiKey)
      ..host = Environment.posthogHost
      ..debug = !kReleaseMode
      ..errorTrackingConfig.inAppByDefault = true
      ..captureApplicationLifecycleEvents = true
      ..sessionReplay = true;

    config.errorTrackingConfig.inAppIncludes.add('package:prueba_buffet');

    await Posthog().setup(config);
    _setupErrorHooks();
  }

  static void _setupErrorHooks() {
    // Captura global de errores de Flutter
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      Posthog().captureException(
        error: details.exception,
        stackTrace: details.stack,
        properties: {
          "current_screen": Get.currentRoute,
          'is_fatal': true,
        },
      );

      _tagUserWithDifficulty();
    };

    // Captura global de errores de la plataforma
    PlatformDispatcher.instance.onError = (error, stack) {
      Posthog().captureException(
        error: error,
        stackTrace: stack,
      );

      _tagUserWithDifficulty();
      return true;
    };
  }

  static void _tagUserWithDifficulty() {
    try {
      if (Get.isRegistered<AnalyticsRepository>()) {
        Get.find<AnalyticsRepository>().setPersonProperties({
          'encountered_app_crash': true,
          'last_crash_date': DateTime.now().toIso8601String(),
        });
      }
    } catch (_) {}
  }
}
