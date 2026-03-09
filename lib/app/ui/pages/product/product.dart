import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/product_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/counter_product.dart';

import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';

class ProductScreen extends GetView<ProductController> with ResponsiveMixin {
  ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      return Scaffold(
        // Barra de navegación
        extendBody: true,
        backgroundColor: const Color(0xFFFFE500),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFE500),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: setSp(30),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Producto',
            style:
                TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: setWidth(20), top: setHeight(10)),
              child: const ShoppingCartButton(),
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
                padding: EdgeInsets.only(bottom: setHeight(16)),
                width: double.infinity,
                height: setHeight(220), // 30% de 812 (altura de diseño)
                child: Image.network(
                  product.imageUrl, // Reemplaza con la ruta de tu imagen
                  height: setHeight(200),
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/not_load.png",
                      width: setWidth(180),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: setWidth(10)),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(setWidth(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y reseñas
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                    fontSize: setSp(24),
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),

                        SizedBox(height: setHeight(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.description,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: setSp(18),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4D4D4D)),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: setHeight(30)),

                        // Contador
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                color: const Color(0xFF44A442),
                                fontSize: setSp(30),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: setWidth(150),
                              height: setHeight(40),
                              child: Counter(
                                widthButton: setWidth(40),
                                heightButton: setHeight(40),
                                product: ProductForCart(
                                  id: product.id.toString(),
                                  name: product.name,
                                  imagePath: product.imageUrl,
                                  price: product.price,
                                  quantity: controller.quantitySelected,
                                  maxQuantity: product.quantity,
                                ),
                              ),
                            )
                          ],
                        ),

                        const Spacer(),

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
      );
    });
  }

  Widget _addToShoppingCart({required BuildContext context}) {
    final ShoppingCartController shoppingCartController = Get.find();
    final product = controller.product.value!;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: setHeight(50),
      // EL OBX DEBE EMPEZAR AQUÍ
      child: Obx(() {
        // Guardamos el estado en una variable para que el código sea más limpio
        final bool inCart =
            shoppingCartController.isInCart(product.id.toString());

        return ElevatedButton(
          onPressed: (inCart || controller.quantitySelected.value == 0)
              ? null // Opcional: deshabilitar si ya está en el carrito
              : () {
                  shoppingCartController.addItemToCart(
                    ProductForCart(
                      id: product.id.toString(),
                      name: product.name,
                      imagePath: product.imageUrl,
                      price: product.price,
                      quantity: controller.quantitySelected,
                      maxQuantity: product.quantity,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            // CAMBIO DINÁMICO DE COLOR
            backgroundColor: (inCart || controller.quantitySelected.value == 0)
                ? Colors.grey[400] // Color si ya está en el carrito
                : const Color(0xFFFFE500), // Tu amarillo original
            foregroundColor: Colors.black,
            textStyle: TextStyle(
              fontSize: setHeight(20),
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                inCart ? 'Producto en carrito' : 'Añadir al carrito',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: setWidth(8)),
              Icon(inCart
                  ? Icons.check_circle_outline
                  : Icons.shopping_cart_rounded),
            ],
          ),
        );
      }),
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
