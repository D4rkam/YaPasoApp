import 'dart:convert';

List<Category> categoryFromJson(dynamic data) =>
    List<Category>.from(data.map((x) => Category.fromJson(x)));

class Category {
  final int id;
  final String nombre;
  final int orden;
  final bool activa;
  final bool tieneStock;

  Category({
    required this.id,
    required this.nombre,
    required this.orden,
    required this.activa,
    required this.tieneStock,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        nombre: json["nombre"],
        orden: json["orden"] ?? 0,
        activa: json["activa"] ?? true,
        tieneStock: json["tiene_stock"] ?? false,
      );
}
