import 'package:flutter/material.dart';

class AdWidget extends StatelessWidget {
  const AdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 162,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage("assets/images/empanadas_ad.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay oscuro
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Contenido sobre el overlay
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EMPANADAS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Pollo Y Carne',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
