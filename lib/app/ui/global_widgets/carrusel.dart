import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:prueba_buffet/app/ui/global_widgets/banner.dart';

class CarruselWidget extends StatefulWidget {
  const CarruselWidget({super.key});

  @override
  State<CarruselWidget> createState() => _CarruselWidgetState();
}

class _CarruselWidgetState extends State<CarruselWidget> {
  int _currentIndex = 0;
  final List<dynamic> itemList = [
    {
      'title': "Empanadas",
      'subtitle': "Pollo Y Carne",
      'img': "assets/images/empanadas_ad.png",
      'isNew': true,
    },
    {
      'title': "Churros",
      'subtitle': "Rellenos de dulce de leche",
      'img': "assets/images/churros.png",
      'isNew': false,
    },

    // Agrega más URLs de imágenes si es necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: false,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: itemList
              .map((item) => BannerCard(
                  item["title"], item["subtitle"], item["img"], item["isNew"]))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: itemList.map((url) {
            int index = itemList.indexOf(url);
            return Container(
              width: 40.0,
              height: 6.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == index
                    ? const Color(0xFFFFE500)
                    : const Color(0xFFC8C4A2),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
