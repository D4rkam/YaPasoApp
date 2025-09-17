import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/container_input.dart';
import 'package:prueba_buffet/app/ui/global_widgets/list_of_products.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String categoryTitle =
        ModalRoute.of(context)?.settings.arguments as String;

    return GetBuilder<CategoryController>(
      builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: const Color(0xFFFFE500),
            titleSpacing: 0,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: ShoppingCartButton(),
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
              ListOfProducts(controller: controller),
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
          ),
    );
  }
}
