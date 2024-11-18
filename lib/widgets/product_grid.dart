import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';

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
                  name: products[i].name,
                  price: products[i].price.toString(),
                  imageUrl: products[i].imageUrl,
                  id: products[i].id,
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
  final String name;
  final String price;
  final String imageUrl;
  final int id;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: id);
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
                          imageUrl), // Reemplaza con la URL de tu imagen
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
                  name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 12,
                child: Text(
                  '\$$price',
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.green,
                      fontWeight: FontWeight.w500),
                ),
              )
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: IconButton(
              //     icon: const Icon(Icons.add_shopping_cart),
              //     onPressed: () {
              //       // Acción al agregar al carrito
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
