import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/Product_Detail.dart';
import '../utils/fake_products.dart';
import 'api_Services.dart';

class Request_Product_Detail {
  // URL của API để lấy danh sách sản phẩm
  static final String baseUrl = ApiService.UrlVuong + "products/detail/";

  // Hàm fetch sản phẩm từ API
  static Future<ProductDetail> fetchProductDetail(String productId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + productId));

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200) {
        // Nếu thành công, chuyển đổi dữ liệu JSON thành danh sách Product
        final data = jsonDecode(response.body);
        return ProductDetail.fromJson(data);
      } else {
        throw Exception("Failed to load product detail");
      }
    } catch (e) {
      print("Error fetching product detail: $e");
      print("Using fake product detail data instead");
      // Trả về chi tiết sản phẩm giả
      return FakeProducts.generateProductDetail(productId);
    }
  }
}