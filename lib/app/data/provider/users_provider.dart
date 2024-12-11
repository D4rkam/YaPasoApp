import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/response_api.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/app/ui/pages/order/order.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class ProductForOrder {
  ProductForOrder({
    required this.id,
  });

  final int id;

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  // Crear una instancia desde JSON
  factory ProductForOrder.fromJson(Map<String, dynamic> json) {
    return ProductForOrder(
      id: json['id'],
    );
  }
}

class Order {
  Order({
    required this.user_id,
    required this.seller_id,
    required this.products,
    required this.datetime,
  });

  final int user_id;
  final int seller_id;
  final List<ProductForOrder> products;
  final String datetime;

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'seller_id': seller_id,
      'products': products.map((product) => product.toJson()).toList(),
      'datetime_order': datetime, // Cambiar clave al formato esperado
    };
  }

  // Crear una instancia desde JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    List<ProductForOrder> products = (json['products'] as List)
        .map((e) => ProductForOrder.fromJson(e))
        .toList();
    return Order(
      user_id: json['user_id'],
      seller_id: json['seller_id'],
      products: products,
      datetime: json['datetime_order'],
    );
  }
}

class UsersProvider extends GetConnect {
  String urlCreate = ApiUrl.REGISTER;
  String urlLogin = ApiUrl.LOGIN;
  String urlUser = ApiUrl.USER;
  String urlOrder = ApiUrl.ORDER;

  User userSession = User.fromJson(GetStorage().read("user") ?? {});

  Future<Response> create(User user) async {
    Response response = await post(
      urlCreate,
      user.toJson(),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<ResponseApi> login(String username, String password) async {
    Response response = await post(
      urlLogin,
      headers: {
        "Content-Type": "application/json",
      },
      {
        "username": username,
        "password": password,
      },
    );

    if (response.body == null) {
      Get.snackbar("Error", "No se pudo ejecutar la peticion");
      return ResponseApi(success: false);
    }
    ResponseApi responseApi = ResponseApi.fromJson(
      response.body,
      response.statusCode == 200,
    );
    return responseApi;
  }

  Future<ResponseApi> checkToken() async {
    Response response = await get(
      urlUser,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userSession.token?["access_token"]}"
      },
    );
    if (response.body == null) {
      return ResponseApi(success: false);
    }
    ResponseApi responseApi =
        ResponseApi.fromJson(response.body, response.isOk);

    return responseApi;
  }

  Future<Response> createOrder(Map<String, dynamic> orderJson) async {
    Response response = await post(
        urlOrder,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userSession.token?["access_token"]}"
        },
        orderJson);
    return response;
  }
}
