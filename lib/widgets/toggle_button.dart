import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> labels;
  final Function(int) onToggle;
  final int initialSelectedIndex;

  const CustomToggleButton({
    super.key,
    required this.labels,
    required this.onToggle,
    this.initialSelectedIndex = 0,
  });

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(
        widget.labels.length, (index) => index == widget.initialSelectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(10),
      fillColor: const Color(0xFF2C2F3D),
      disabledColor: Colors.grey,
      selectedColor: Colors.white,
      color: Colors.grey,
      isSelected: isSelected,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        });
        widget.onToggle(index);
      },
      children: widget.labels
          .map((label) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  label,
                  style: TextStyle(fontSize: 18),
                ),
              ))
          .toList(),
    );
  }
}
