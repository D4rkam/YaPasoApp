import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prueba_buffet/providers/users_provider.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  final UsersProvider usersProvider = UsersProvider();
  final RxList<Order> orders = <Order>[].obs;
  final formattedDateTime = "".obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    Map<String, dynamic> order = GetStorage().read("order") ?? {};
    if (order.isEmpty) {
      return;
    }
    DateTime dateTime = DateTime.parse(order["datetime_order"]);
    formattedDateTime.value = DateFormat("dd-MM-yyyy").format(dateTime);
    formattedDateTime.refresh();
    print(formattedDateTime.value);
  }
}
