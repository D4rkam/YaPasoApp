import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:prueba_buffet/utils/logger.dart';

class PosthogDatasource {
  final Posthog _posthog = Posthog();

  Future<void> capture({
    required String eventName,
    Map<String, Object>? properties,
  }) async {
    try {
      await _posthog.capture(
        eventName: eventName,
        properties: properties,
      );
    } catch (e, stack) {
      logger.e('Error capturing Posthog event: $eventName',
          error: e, stackTrace: stack);
    }
  }

  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    try {
      await _posthog.identify(
        userId: userId,
        userProperties: userProperties,
      );
    } catch (e, stack) {
      logger.e('Error identifying user in Posthog: $userId',
          error: e, stackTrace: stack);
    }
  }

  Future<void> screen({
    required String screenName,
    Map<String, Object>? properties,
  }) async {
    try {
      await _posthog.screen(
        screenName: screenName,
        properties: properties,
      );
    } catch (e, stack) {
      logger.e('Error tracking Posthog screen: $screenName',
          error: e, stackTrace: stack);
    }
  }

  Future<void> captureException({
    required dynamic exception,
    StackTrace? stackTrace,
    Map<String, Object>? properties,
  }) async {
    try {
      await _posthog.captureException(
        error: exception,
        stackTrace: stackTrace,
        properties: properties,
      );
    } catch (e, stack) {
      logger.e('Error capturing Posthog exception',
          error: e, stackTrace: stack);
    }
  }

  Future<void> setPersonProperties(Map<String, Object> properties) async {
    try {
      await _posthog.setPersonProperties(userPropertiesToSetOnce: properties);
    } catch (e, stack) {
      logger.e('Error setting Posthog person properties',
          error: e, stackTrace: stack);
    }
  }

  Future<void> reset() async {
    try {
      await _posthog.reset();
    } catch (e, stack) {
      logger.e('Error resetting Posthog session', error: e, stackTrace: stack);
    }
  }
}
