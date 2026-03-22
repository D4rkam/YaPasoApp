import 'dart:convert';

List<Product> productFromJson(List<dynamic> jsonData) =>
    List<Product>.from(jsonData.map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String name;
  String description;
  int price;
  String imageUrl;
  int quantity;
  String category;
  int id;
  int sellerId;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.category,
    required this.id,
    required this.sellerId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // ---> LÓGICA DE PARSEO DE CATEGORÍA <---
    // El backend ahora manda un objeto {"id": 1, "nombre": "Snacks", ...}
    // en lugar de un simple String. Lo desarmamos acá.
    String categoryName = "Sin categoría";
    if (json["category"] != null) {
      if (json["category"] is Map) {
        // Si es un objeto, sacamos el nombre
        categoryName = json["category"]["nombre"] ?? "Sin categoría";
      } else {
        // Si por alguna razón sigue viniendo como String, lo tomamos directo
        categoryName = json["category"].toString();
      }
    }

    return Product(
      name: json["name"] ?? "",
      // Ponemos defaults seguros por si viene del endpoint TopSelling que no trae estos datos
      description: json["description"] ?? "Sin descripción",
      price: (json["price"] as num?)?.toInt() ?? 0,
      imageUrl: json["image_url"] ?? "",
      quantity: (json["quantity"] as num?)?.toInt() ?? 1,
      category: categoryName, // Pasamos el nombre procesado
      id: (json["id"] as num?)?.toInt() ?? 0,
      sellerId: (json["seller_id"] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "image_url": imageUrl,
        "quantity": quantity,
        "category": category,
        "id": id,
        "seller_id": sellerId,
      };
}
