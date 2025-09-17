import 'package:prueba_buffet/enviroment/enviroment.dart';

class ApiUrl {
  static const String _hostServer =
      "http://${Enviroment.HOST_API_SERVER}:${Enviroment.PORT_API_SERVER}";

  static const String ROOT = "$_hostServer/";

  // ----- Authentication
  static const String REGISTER = "$_hostServer/api/auth/user"; // POST
  static const String LOGIN = "$_hostServer/api/auth/user/login"; // POST

  // ----- User
  static const String USER = "$_hostServer/api/users/"; // GET

  // ----- Orders
  static const String ORDER = "$_hostServer/api/order/"; // GET - POST

  // ----- Products
  static const String PRODUCT_GET = "$_hostServer/api/product/"; // GET
  static const String PRODUCTS_GET = "$_hostServer/api/product/"; // GET
  static const String PRODUCTS_CATEGORY_GET =
      "$_hostServer/api/product/"; // GET

  static const String PAY = "$_hostServer/api/pay/"; // POST
}
