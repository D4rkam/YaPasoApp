import 'package:dio/dio.dart'
    show Dio, BaseOptions, InterceptorsWrapper, DioException, Response;
import 'package:dio/browser.dart' if (dart.library.io) 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart' hide Response; // <--- AGREGADO PARA EL REDIRECT
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart'; // <--- AGREGADO PARA LA VERSIÓN
import 'package:prueba_buffet/app/routes/app_pages.dart'; // <--- AGREGADO PARA LA RUTA (Ajustá el import si es distinto)
import 'package:prueba_buffet/app/routes/routes.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';
import 'package:prueba_buffet/utils/logger.dart';

class BaseProvider {
  final GetStorage _storage = GetStorage();
  late Dio dio;

  // 👇 VARIABLE CACHEADA PARA LA VERSIÓN 👇
  static String? _cachedVersion;

  BaseProvider() {
    logger.i("--- Inicializando BaseProvider (DIO) ---");

    dio = Dio(BaseOptions(
      // baseUrl: 'http://192.168.1.39:8000',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // INYECCIÓN PARA LA WEB
    if (kIsWeb) {
      try {
        final adapter = dio.httpClientAdapter as dynamic;
        adapter.withCredentials = true;
      } catch (_) {}
    }

    dio.interceptors.add(InterceptorsWrapper(
      // 1. INYECTAR COOKIES Y VERSIONES
      // 👇 Convertimos onRequest en async para poder leer packageInfo 👇
      onRequest: (options, handler) async {
        // --- MAGIA DE VERSIONES MULTIPLATAFORMA ---
        if (_cachedVersion == null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          _cachedVersion = packageInfo.version; // Ej: "2.0.0"
        }

        options.headers['x-client-type'] = kIsWeb ? 'web' : 'mobile';
        options.headers['x-app-version'] = _cachedVersion!;
        // ------------------------------------------

        if (kIsWeb ||
            options.path.contains(ApiUrl.LOGIN) ||
            options.path.contains(ApiUrl.REGISTER)) {
          return handler.next(options);
        }

        final accessToken = _storage.read("access_token_user");
        final refreshToken = _storage.read("refresh_token");

        List<String> cookies = [];
        if (accessToken != null && accessToken.toString().isNotEmpty)
          cookies.add(accessToken);
        if (refreshToken != null && refreshToken.toString().isNotEmpty)
          cookies.add(refreshToken);

        if (cookies.isNotEmpty) {
          options.headers['cookie'] = cookies.join('; ');
          logger.i("🚀 ENVIANDO HEADERS: ${options.headers['cookie']}");
        } else {
          logger.w("❌ NO HAY COOKIES PARA ENVIAR. EL REQUEST VA DESNUDO.");
        }

        return handler.next(options);
      },

      // 2. ATRAPAR COOKIES NUEVAS
      onResponse: (response, handler) {
        _guardarCookies(response);
        return handler.next(response);
      },

      // 3. MANEJAR EL 401, EL REFRESH Y EL 426
      onError: (DioException e, handler) async {
        if (e.response != null) _guardarCookies(e.response!);

        // 👇 LA GUILLOTINA DEL 426 (UPGRADE REQUIRED) 👇
        if (e.response?.statusCode == 426) {
          logger.w("🚨 VERSIÓN OBSOLETA: Forzando actualización obligatoria.");
          Get.offAllNamed(Routes.UPDATE_REQUIRED);
          return handler.next(
              e); // Dejamos que el error fluya pero ya cambiamos la pantalla
        }
        // 👆 ----------------------------------------- 👆

        if (e.response?.statusCode == 401) {
          // Freno de mano para evitar bucle infinito
          if (e.requestOptions.extra['isRetry'] == true) {
            logout();
            return handler.next(e);
          }

          if (!e.requestOptions.path.contains(ApiUrl.REFRESH_TOKEN) &&
              !e.requestOptions.path.contains(ApiUrl.LOGIN)) {
            bool refreshed = await _refreshToken();

            if (refreshed) {
              e.requestOptions.extra['isRetry'] = true;

              if (!kIsWeb) {
                final newAccess = _storage.read("access_token_user");
                final newRefresh = _storage.read("refresh_token");
                List<String> newCookies = [];
                if (newAccess != null) newCookies.add(newAccess);
                if (newRefresh != null) newCookies.add(newRefresh);
                if (newCookies.isNotEmpty) {
                  e.requestOptions.headers['Cookie'] = newCookies.join('; ');
                }
              }

              try {
                final retryResponse = await dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              } catch (retryError) {
                return handler.reject(retryError as DioException);
              }
            } else {
              logout();
              return handler.reject(e);
            }
          }
        }
        return handler.next(e);
      },
    ));
  }

  // --- EXTRACTOR AGRESIVO DE COOKIES ---
  void _guardarCookies(Response response) {
    List<String> setCookies = [];

    response.headers.forEach((name, values) {
      if (name.toLowerCase() == 'set-cookie') setCookies.addAll(values);
    });

    if (setCookies.isEmpty &&
        response.requestOptions.path.contains(ApiUrl.LOGIN)) {
      logger.w(
          "⚠️ ALERTA LOGIN: FastAPI respondió 200 pero NO envió cabeceras 'set-cookie'.");
    }

    for (var cookie in setCookies) {
      String nameValue = cookie.split(';').first.trim();
      if (nameValue.toLowerCase().startsWith('session_token_user=')) {
        _storage.write("access_token_user", nameValue);
      } else if (nameValue.toLowerCase().startsWith('refresh_token=')) {
        _storage.write("refresh_token", nameValue);
      }
    }
  }

  // --- REFRESH TOKEN ---
  Future<bool> _refreshToken() async {
    try {
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

      if (kIsWeb) {
        try {
          final adapter = refreshDio.httpClientAdapter as dynamic;
          adapter.withCredentials = true;
        } catch (_) {}
      } else {
        final accessToken = _storage.read("access_token_user");
        final refreshToken = _storage.read("refresh_token");
        List<String> cookies = [];
        if (accessToken != null) cookies.add(accessToken);
        if (refreshToken != null) cookies.add(refreshToken);
        if (cookies.isNotEmpty) {
          refreshDio.options.headers['Cookie'] = cookies.join('; ');
        }
      }

      Response response = await refreshDio.post(ApiUrl.REFRESH_TOKEN);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _guardarCookies(response);

        if (response.data is Map) {
          if (response.data['access_token'] != null) {
            _storage.write("access_token_user",
                "access_token_user=${response.data['access_token']}");
          }
          if (response.data['refresh_token'] != null) {
            _storage.write("refresh_token",
                "refresh_token=${response.data['refresh_token']}");
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _storage.remove("access_token_user");
    _storage.remove("refresh_token");
    _storage.remove("user");
    logger.i("Sesión cerrada y cookies destruidas.");
  }
}
