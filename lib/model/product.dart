import 'package:flutter/foundation.dart';

class Product {
  int id;
  String name;
  dynamic price;
  String article;
  String image;

  Product({
    @required this.id,
    @required this.name,
    this.price,
    @required this.article,
    @required this.image
  });

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      id: json["id"] as int,
      name: json["name"] as String ?? "unknown",
      price: json["price"] as dynamic ?? null,
      article: json["article"] as String ?? "unknown",
      image: json["image"] as String ?? "unknown"
    );
  }
}