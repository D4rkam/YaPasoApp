import 'package:get/get.dart';
import 'package:prueba_buffet/providers/pay_provider.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class Product {
  final int id;
  final String name;
  final String imagePath;
  final int price;
  final RxInt quantity;

  Product({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });
}

class ShoppingCartController extends GetxController {
  PayProvider payProvider = PayProvider();

  // Lista de productos en el carrito con datos ficticios
  var cartItems = <Product>[
    Product(
      id: 1,
      name: 'Medialuna',
      imagePath: ProjectImages.bebidaIcon,
      price: 500,
      quantity: 2.obs,
    ),
    Product(
      id: 2,
      name: 'Lata de Pepsi',
      imagePath: ProjectImages.bebidaIcon,
      price: 650,
      quantity: 1.obs,
    ),
    Product(
      id: 3,
      name: 'Café',
      imagePath: ProjectImages.bebidaIcon,
      price: 300,
      quantity: 3.obs,
    ),
    Product(
      id: 4,
      name: 'Sándwich de Jamón y Queso',
      imagePath: ProjectImages.bebidaIcon,
      price: 800,
      quantity: 1.obs,
    ),
    Product(
      id: 5,
      name: 'Chocolatina',
      imagePath: ProjectImages.bebidaIcon,
      price: 200,
      quantity: 5.obs,
    ),
  ].obs;

  // Añadir producto al carrito
  // Añadir producto al carrito
  void addItemToCart(Product product) {
    var existingProduct =
        cartItems.firstWhereOrNull((item) => item.id == product.id);

    if (existingProduct != null) {
      existingProduct.quantity.value++;
    } else {
      cartItems.add(product);
    }
    cartItems.refresh();
  }

  // Eliminar producto del carrito
  void removeItemFromCart(int productId) {
    cartItems.removeWhere((item) => item.id == productId);
  }

  // Actualizar la cantidad de un producto en el carrito
  void updateQuantity(int productId, int quantity) {
    var product = cartItems.firstWhereOrNull((item) => item.id == productId);
    if (product != null && quantity > 0) {
      product.quantity.value = quantity;
      cartItems.refresh();
    }
  }

  // Calcular el precio total
  int get totalPrice {
    return cartItems.fold(
        0, (sum, item) => sum + item.price * item.quantity.value);
  }

  final List<Map<String, dynamic>> items = [
    {
      "title": "cafe",
      "quantity": 1,
      "unit_price": 600,
    },
  ];

  Future<void> transformarYAbrirLinkMercadoPago(String linkMercadoPago) async {
    // Extraer el ID de la preferencia
    final regex = RegExp(r'pref_id=([^&]+)');
    final match = regex.firstMatch(linkMercadoPago);

    if (match != null) {
      final preferenceId = match.group(1);

      final nuevoLink =
          "https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=$preferenceId";

      final uriLink = Uri.parse(nuevoLink);
      if (await canLaunchUrl(uriLink)) {
        await launchUrl(uriLink);
      } else {
        print('No se pudo abrir el link: $nuevoLink');
      }
    } else {
      print('No se encontró el ID de preferencia en el link');
    }
  }

  void pay() async {
    Response response = await payProvider.pay(items);
    if (response.statusCode == 200) {
      String? url = response.body["sandbox_init_point"];
      if (url != null) {
        transformarYAbrirLinkMercadoPago(url);
        // Get.toNamed("/pay", arguments: Future.value(url));
      }
    }
  }
}
