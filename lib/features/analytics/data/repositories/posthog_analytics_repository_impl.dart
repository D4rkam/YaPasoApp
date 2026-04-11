import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';
import '../datasources/posthog_datasource.dart';

class PosthogAnalyticsRepositoryImpl implements AnalyticsRepository {
  final PosthogDatasource _dataSource;

  PosthogAnalyticsRepositoryImpl(this._dataSource);

  @override
  Future<void> capture({
    required String eventName,
    Map<String, Object>? properties,
  }) async {
    return _dataSource.capture(eventName: eventName, properties: properties);
  }

  @override
  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    return _dataSource.identify(userId: userId, userProperties: userProperties);
  }

  @override
  Future<void> screen({
    required String screenName,
    Map<String, Object>? properties,
  }) async {
    return _dataSource.screen(screenName: screenName, properties: properties);
  }

  @override
  Future<void> captureException({
    required dynamic exception,
    StackTrace? stackTrace,
    Map<String, Object>? properties,
  }) async {
    return _dataSource.captureException(
      exception: exception,
      stackTrace: stackTrace,
      properties: properties,
    );
  }

  @override
  Future<void> reset() async {
    return _dataSource.reset();
  }
}
