// ignore_for_file: non_constant_identifier_names

import 'package:prueba_buffet/environment/enviroment.dart';

class ApiUrl {
  static String get _hostServer => Environment.apiUrl;

  static final String ROOT = "$_hostServer/";

  // ----- Authentication
  static final String REGISTER = "$_hostServer/api/auth/user"; // POST
  static final String LOGIN = "$_hostServer/api/auth/user/login"; // POST
  static final String LOGOUT = "$_hostServer/api/auth/logout"; // POST
  static final String REFRESH_TOKEN =
      "$_hostServer/api/auth/refresh-token"; // POST (Ajusta la ruta según tu API)

  // ----- User
  static final String USER = "$_hostServer/api/users/"; // GET
  static final String USER_UPDATE = "$_hostServer/api/users/me"; // PUT
  static final String USER_DELETE = "$_hostServer/api/users/me"; // DELETE
  static final String UPDATE_EMAIL = "$_hostServer/api/users/me/email"; // PUT
  static final String UPDATE_PASSWORD =
      "$_hostServer/api/users/me/password"; // PUT
  static final String REPORT = "$_hostServer/api/users/report-issue"; // POST

  // ----- Orders
  static final String ORDER = "$_hostServer/api/order/"; // GET - POST
  static final String ORDERS_USER = "$_hostServer/api/users/my-orders"; // GET

  // ----- Products
  static final String PRODUCT_GET = "$_hostServer/api/product/"; // GET
  static final String PRODUCTS_GET = "$_hostServer/api/product/"; // GET
  static final String PRODUCTS_CATEGORY_GET =
      "$_hostServer/api/product/"; // GET
  static final String PRODUCT_SEARCH =
      "$_hostServer/api/product/search/"; // GET
  static final String PRODUCT_TOP_SELLING =
      "$_hostServer/api/product/top-selling"; // GET

  static final String PAY = "$_hostServer/api/pay/"; // POST
  static final String PAY_BALANCE =
      "$_hostServer/api/pay/pay_with_balance"; // POST

  static final String BALANCE = "$_hostServer/api/users/balance"; // GET
  static final String LOAD_BALANCE =
      "$_hostServer/api/transactions/load-balance"; // POST
  static final String TRANSACTIONS =
      "$_hostServer/api/transactions/my-transactions"; // GET

  static final String SCHOOLS = "$_hostServer/api/schools/"; // GET
}
