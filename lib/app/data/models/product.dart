// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        price: (json["price"] as num?)?.toInt() ?? 0,
        imageUrl: json["image_url"] ?? "",
        quantity: (json["quantity"] as num?)?.toInt() ?? 0,
        category: json["category"] ?? "",
        id: (json["id"] as num?)?.toInt() ?? 0,
        sellerId: (json["seller_id"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "image_url": imageUrl,
        "quantity": quantity,
        "id": id,
        "seller_id": sellerId,
      };
}
