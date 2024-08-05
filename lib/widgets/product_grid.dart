import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'Galletita Opera',
      'price': '750',
      'image': "assets/images/productos/don_satur.png"
    },
    {
      'name': 'Alfajor Guaymallen',
      'price': '650',
      'image': "assets/images/productos/don_satur.png"
    },
    {
      'name': 'Alfajor Guaymallen',
      'price': '650',
      'image': "assets/images/productos/don_satur.png"
    },
    {
      'name': 'Alfajor Guaymallen',
      'price': '650',
      'image': "assets/images/productos/don_satur.png"
    },
    {
      'name': 'Alfajor Guaymallen',
      'price': '650',
      'image': "assets/images/productos/don_satur.png"
    },
  ];

  ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => ProductCard(
          name: products[i]['name']!,
          price: products[i]['price']!,
          imageUrl: products[i]['image']!,
        ),
        childCount: products.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.88,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      child: Image(
                        image: AssetImage(
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$$price',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Acción al agregar al carrito
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
