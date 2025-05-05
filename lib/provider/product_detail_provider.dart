import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/product_detail.dart';

class ProductDetailProvider with ChangeNotifier {
  ProductDetail? _productDetail;
  bool _loading = false;

  ProductDetail? get productDetail => _productDetail;
  bool get isLoading => _loading;

  Future<void> fetchProductDetail(String productSpuId) async {
    _loading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
        'http://192.168.10.111:5000/products/detail/$productSpuId',
      );
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _productDetail = ProductDetail.fromJson(data);
      } else {
        throw Exception("Lỗi khi tải dữ liệu chi tiết sản phẩm");
      }
    } catch (e) {
      print("Error fetching product detail: $e");
    }

    _loading = false;
    notifyListeners();
  }

  void clear() {
    _productDetail = null;
    notifyListeners();
  }

  // Tìm ID của thuộc tính theo tên và giá trị
  String? findSkuAttrIdByValue(String attrName, String? value) {
    if (value == null) return null;
    try {
      final match = _productDetail?.skuAttrs.firstWhere(
        (e) => e.name == attrName && e.value == value,
      );
      return match?.skuAttrId;
    } catch (e) {
      return null;
    }
  }

  // Lấy danh sách giá trị theo tên thuộc tính (dùng cho dropdown)
  List<String> getValuesByAttrName(String attrName) {
    return productDetail?.skuAttrs
            .where((attr) => attr.name == attrName)
            .map((attr) => attr.value)
            .toSet()
            .toList() ??
        [];
  }

  List<ProductSPU> _allProducts = [];
  List<ProductSPU> get allProducts => _allProducts;
  Future<void> fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.10.111:5000/products/all'),
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _allProducts = data.map((e) => ProductSPU.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Lỗi fetch all products: $e");
    }
  }
}
