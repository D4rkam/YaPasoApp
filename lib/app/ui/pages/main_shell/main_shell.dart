import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_buffet/app/controllers/home_controller.dart';
import 'package:prueba_buffet/app/controllers/main_shell_controller.dart';
import 'package:prueba_buffet/app/ui/global_widgets/custom_bottom_bar.dart';
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';
import 'package:prueba_buffet/app/ui/pages/home/home.dart';
import 'package:prueba_buffet/app/ui/pages/order/order.dart';

class MainShell extends StatelessWidget {
  MainShell({super.key});

  final MainShellController shellController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ShellDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: shellController.pageIndex,
                children: [
                  HomeContent(),
                  OrderContent(),
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

/// Drawer lateral compartido por todo el shell.
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
                  radius: setHeight(30),
                  backgroundImage:
                      const AssetImage('assets/images/steve_person.png'),
                ),
                SizedBox(height: setHeight(10)),
                Flexible(
                  child: Text(
                    "Darkam",
                    style: TextStyle(
                        fontSize: setSp(20), fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    "Thomas Linares",
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
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  shellController.tabIndex.value = 1;
                  Navigator.pop(context);
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
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              shellController.tabIndex.value = 1;
              Navigator.pop(context);
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
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              shellController.tabIndex.value = 1;
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: const Color(0xFFFFE500),
              size: setSp(30),
            ),
            title: const Text('Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              homeController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
