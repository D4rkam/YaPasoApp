import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;

  const ProductCard(this.title, this.price, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Image.asset(imageUrl),
        title: Text(title),
        subtitle: Text('\$$price'),
        trailing: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
