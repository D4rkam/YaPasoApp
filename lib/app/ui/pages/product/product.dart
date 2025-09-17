import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/product_controller.dart';

import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/counter_product.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

  // final List<Map<String, String>> sugerencias = [
  //   {
  //     'nombre': 'Coca Cola',
  //     'precio': '\$700',
  //     'imagen': 'assets/images/productos/coca_cola.png',
  //   },
  //   {
  //     'nombre': 'Don satur',
  //     'precio': '\$500',
  //     'imagen': 'assets/images/productos/don_satur.png',
  //   },
  //   {
  //     'nombre': 'Maiz inflado',
  //     'precio': '\$650',
  //     'imagen': 'assets/images/productos/maiz_inflado.png',
  //   }
  // ].cast<Map<String, String>>();

  @override
  Widget build(BuildContext context) {
    // final ShoppingCartController shoppingCartController = Get.find();
    return GetBuilder<ProductController>(builder: (controller) {
      return Scaffold(
        // Barra de navegación
        extendBody: true,
        backgroundColor: const Color(0xFFFFE500),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFE500),
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Mi Saldo',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 10),
              child: ShoppingCartButton(),
            )
          ],
        ),
        body: Obx(() {
          if (controller.product.value == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final product = controller.product.value!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.network(
                  product.imageUrl, // Reemplaza con la ruta de tu imagen
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y reseñas
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ]),

                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.description,
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4D4D4D)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Contador
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                color: Color(0xFFFFE500),
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 40,
                              child: Counter(
                                  widthButton: 40,
                                  heightButton: 40,
                                  product: ProductForCart(
                                    id: product.id,
                                    name: product.name,
                                    imagePath: product.imageUrl,
                                    price: product.price,
                                    quantity: 1.obs,
                                  )),
                            )
                          ],
                        ),

                        const Spacer(),

                        // Sugerencias "Para acompañar"
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text(
                        //       'Para acompañar',
                        //       style: TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.w600),
                        //     ),
                        //     const SizedBox(height: 16),
                        //     SizedBox(
                        //       height: 150,
                        //       child: ListView.builder(
                        //         scrollDirection: Axis.horizontal,
                        //         itemCount: sugerencias
                        //             .length, // Reemplaza 'sugerencias' con tu lista de datos
                        //         itemBuilder: (context, index) {
                        //           final sugerencia = sugerencias[index];
                        //           return ProductSuggestionCard(
                        //             productName: sugerencia["nombre"]!,
                        //             productPrice: sugerencia["precio"]!,
                        //             imagePath: sugerencia["imagen"]!,
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const Spacer(),
                        SafeArea(
                            child: Center(
                                child: _addToShoppingCart(context: context)))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Más',
            ),
          ],
        ),
      );
    });
  }

  // Función auxiliar para crear cada sugerencia
  Widget _buildSugerencia(String nombre, String precio, String imagen) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Image.asset(
            imagen, // Reemplaza con la ruta de tu imagen
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(nombre),
          Text(precio),
        ],
      ),
    );
  }

  //widget to add or remove cant of product
  Widget _buildCounter(int count) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 160,
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              overlayColor:
                  WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
              onTap: null,
              child: Ink(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFD7D7D7),
                ),
                child: const Icon(
                  Icons.remove,
                  color: Color(0xFF6F6F6F),
                ),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                color: Color(0xFFD3BF09),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ), // Mostrar la cantidad seleccionada
            InkWell(
              onTap: () {},
              overlayColor:
                  WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
              child: Ink(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFF9EA68),
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFFD3BF09),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addToShoppingCart({required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton(
        onPressed: () => {},
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(const Color(0xFFFFE500)),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Añadir al carrito',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 8),
            Icon(Icons.shopping_cart_rounded),
          ],
        ),
      ),
    );
  }
}

class ProductSuggestionCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String imagePath;

  const ProductSuggestionCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 130,
      child: Card(
        elevation: 5,
        color: Colors.white, // Fondo oscuro similar a la imagen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 50, // Ajusta la altura según tus necesidades
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                productName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productPrice,
                    style: const TextStyle(
                        color:
                            Color(0xFFFAD246), // Amarillo similar a la imagen
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFFFAD246),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
