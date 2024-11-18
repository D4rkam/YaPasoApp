import 'package:flutter/material.dart';
import 'package:prueba_buffet/utils/constants/image_strings.dart';
import 'package:prueba_buffet/widgets/input_search.dart';
import 'package:prueba_buffet/widgets/list_of_products.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryTitle;
  const CategoryScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes agregar la lógica para obtener los productos basados en la categoría
    final List<Map<String, String>> products =
        getProductsForCategory(categoryTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: const Color(0xFFFFE500),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: shoppingCart(),
          )
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: InputSearchWidget(),
          ),
          ListOfProducts(products: products),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> getProductsForCategory(String category) {
    // Aquí deberías reemplazar esto con la lógica para obtener productos reales basados en la categoría
    // Este es solo un ejemplo con datos ficticios
    if (category == 'Snacks') {
      return [
        {'title': 'Snack 1', 'imageUrl': ProjectImages.snacksIcon},
        {'title': 'Snack 2', 'imageUrl': ProjectImages.snacksIcon},
        {'title': 'Snack 3', 'imageUrl': ProjectImages.snacksIcon},
      ];
    } else if (category == 'Galletitas') {
      return [
        {'title': 'Galletita 1', 'imageUrl': ProjectImages.galletitasIcon},
        {'title': 'Galletita 2', 'imageUrl': ProjectImages.galletitasIcon},
        {'title': 'Galletita 3', 'imageUrl': ProjectImages.galletitasIcon},
      ];
    } else if (category == 'Bebidas') {
      return [
        {'title': 'Lata Pepsi', 'imageUrl': ProjectImages.bebidaIcon},
        {'title': 'Lata de Coca Cola', 'imageUrl': ProjectImages.bebidaIcon},
        {'title': 'Café', 'imageUrl': ProjectImages.bebidaIcon},
        {'title': 'Matecocido', 'imageUrl': ProjectImages.bebidaIcon},
        {'title': 'Gatorade', 'imageUrl': ProjectImages.bebidaIcon},
      ];
    } else if (category == 'Golosinas') {
      return [
        {'title': 'Golosina 1', 'imageUrl': ProjectImages.galletitasIcon},
        {'title': 'Golosina 2', 'imageUrl': ProjectImages.galletitasIcon},
        {'title': 'Golosina 3', 'imageUrl': ProjectImages.galletitasIcon},
      ];
    } else if (category == 'Sandwich') {
      return [
        {'title': 'Golosina 1', 'imageUrl': ProjectImages.sandwichIcon},
        {'title': 'Golosina 2', 'imageUrl': ProjectImages.sandwichIcon},
        {'title': 'Golosina 3', 'imageUrl': ProjectImages.sandwichIcon},
      ];
    } else {
      return [];
    }
  }
}

Widget shoppingCart() {
  return Stack(
    children: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
        ),
      ),
      const Positioned(
        right: 0,
        top: 0,
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 10,
          child: Text("1", style: TextStyle(color: Colors.white, fontSize: 13)),
        ),
      )
    ],
  );
}
