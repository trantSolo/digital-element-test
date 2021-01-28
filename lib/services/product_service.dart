import 'dart:convert';
import 'package:digital_element/model/product.dart';
import 'package:http/http.dart' as http;

class ProductService {

  Future<List<Product>> fetchProducts() async {

    final path = "https://d-element.ru/test_api.php";
    String error;

    var response = await http.get(
      path,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["items"].map<Product>((item) => Product.fromJSON(item)).toList();
    } else if (response.statusCode == 500) {
      error = "Ошибка сервера.";
    } else {
      error = "Неизвестная ошибка";
    }

    if (error != null) throw error;
    return [];
  }

}