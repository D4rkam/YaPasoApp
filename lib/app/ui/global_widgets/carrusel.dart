import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/banner.dart'; // Asegurate de que la ruta sea correcta
import 'package:prueba_buffet/app/ui/global_widgets/mixins/responsive_mixin.dart';

class CarruselWidget extends StatefulWidget {
  const CarruselWidget({super.key});

  @override
  State<CarruselWidget> createState() => _CarruselWidgetState();
}

class _CarruselWidgetState extends State<CarruselWidget> with ResponsiveMixin {
  int _currentIndex = 0;

  // Usamos íconos nativos y colores en lugar de imágenes pesadas
  final List<Map<String, dynamic>> itemList = [
    {
      'title': "¡Chau a las filas!",
      'subtitle': "Pedí anticipado y retirá en el recreo sin esperar.",
      'icon': Icons.timer_outlined,
      'iconColor': const Color(0xFFFFE500), // Tu amarillo
      'isNew': true,
    },
    {
      'title': "Cargá Saldo",
      'subtitle': "Transferí desde Mercado Pago rápido y seguro.",
      'icon': Icons.account_balance_wallet_outlined,
      'iconColor': const Color(0xFF00B1EA), // Un celeste onda MP
      'isNew': false,
    },
    {
      'title': "¿Buscás algo?",
      'subtitle': "Usá la lupa para encontrar tus snacks favoritos.",
      'icon': Icons.search_rounded,
      'iconColor': const Color(0xFFFF7A00), // Un naranja vibrante
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: setHeight(170), // Un poquito más compacto
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction:
                0.88, // Deja asomar un poquito la siguiente tarjeta
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: itemList
              .map((item) => BannerCard(
                    title: item["title"],
                    subtitle: item["subtitle"],
                    icon: item["icon"],
                    iconColor: item["iconColor"],
                    isNew: item["isNew"],
                  ))
              .toList(),
        ),
        SizedBox(height: setHeight(12)),
        // Indicadores (Puntitos) mejorados
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: itemList.asMap().entries.map((entry) {
            int index = entry.key;
            bool isActive = _currentIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: isActive
                  ? setWidth(24.0)
                  : setWidth(8.0), // Se estira el activo
              height: setHeight(8.0),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isActive
                    ? const Color(0xFFFFE500) // Amarillo activo
                    : const Color(0xFFE0E0E0), // Gris inactivo
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
