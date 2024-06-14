import 'package:flutter/material.dart';
import 'package:prueba_buffet/widgets/ad.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAD246),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        titleSpacing: 0,
        title: const Text(
          "Inicio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: shoppingCart(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFAD246),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 29, vertical: 17),
                child: AdWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 17, 29, 0),
              child: inputSearch(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 33, 29, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categorias",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Center(
                            child: _buildCategoryChip('Bebidas',
                                "assets/images/bebidas_categoria.png", 19, 34)),
                      ),
                      Expanded(
                        child: Center(
                            child: _buildCategoryChip('Snacks',
                                "assets/images/snacks_categoria.png", 24, 30)),
                      ),
                      Expanded(
                        child: Center(
                            child: _buildCategoryChip(
                                'Golosinas',
                                "assets/images/golosinas_categoria.png",
                                25,
                                17)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Descubre",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text("Ver más",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFFCDCDCD)))
                          ],
                        ),
                        _buildProductList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Lista de productos
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, String imagePath, double widthImage, double heightImage) {
    return SizedBox(
      width: 150.0, // Ajusta el ancho del Chip
      height: 60.0, // Ajusta la altura del Chip
      child: Chip(
        avatar: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: widthImage, // Ajusta el tamaño del avatar
            height: heightImage, // Ajusta el tamaño del avatar
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.transparent),
        ),
        label: Text(label),
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      children: [
        _buildProductItem(
          'Galletita Don Satur',
          'assets/images/don_satur.png',
        ),
        _buildProductItem(
          'Lata de Coca Cola',
          'assets/images/coca_cola.png',
        ),
        _buildProductItem(
          'Maiz Inflado Dulce',
          'assets/images/maiz_inflado.png',
        ),
        _buildProductItem(
          'Maiz Inflado Dulce',
          'assets/images/maiz_inflado.png',
        ),
        _buildProductItem(
          'Maiz Inflado Dulce',
          'assets/images/maiz_inflado.png',
        ),
        _buildProductItem(
          'Maiz Inflado Dulce',
          'assets/images/maiz_inflado.png',
        ),
      ],
    );
  }

  Widget _buildProductItem(String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.fitHeight,
        ),
        title: Text(title),
        subtitle: const Text('Detalles'),
      ),
    );
  }

  Widget inputSearch() {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFFE6E6E6)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "Buscar producto",
                hintStyle: TextStyle(
                    color: Color(0xFFD1D1D1),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFAD246),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget shoppingCart() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 20))),
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
