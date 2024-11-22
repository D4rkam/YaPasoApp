import 'package:flutter/material.dart';
import 'package:prueba_buffet/widgets/InDecreBottom.dart';

class CartProductGrid extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'Medialuna',
      'price': '500',
      'description': 'Descripción',
      'image': "assets/images/carrito/medialuna.png"
    },
    {
      'name': 'Lata de Pepsi',
      'price': '650',
      'description': 'Descripción',
      'image': "assets/images/carrito/pepsi.png"
    },
    {
      'name': 'Cafe Expreso',
      'price': '600',
      'description': 'Descripción',
      'image': "assets/images/carrito/cafe_expreso.png"
    },
  ];

  CartProductGrid({super.key});

  @override

  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (ctx, i) => Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: ProductCard(
                name: products[i]['name']!,
                price: products[i]['price']!,
                description: products[i]['description']!,
                imageUrl: products[i]['image']!,
              ),
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
  final String description;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },

      child: SizedBox(
        height: 140,
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
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    child: Image(
                      image: AssetImage(
                          imageUrl),
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IncrementDecrementButton(
                  initialValue: 1,
                  min: 0,
                  max: 10,
                  onChanged: (value) {
                    print('Cantidad actual: $value');
                  },
                ),
              ),

              Positioned(
                bottom: 75,
                left: 180,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                  top: 55,
                  left: 180,
                  child: Text(
                    description,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF4d4d4d),),
                  )),
              Positioned(
                top: 80,
                left: 180,
                child: Text(
                  '\$$price',
                  style: const TextStyle(
                      fontSize: 23,
                      color: Color(0xFF98c21f),
                      fontWeight: FontWeight.w500),
                ),
              ),
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