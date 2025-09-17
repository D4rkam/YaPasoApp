import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/shopping_cart_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/counter_product.dart';

class ShoppingCartScreen extends StatelessWidget {
  ShoppingCartScreen({super.key});
  final ShoppingCartController controller = Get.put(ShoppingCartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
            'Carrito',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
              iconSize: 32,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_alt_rounded),
              iconSize: 32,
            ),
            const SizedBox(width: 20)
          ],
        ),
        body: Obx(() => (controller.cartItems.isEmpty)
            ? Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/cart_empty.png"),
                      const Text("¡Tu carrito esta vacio!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ]),
              )
            : ScreenWithItems(controller: controller)));
  }
}

class ScreenWithItems extends StatelessWidget {
  const ScreenWithItems({
    super.key,
    required this.controller,
  });

  final ShoppingCartController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 35,
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
          height: 200, // Tamaño fijo
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total a Pagar",
                    style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text("\$${controller.totalPrice}",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              BuyButton(controller: controller) // Botón de compra
            ],
          ),
        ),
      ],
    );
  }
}

class ListOfProducts extends StatelessWidget {
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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

class ProductCardCart extends StatelessWidget {
  ProductCardCart({super.key, required this.product});

  final ProductForCart product;
  final ShoppingCartController controller = Get.put(ShoppingCartController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: Container(
        height: 135,
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
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(product.imagePath),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(width: 40),

            // Product Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  'Descripción',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                          color: Color(0xFF98C21F),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 90),
                    SizedBox(
                      width: 90,
                      child: Counter(
                        heightButton: 30,
                        widthButton: 30,
                        product: product,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuyButton extends StatelessWidget {
  const BuyButton({super.key, required this.controller});
  final ShoppingCartController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 70,
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFFFFE500)),
            foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))))),
        onPressed: () {
          controller.goPayScreen();
        },
        child: const Text(
          "Comprar",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
