import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts({int limit = 20, int skip = 0}) async {
    final uri = Uri.parse('$baseUrl/products?limit=$limit&skip=$skip');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List productsJson = body['products'] ?? [];
      return productsJson.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Error al obtener productos: ${res.statusCode}');
    }
  }

  Future<Product> fetchProduct(int id) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return Product.fromJson(body);
    } else {
      throw Exception('Error al obtener producto: ${res.statusCode}');
    }
  }

  Future<Product> createProduct(Product product) async {
    final uri = Uri.parse('$baseUrl/products/add');
    final res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = jsonDecode(res.body);
      return Product.fromJson(body);
    } else {
      throw Exception('Error al crear producto: ${res.statusCode}');
    }
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> updates) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    final res = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updates));
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return Product.fromJson(body);
    } else {
      throw Exception('Error al actualizar producto: ${res.statusCode}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    final res = await http.delete(uri);
    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception('Error al eliminar producto: ${res.statusCode}');
    }
  }
}
