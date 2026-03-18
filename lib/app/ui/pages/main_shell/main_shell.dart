import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/balance_controller.dart';
import 'package:prueba_buffet/app/controllers/category_controller.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_bottom_bar.dart';
import 'package:prueba_buffet/app/ui/global_widgets/list_of_products.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/global_widgets/shopping_cart_button.dart';
import 'package:prueba_buffet/app/ui/pages/configuration/configuration.dart';
import 'package:prueba_buffet/app/ui/pages/help/help.dart';
import 'package:prueba_buffet/app/ui/pages/home/home.dart';
import 'package:prueba_buffet/app/ui/pages/my_balance/my_balance.dart';
import 'package:prueba_buffet/app/ui/pages/order/order.dart';
import 'package:prueba_buffet/app/ui/pages/perfil/perfil.dart';

class MainShell extends StatelessWidget {
  MainShell({super.key});

  final MainShellController shellController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: ShellDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: shellController.pageIndex.value,
                children: [
                  HomeContent(),
                  OrderContent(),
                  _MyBalanceContent(),
                  _CategoryContent(),
                  const PerfilContent(),
                  const ConfiguracionContent(),
                  const AyudaContent(),
                ],
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBottomBar(controller: shellController),
          ),
        ],
      ),
    );
  }
}

class ShellDrawer extends StatelessWidget with ResponsiveMixin {
  ShellDrawer({super.key});

  final MainShellController shellController = Get.find();
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: setWidth(230),
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: setHeight(32),
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(
                        "https://ui-avatars.com/api/?name=${homeController.userSession.name}+${homeController.userSession.lastName}&background=000&color=fff")),
                SizedBox(height: setHeight(10)),
                Flexible(
                  child: Text(
                    "${homeController.userSession.username}",
                    style: TextStyle(
                        fontSize: setSp(20), fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    "${homeController.userSession.name} ${homeController.userSession.lastName}",
                    style: TextStyle(fontSize: setSp(16)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => ListTile(
                selected: shellController.tabIndex.value == 1,
                selectedTileColor: const Color(0xFFFFE500),
                leading: Icon(
                  Icons.person,
                  color: shellController.tabIndex.value == 1
                      ? Colors.black
                      : const Color(0xFFFFE500),
                  size: setSp(30),
                ),
                title: const Text('Perfil',
                    style: TextStyle(fontWeight: FontWeight.normal)),
                onTap: () {
                  shellController.tabIndex.value = 1;
                  shellController.goToPerfil();
                },
              )),
          ListTile(
            selected: shellController.tabIndex.value == 2,
            selectedTileColor: const Color(0xFFFFE500),
            leading: Icon(
              Icons.settings,
              color: shellController.tabIndex.value == 2
                  ? Colors.black
                  : const Color(0xFFFFE500),
              size: setSp(30),
            ),
            title: const Text('Configuración',
                style: TextStyle(fontWeight: FontWeight.normal)),
            onTap: () {
              shellController.tabIndex.value = 2;
              shellController.goToConfiguracion();
            },
          ),
          ListTile(
            selected: shellController.tabIndex.value == 3,
            selectedTileColor: const Color(0xFFFFE500),
            leading: Icon(
              Icons.chat,
              color: shellController.tabIndex.value == 3
                  ? Colors.black
                  : const Color(0xFFFFE500),
              size: setSp(30),
            ),
            title: const Text('Ayuda',
                style: TextStyle(fontWeight: FontWeight.normal)),
            onTap: () {
              shellController.tabIndex.value = 3;
              shellController.goToHelp();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: const Color(0xFFFFE500),
              size: setSp(30),
            ),
            title: const Text('Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.normal)),
            onTap: () {
              homeController.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class _MyBalanceContent extends StatelessWidget with ResponsiveMixin {
  final ScrollController _scrollController = ScrollController();

  _MyBalanceContent() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (Get.isRegistered<BalanceController>()) {
          Get.find<BalanceController>().getMoreTransactions();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainShellController shell = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: setSp(30)),
          onPressed: () => shell.goToHome(),
        ),
        title: Text(
          'Mi Saldo',
          style: TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
        ),
      ),
      body: Get.isRegistered<BalanceController>()
          ? _buildBody()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody() {
    final controller = Get.find<BalanceController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Flexible(
              flex: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: setHeight(10)),
                    TarjetaYaPaso(controller: controller),
                    SizedBox(height: setHeight(40)),
                    Padding(
                      padding: EdgeInsets.only(
                          left: setWidth(20), bottom: setHeight(10)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mi actividad",
                          style: TextStyle(
                            fontSize: setSp(22),
                            fontWeight: FontWeight.normal,
                            color: const Color.fromARGB(255, 107, 107, 107),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: setWidth(20)),
                child: TransactionsPage(
                  controller: controller,
                  scrollController: _scrollController,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryContent extends StatelessWidget with ResponsiveMixin {
  _CategoryContent();

  @override
  Widget build(BuildContext context) {
    final MainShellController shell = Get.find();

    return Obx(() {
      final categoryTitle = shell.selectedCategory.value;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: setHeight(100),
          backgroundColor: const Color(0xFFFFE500),
          titleSpacing: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: setWidth(30)),
              child: const ShoppingCartButton(),
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: setSp(30)),
            onPressed: () => shell.goToHome(),
          ),
          title: Text(
            categoryTitle,
            style:
                TextStyle(fontSize: setSp(25), fontWeight: FontWeight.normal),
          ),
        ),
        body: Get.isRegistered<CategoryController>()
            ? GetBuilder<CategoryController>(
                builder: (controller) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: setHeight(30))),
                    ListOfProducts(controller: controller),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
