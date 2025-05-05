import 'package:flutter/material.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider extends ChangeNotifier {
  List<dynamic> _products = [];
  bool isLoading = true;

  List<dynamic> get products => _products;

  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse("http://192.168.10.111:5000/products/");
      final response = await http.get(url);
      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _products = data.map((e) => Product.fromJson(e)).toList();
      } else {
        print("Lỗi API: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi fetch: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  // List<Product> get products => _products;

  /// Sắp xếp giá tăng dần
  void sortByPriceAscending() {
    _products.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  /// Sắp xếp giá giảm dần
  void sortByPriceDescending() {
    _products.sort((a, b) => b.price.compareTo(a.price));
    notifyListeners();
  }

  /// Sắp xếp theo đánh giá cao nhất
  void sortByRating() {
    _products.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
  }

  /// Sắp xếp theo tên (A-Z)
  void sortByName() {
    _products.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  /// Sắp xếp theo mã giảm giá
  // void sortByDisCount() {
  //   products.sort((a, b) => b.discount.compareTo(a.discount));
  //   notifyListeners();
  // }
}
