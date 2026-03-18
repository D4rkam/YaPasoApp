import 'package:prueba_buffet/environment/enviroment.dart';

class ApiUrl {
  static const String _hostServer =
      "http://${Enviroment.HOST_API_SERVER}:${Enviroment.PORT_API_SERVER}";
  // static const String _hostServer = "https://28gm4cfb-8000.brs.devtunnels.ms";

  static const String ROOT = "$_hostServer/";

  // ----- Authentication
  static const String REGISTER = "$_hostServer/api/auth/user"; // POST
  static const String LOGIN = "$_hostServer/api/auth/user/login"; // POST
  static const String LOGOUT = "$_hostServer/api/auth/logout"; // POST
  static const String REFRESH_TOKEN =
      "$_hostServer/api/auth/refresh-token"; // POST (Ajusta la ruta según tu API)

  // ----- User
  static const String USER = "$_hostServer/api/users/"; // GET
  static const String USER_UPDATE = "$_hostServer/api/users/me"; // PUT
  static const String USER_DELETE = "$_hostServer/api/users/me"; // DELETE
  static const String UPDATE_EMAIL = "$_hostServer/api/users/me/email"; // PUT
  static const String UPDATE_PASSWORD =
      "$_hostServer/api/users/me/password"; // PUT
  static const String REPORT = "$_hostServer/api/users/report-issue"; // POST

  // ----- Orders
  static const String ORDER = "$_hostServer/api/order/"; // GET - POST
  static const String ORDERS_USER = "$_hostServer/api/users/my-orders"; // GET

  // ----- Products
  static const String PRODUCT_GET = "$_hostServer/api/product/"; // GET
  static const String PRODUCTS_GET = "$_hostServer/api/product/"; // GET
  static const String PRODUCTS_CATEGORY_GET =
      "$_hostServer/api/product/"; // GET
  static const String PRODUCT_SEARCH =
      "$_hostServer/api/product/search/"; // GET
  static const String PRODUCT_TOP_SELLING =
      "$_hostServer/api/product/top-selling"; // GET

  static const String PAY = "$_hostServer/api/pay/"; // POST
  static const String PAY_BALANCE =
      "$_hostServer/api/pay/pay_with_balance"; // POST

  static const String BALANCE = "$_hostServer/api/users/balance"; // GET
  static const String LOAD_BALANCE =
      "$_hostServer/api/transactions/load-balance"; // POST
  static const String TRANSACTIONS =
      "$_hostServer/api/transactions/my-transactions"; // GET

  static const String SCHOOLS = "$_hostServer/api/schools/"; // GET
}
