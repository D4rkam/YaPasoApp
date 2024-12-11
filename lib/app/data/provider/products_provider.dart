import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/app/data/models/user.dart';
import 'package:prueba_buffet/utils/constants/api_constants.dart';

class ProductsProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read("user") ?? {});

  Future<Response> getProducts() async {
    String url = ApiUrl.PRODUCTS_GET;
    Response response = await get(
      url,
      headers: {
        "Authorization": "Bearer ${userSession.token?["access_token"]}"
      },
    );
    return response;
  }

  Future<Response> getProductById(int id) async {
    String url = "${ApiUrl.PRODUCT_GET}$id";
    Response response = await get(
      url,
      headers: {
        "Authorization": "Bearer ${userSession.token?["access_token"]}"
      },
    );
    return response;
  }

  Future<Response> getProductsByCategory(String category) async {
    String url = "${ApiUrl.PRODUCTS_GET}category/$category";
    Response response = await get(
      url,
      headers: {
        "Authorization": "Bearer ${userSession.token?["access_token"]}"
      },
    );
    return response;
  }
}
