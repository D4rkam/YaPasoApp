import 'package:flutter/material.dart';

class CartProductGrid extends StatelessWidget {
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

  CartProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => ProductCard(
          name: products[i]['name']!,
          price: products[i]['price']!,
          imageUrl: products[i]['image']!,
        ),
        childCount: products.length,
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Card(
          color: Colors.white,
          elevation: 5,
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
