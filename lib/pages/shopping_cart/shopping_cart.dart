import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/shopping_cart/shopping_cart_controller.dart';

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
                    Counter(
                      controller: controller,
                      product: product,
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

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.controller,
    required this.product,
  });

  final ProductForCart product;
  final ShoppingCartController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 90,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => InkWell(
                overlayColor:
                    WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
                onTap: (product.quantity.value > 1)
                    ? () {
                        controller.updateQuantity(
                            product.id, product.quantity.value - 1);
                      }
                    : null,
                child: Obx(
                  () => Ink(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: (product.quantity.value > 1)
                            ? const Color(0xFFF9EA68)
                            : const Color(0xFFD7D7D7)),
                    child: Icon(Icons.remove,
                        color: (product.quantity.value > 1)
                            ? const Color(0xFFD3BF09)
                            : const Color(0xFF6F6F6F)),
                  ),
                ),
              ),
            ),
            Obx(
              () => FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${product.quantity}',
                  style: const TextStyle(
                    color: Color(0xFFD3BF09),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ), // Mostrar la cantidad seleccionada
            InkWell(
              onTap: () {
                controller.updateQuantity(
                    product.id, product.quantity.value + 1);
              },
              overlayColor:
                  WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
              child: Ink(
                height: 30,
                width: 30,
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
