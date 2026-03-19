import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/counter_product.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/utils/helpers/image_helper.dart';

class ShoppingCartScreen extends StatelessWidget with ResponsiveMixin {
  ShoppingCartScreen({super.key});
  final ShoppingCartController controller = Get.find<ShoppingCartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
            'Carrito',
            style:
                TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
          ),
        ),
        body: Obx(() => (controller.cartItems.isEmpty)
            ? EmptyCartState()
            : ScreenWithItems(controller: controller)));
  }
}

// ---------------------------------------------------------
// NUEVO: ESTADO DE CARRITO VACÍO ANIMADO Y ESTÉTICO
// ---------------------------------------------------------
class EmptyCartState extends StatelessWidget with ResponsiveMixin {
  EmptyCartState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(setWidth(30)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE500)
                  .withOpacity(0.15), // Fondo circular suave
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: setSp(80),
              color: const Color(0xFFD4BE00),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                  begin: -5, end: 5, duration: 2000.ms, curve: Curves.easeInOut)
              .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.05, 1.05),
                  duration: 2000.ms),

          SizedBox(height: setHeight(30)),

          // 2. Texto Principal
          Text(
            "¡Tu carrito está vacío!",
            style: TextStyle(
              fontSize: setSp(28),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

          SizedBox(height: setHeight(10)),

          // 3. Subtítulo amigable
          Padding(
            padding: EdgeInsets.symmetric(horizontal: setWidth(40)),
            child: Text(
              "¿No sabés qué comer hoy? Mirá los productos del buffet y sumalos acá.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: setSp(16),
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          SizedBox(height: setHeight(40)),

          // 4. Botón de acción
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(
                "/products",
              );
            },
            icon:
                const Icon(Icons.restaurant_menu_rounded, color: Colors.black),
            label: Text(
              "Ver productos",
              style: TextStyle(
                color: Colors.black,
                fontSize: setSp(18),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFE500),
              padding: EdgeInsets.symmetric(
                  horizontal: setWidth(40), vertical: setHeight(15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0, // Más plano, moderno
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }
}

class ScreenWithItems extends StatelessWidget with ResponsiveMixin {
  const ScreenWithItems({
    super.key,
    required this.controller,
  });

  final ShoppingCartController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        // Lista de productos con scroll
        Expanded(
          child: ListView.builder(
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              final product = controller.cartItems[index];
              return Dismissible(
                key: Key(product.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFDB9B9),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: setSp(35),
                  ),
                ),
                onDismissed: (direction) {
                  controller.removeItemFromCart(product.id);
                },
                child: ProductCardCart(
                  product: product,
                ),
              );
            },
          ),
        ),

        // Contenedor con el total y el botón de compra (fijo)
        Container(
          padding: EdgeInsets.all(setWidth(20)),
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total a Pagar",
                      style: TextStyle(
                          color: const Color(0xFF4D4D4D),
                          fontSize: setSp(22),
                          fontWeight: FontWeight.normal),
                    ),
                    Obx(
                      () => Text("\$${controller.totalPrice}",
                          style: TextStyle(
                              fontSize: setSp(22),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(height: setHeight(20)),
                BuyButton(controller: controller) // Botón de compra
              ],
            ),
          ),
        ),
      ]);
    });
  }
}

class ListOfProducts extends StatelessWidget with ResponsiveMixin {
  const ListOfProducts({
    super.key,
    required this.controller,
  });

  final ShoppingCartController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.cartItems.length,
          itemBuilder: (context, index) {
            final product = controller.cartItems[index];
            return Dismissible(
              key: Key(product.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                controller.removeItemFromCart(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Producto eliminado")));
              },
              child: ProductCardCart(
                product: product,
              ),
            );
          },
        ));
  }
}

class ProductCardCart extends StatelessWidget with ResponsiveMixin {
  ProductCardCart({super.key, required this.product});

  final ProductForCart product;
  final ShoppingCartController controller = Get.find<ShoppingCartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: setHeight(5), horizontal: setWidth(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 1)
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Product Image
            Container(
              width: setWidth(80),
              height: setHeight(80),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(ImageHelper.getOptimizedUrl(
                    product.imagePath,
                    width: 200,
                    height: 200,
                  )),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: setWidth(15)),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: setSp(18), fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                            color: const Color(0xFF98C21F),
                            fontSize: setSp(18),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: setWidth(100),
                        child: Counter(
                          heightButton: setHeight(27),
                          widthButton: setWidth(27),
                          product: product,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyButton extends StatelessWidget with ResponsiveMixin {
  const BuyButton({super.key, required this.controller});
  final ShoppingCartController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: setHeight(70),
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFFFFE500)),
            foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))))),
        onPressed: () {
          controller.goPayScreen();
        },
        child: Text(
          "Comprar",
          style: TextStyle(fontSize: setSp(30), fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
