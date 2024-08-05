import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryTitle;
  const CategoryScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes agregar la lógica para obtener los productos basados en la categoría
    final List<String> products = getProductsForCategory(categoryTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index]),
          );
        },
      ),
    );
  }

  List<String> getProductsForCategory(String category) {
    // Aquí deberías reemplazar esto con la lógica para obtener productos reales basados en la categoría
    // Este es solo un ejemplo con datos ficticios
    if (category == 'Snacks') {
      return ['Snack 1', 'Snack 2', 'Snack 3'];
    } else if (category == 'Galletitas') {
      return ['Galletita 1', 'Galletita 2', 'Galletita 3'];
    } else if (category == 'Gaseosas') {
      return ['Gaseosa 1', 'Gaseosa 2', 'Gaseosa 3'];
    } else {
      return [];
    }
  }
}
