import 'package:flutter/material.dart';

class ListOfProducts extends StatelessWidget {
  const ListOfProducts({
    super.key,
    required this.products,
  });

  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: Image.asset(
                products[index]['imageUrl']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(products[index]['title']!),
              subtitle: const Text('Detalles'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/product');
              },
            ),
          );
        },
      ),
    );
  }
}
