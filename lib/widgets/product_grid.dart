import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';
import 'package:prueba_buffet/pages/shopping_cart/shopping_cart_controller.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final products = controller.productsFromApi;

    return Obx(() => (products.isEmpty)
        ? SliverToBoxAdapter(
            child: Center(
              child: Container(
                color: Colors.grey,
                height: 500,
                width: 200,
                child: const Center(child: Text("El servidor no responde")),
              ),
            ),
          )
        : Obx(() => SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => ProductCard(
                  product: ProductForCart(
                      id: products[i].id,
                      name: products[i].name,
                      price: products[i].price,
                      imagePath: products[i].imageUrl,
                      quantity: 1.obs),
                ),
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            )));
  }
}

class ProductCard extends StatelessWidget {
  final ProductForCart product;
  final ShoppingCartController controller = Get.find<ShoppingCartController>();

  ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: product.id);
      },
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Card(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    child: Image(
                      image: NetworkImage(
                          scale: 1,
                          product
                              .imagePath), // Reemplaza con la URL de tu imagen
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                  color: Colors.yellow,
                ),
              ),
              Positioned(
                bottom: 45,
                left: 12,
                child: Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 12,
                child: Text(
                  '\$${product.price}',
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.green,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Obx(
                  () => IconButton(
                      icon: Icon(
                        controller.isInCart(product.id)
                            ? Icons.check
                            : Icons.add_shopping_cart,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (controller.isInCart(product.id)) {
                          controller.removeItemFromCart(product.id);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Producto eliminado"),
                            duration: Duration(milliseconds: 400),
                          ));
                        } else {
                          controller.addItemToCart(product);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Producto agregado"),
                            duration: Duration(milliseconds: 400),
                          ));
                        }
                      },
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFFFFE500),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
