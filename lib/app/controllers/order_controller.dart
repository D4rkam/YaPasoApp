import 'package:get/get.dart';
import 'package:prueba_buffet/app/data/provider/users_provider.dart';

class OrderController extends GetxController {
  final UsersProvider usersProvider = Get.find();
  RxList orders = [].obs;
  final formattedDateTime = "".obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List allOrders = [];
    try {
      isLoading.value = true;
      print('[OrderController] Obteniendo pedidos...');

      final response = await usersProvider.getOrders();

      print('[OrderController] Status: ${response.statusCode}');
      print('[OrderController] Body: ${response.bodyString}');

      if (response.isOk &&
          response.body != null &&
          response.body["orders"] is List) {
        allOrders = List<Map<String, dynamic>>.from(response.body["orders"]);
        orders.value =
            allOrders.where((order) => order['status'] == 'ENCARGADO').toList();
        print('[OrderController] Pedidos encargados: ${orders.length}');
      } else {
        print('[OrderController] Error o lista vacía');
        orders.clear();
      }
    } catch (e) {
      print('[OrderController] Excepción: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
