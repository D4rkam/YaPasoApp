import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  InputWidget(
      {super.key,
      required this.hintText,
      this.icon,
      required this.withIcon,
      this.textEditingController});

  final String hintText;
  final bool withIcon;
  final IconData? icon;
  TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 0.1,
                offset: const Offset(0, 2))
          ]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                    color: Color(0xFFD1D1D1),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
              ),
            ),
          ),
          withIcon
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    icon,
                    color: const Color(0xFF7F7F7F),
                    size: 30,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
