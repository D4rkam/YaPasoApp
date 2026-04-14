import 'package:prueba_buffet/core/models/user.dart';
import 'package:prueba_buffet/features/analytics/domain/repositories/analytics_repository.dart';

class IdentifyUseCases {
  final AnalyticsRepository _repository;

  IdentifyUseCases(this._repository);

  Future<void> identify(User user) async {
    return _repository.identify(
      userId: user.id.toString(),
      userProperties: {
        'name': user.name,
        'lastName': user.lastName,
        'email': user.email,
        'username': user.username,
        'age': user.age,
        'school_id': user.schoolId ?? 0,
        'file_num': user.fileNum,
        'curse_year': user.curse_year ?? 0,
        'curse_division': user.curse_division ?? 'N/A',
        'turn': user.turn ?? 'N/A',
        'current_balance': user.balance ?? 0.0,
        'has_balance': (user.balance ?? 0.0) > 0,
        'total_orders_count': user.orders?.length ?? 0,
        'is_identified': true,
      },
    );
  }
}
