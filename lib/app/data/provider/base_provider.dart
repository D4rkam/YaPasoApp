import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class BaseProvider extends GetConnect {
  final GetStorage _storage = GetStorage();

  BaseProvider() {
    print("--- Inicializando BaseProvider ---");

    // Configuración básica
    timeout = const Duration(seconds: 30);

    // 1. INTERCEPTOR DE PETICIÓN (Request Modifier)
    // Se ejecuta ANTES de que cualquier petición salga al servidor
    httpClient.addRequestModifier<dynamic>((request) {
      final path = request.url.path;

      // Si es Login o Registro, NO enviamos cookies (flujo limpio)
      if (path.contains(ApiUrl.LOGIN) || path.contains(ApiUrl.REGISTER)) {
        print("HTTP [REQ] -> $path (Sin cookies por ser Auth)");
        return request;
      }

      final cookies = _storage.read("session_cookies");

      if (cookies != null) {
        request.headers['Cookie'] = cookies;
        print("HTTP [REQ] -> Enviando Cookie: $cookies");
      } else {
        print("HTTP [REQ] -> No hay cookies para enviar");
      }
      return request;
    });

    // 2. INTERCEPTOR DE RESPUESTA (Response Modifier)
    // Se ejecuta APENAS el servidor responde
    httpClient.addResponseModifier((request, response) async {
      print("HTTP [RES] -> Status: ${response.statusCode}");
      print("HTTP [RES] -> URL: ${request.url}");
      print("HTTP [RES] -> Body: ${response.bodyString}");

      // Manejo de expiración de token (401 Unauthorized)
      if (response.statusCode == 401 &&
          !request.url.path.contains(ApiUrl.REFRESH_TOKEN) &&
          !request.url.path.contains(ApiUrl.LOGIN)) {
        print("HTTP [RES] -> Token expirado. Intentando refrescar...");
        bool refreshed = await _refreshToken();

        if (refreshed) {
          print(
              "HTTP [RES] -> Token refrescado con éxito. Reintentando la petición original...");

          final newCookies = _storage.read("session_cookies");
          final newHeaders = Map<String, String>.from(request.headers);
          if (newCookies != null) {
            newHeaders['Cookie'] = newCookies;
          }

          // Leer el body de la request original si existe (consumiendo el Stream)
          dynamic requestBody;
          if (request.method.toUpperCase() != 'GET' && request.method.toUpperCase() != 'HEAD') {
             try {
               // bodyBytes es un Stream<List<int>>, lo leemos todo y lo aplanamos
               final bytesList = await request.bodyBytes.toList();
               if (bytesList.isNotEmpty) {
                 // Expandimos la lista de listas en una sola lista de bytes
                  requestBody = bytesList.expand((x) => x).toList();
               }
             } catch (e) {
               print("HTTP [RES] -> Error leyendo el body original: $e");
             }
          }

          // Realizamos la misma petición nuevamente
          var retryResponse = await requestConfig(
            request.method.toUpperCase(),
            request.url.toString(),
            body: requestBody,
            headers: newHeaders,
          );

          return retryResponse;
        } else {
          print(
              "HTTP [RES] -> No se pudo refrescar el token. Cerrando sesión...");
          logout();
          // Get.offAllNamed(Routes.LOGIN); // Descomenta e importa tus rutas cuando estés listo
        }
      }

      // Buscar 'set-cookie' de forma segura
      final rawCookie =
          response.headers?['set-cookie'] ?? response.headers?['Set-Cookie'];

      if (rawCookie != null && rawCookie.isNotEmpty) {
        List<String> cookieList = rawCookie.split(',');
        List<String> cleanedCookies = [];

        for (var cookie in cookieList) {
          String pair = cookie.split(';').first.trim();
          cleanedCookies.add(pair);
        }

        String cookieString = cleanedCookies.join('; ');
        _storage.write("session_cookies", cookieString);
        print("HTTP [RES] -> Cookies guardadas globalmente: $cookieString");
      }
      return response;
    });
  }

  // Método auxiliar para reintentos del interceptor
  Future<Response> requestConfig(
    String method,
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return await request(url, method, body: body, headers: headers);
  }

  // Lógica para refrescar el token (global)
  Future<bool> _refreshToken() async {
    print("Iniciando Refresh Token...");
    Response response = await post(ApiUrl.REFRESH_TOKEN, {});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    return false;
  }

  // Cerrar sesión
  void logout() {
    _storage.remove("session_cookies");
    _storage.remove("user");
    print("SesiÃ³n cerrada y cookies eliminadas globalmente.");
  }
}
