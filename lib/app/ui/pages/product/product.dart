import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/product_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/counter_product.dart';

import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/utils/helpers/image_helper.dart';

class ProductScreen extends GetView<ProductController> with ResponsiveMixin {
  ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFE500),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFE500),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: setSp(30)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Producto',
              style: TextStyle(
                  fontSize: setSp(25), fontWeight: FontWeight.normal)),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: setWidth(20)),
              child: const ShoppingCartButton(),
            )
          ],
        ),
        body: Obx(() {
          if (controller.product.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = controller.product.value!;

          return LayoutBuilder(builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto (Ocupa un tercio aprox, pero es flexible)
                Container(
                  padding: EdgeInsets.only(bottom: setHeight(16)),
                  width: double.infinity,
                  height: constraints.maxHeight *
                      0.35, // 👈 35% del alto disponible
                  child: CachedNetworkImage(
                      imageUrl: ImageHelper.getOptimizedUrl(product.imageUrl,
                          width: 500, height: 500),
                      width: double.infinity,
                      fit: BoxFit.contain, // 👈 Que no se corte la imagen
                      errorListener: (value) {}),
                ),

                // Contenedor Blanco (Detalles)
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
                          Expanded(
                            // 👈 Permite scroll si la descripción es eterna
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                        fontSize: setSp(24),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: setHeight(8)),
                                  Text(
                                    product.description,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: setSp(18),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF4D4D4D)),
                                  ),
                                  SizedBox(height: setHeight(30)),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        width: setWidth(
                                            120), // 👈 Un poco más de ancho para el counter
                                        child: (product.quantity > 0)
                                            ? Counter(
                                                widthButton: setWidth(35),
                                                heightButton: setHeight(35),
                                                product: ProductForCart(
                                                  id: product.id.toString(),
                                                  name: product.name,
                                                  imagePath: product.imageUrl,
                                                  price: product.price,
                                                  quantity: controller
                                                      .quantitySelected,
                                                  maxQuantity: product.quantity,
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  'Sin stock',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: setSp(18),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Botón siempre visible abajo
                          SafeArea(
                              top: false,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: setHeight(15), bottom: setHeight(10)),
                                child: Center(
                                    child:
                                        _addToShoppingCart(context: context)),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        }),
      );
    });
  }

  Widget _addToShoppingCart({required BuildContext context}) {
    final ShoppingCartController shoppingCartController = Get.find();
    final product = controller.product.value!;

    return SizedBox(
      width: double
          .infinity, // 👈 Que ocupe todo el ancho disponible menos el padding
      height: setHeight(55),
      child: Obx(() {
        final bool inCart =
            shoppingCartController.isInCart(product.id.toString());

        return ElevatedButton(
          onPressed: (inCart || controller.quantitySelected.value == 0)
              ? null
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
            backgroundColor: (inCart || controller.quantitySelected.value == 0)
                ? Colors.grey[400]
                : const Color(0xFFFFE500),
            foregroundColor: Colors.black,
            textStyle: TextStyle(
              fontSize: setSp(20),
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: FittedBox(
            // 👈 Previene overflow si el texto en español es muy largo
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  inCart ? 'Añadido al carrito' : 'Añadir al carrito',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(width: setWidth(8)),
                Icon(inCart
                    ? Icons.check_circle_outline
                    : Icons.shopping_cart_rounded),
              ],
            ),
          ),
        );
      }),
    );
  }
}
