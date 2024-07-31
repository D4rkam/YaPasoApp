import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color? backgroundColor;
  final void Function()? onTap;

  const CategoryList(
      {super.key,
      required this.title,
      required this.imageUrl,
      this.onTap,
      this.backgroundColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: Image(
                  image: AssetImage(
                      "assets/images/categorias/bebidas_categoria.png"),
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(
              width: 75,
              child: Text(
                "Gaseosas categoria",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}


// Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(imageUrl, height: 50),
//           const SizedBox(height: 10),
//           Text(title),
//         ],
//       ),
//     );