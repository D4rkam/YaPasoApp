import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/pages/category/category_controller.dart';
import 'package:prueba_buffet/pages/home/home_controller.dart';
import 'package:prueba_buffet/widgets/container_input.dart';
import 'package:prueba_buffet/widgets/list_of_products.dart';
import 'package:prueba_buffet/widgets/shopping_cart_button.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key, required this.categoryTitle});

  final String categoryTitle;

  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    categoryController.getProducts(categoryTitle);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: const Color(0xFFFFE500),
          titleSpacing: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: ShoppingCartButton(
                  homeController: Get.find<HomeController>()),
            )
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            categoryTitle,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            const ContainerInputSearch(),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ListOfProducts(controller: categoryController),
          ],
        )

        // bottomNavigationBar: BottomNavigationBar(
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.notifications),
        //       label: 'Notificaciones',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Inicio',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.more_horiz),
        //       label: 'Más',
        //     ),
        //   ],
        // ),
        );
  }
}
