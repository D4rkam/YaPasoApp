import 'package:flutter/foundation.dart';
import 'package:prueba_buffet/utils/logger.dart';

class Environment {
  Environment._();
  // 1. Tu servidor local para cuando estás programando
  static const String _devUrl = "http://192.168.1.38:8000";

  // 2. Tu servidor real en producción (Reemplazá esto por la URL de tu FastAPI en la nube)
  static const String _prodUrl = "https://api.yapaso.app";

  // 3. El Getter inteligente que decide qué URL usar
  static String get apiUrl {
    logger.i("🌐 URL ACTUAL: ${kReleaseMode ? "PRODUCCIÓN" : "DESARROLLO"}");
    if (kReleaseMode) {
      return _prodUrl; // Usa esta cuando compiles para Azure o la Play Store
    } else {
      return _devUrl; // Usa esta cuando estés programando en VS Code
    }
  }
}
