import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isNew;

  const BannerCard(this.title, this.subtitle, this.imageUrl, this.isNew,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3)),
            ),
            if (isNew)
              Positioned(
                bottom: 6,
                right: 10,
                child: Container(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFFFE500)),
                  padding: const EdgeInsets.all(5),
                  child: const Text('¡Nuevo!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            Positioned(
              top: 26,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
