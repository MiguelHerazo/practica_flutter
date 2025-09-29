import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // paginación
  int _limit = 10;
  int _skip = 0;
  bool _hasMore = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (refresh) {
        _skip = 0;
        _hasMore = true;
        _products = [];
      }

      final newProducts =
          await _apiService.fetchProducts(limit: _limit, skip: _skip);

      if (newProducts.isEmpty || newProducts.length < _limit) {
        _hasMore = false;
      }

      _products.addAll(newProducts);
      _skip += _limit;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await _apiService.createProduct(product);
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> updates) async {
    try {
      final updated = await _apiService.updateProduct(id, updates);

      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        // aunque DummyJSON no persista, actualizamos la lista local
        _products[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);

      // siempre borramos localmente
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      // si la API falla (ej. 404 en productos creados con POST),
      // igual borramos de la lista local
      _products.removeWhere((p) => p.id == id);
      _errorMessage = 'Advertencia: ${e.toString()}';
      notifyListeners();
    }
  }
}
