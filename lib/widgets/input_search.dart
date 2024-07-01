import 'package:flutter/material.dart';

class InputSearchWidget extends StatelessWidget {
  const InputSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "Buscar producto",
                hintStyle: TextStyle(
                    color: Color(0xFFD1D1D1),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.search,
              color: Color(0xFF7F7F7F),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
