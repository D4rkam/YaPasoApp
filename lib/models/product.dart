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
  int id;
  int sellerId;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.id,
    required this.sellerId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        imageUrl: json["image_url"],
        quantity: json["quantity"],
        id: json["id"],
        sellerId: json["seller_id"],
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
