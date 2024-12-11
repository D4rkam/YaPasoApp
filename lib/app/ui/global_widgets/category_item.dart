import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color? backgroundColor;
  final void Function()? onTap;

  const CategoryItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      this.onTap,
      this.backgroundColor = const Color.fromARGB(255, 231, 230, 230)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                  child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
