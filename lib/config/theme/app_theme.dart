import 'package:flutter/material.dart';

const Color _customColor = Color(0xFFFFE500);
const List<Color> _colorThemes = [
  _customColor,
  Colors.yellow,
  Colors.orange,
  Colors.amber,
  Colors.red,
  Colors.cyan,
  Colors.teal,
  Colors.blue,
];

class AppTheme {
  int selectedColor;
  final bool enableDarkMode;

  AppTheme({
    this.enableDarkMode = false,
    this.selectedColor = 0,
  }) : assert(
          //condicion para evitar que seleccionen un tema que no existe
          selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
          "Más colores entre 0 y ${_colorThemes.length}",
        );
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      brightness:
          enableDarkMode ? Brightness.dark : Brightness.light, //Modo oscuro
    );
  }
}
