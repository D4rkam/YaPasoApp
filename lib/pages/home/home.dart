import 'package:flutter/material.dart';
import 'package:prueba_buffet/widgets/carrusel.dart';
import 'package:prueba_buffet/widgets/category_card.dart';
import 'package:prueba_buffet/widgets/input_search.dart';
import 'package:prueba_buffet/widgets/navbar.dart';
import 'package:prueba_buffet/widgets/product_card.dart';

//TODO: Utilizar MediaQuery para realizar un diseño responsive para todos los dispositivos moviles

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          toolbarHeight: 100,
          backgroundColor: const Color(0xFFFFE500),
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Buenos días!',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                Text('¿Qué vas a comprar hoy?',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/steve_person.png"),
                minRadius: 40,
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFFFFE500),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: InputSearchWidget(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: CarruselWidget(),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Categorías',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryCard('Galletitas',
                      'assets/images/categorias/snacks_categoria.png'),
                  CategoryCard('Golosinas',
                      'assets/images/categorias/snacks_categoria.png'),
                  CategoryCard('Bebidas',
                      'assets/images/categorias/snacks_categoria.png'),
                  CategoryCard('Snacks',
                      'assets/images/categorias/snacks_categoria.png'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Todos los Productos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const ProductCard('Galletita Opera', 750,
                'assets/images/productos/don_satur.png'),
            const ProductCard('Alfajor Guaymallén', 650,
                'assets/images/productos/coca_cola.png'),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }

  // Widget carrusel() {
  //   return
  //
  // }

  Widget shoppingCart() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            padding:
                WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
          ),
        ),
        const Positioned(
          right: 1,
          top: 1,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 11,
            child: Text("1",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}
