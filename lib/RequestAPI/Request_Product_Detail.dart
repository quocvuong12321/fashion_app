import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Product_Detail.dart';
import 'api_Services.dart';

class Request_Product_Detail {
  // URL của API để lấy danh sách sản phẩm
  static final String baseUrl = ApiService.UrlVuong + "products/detail/";
  static final String baseUrlRatings =
      ApiService.UrlHien + "rating/list_rating";
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
      print("Error fetching products: $e");
      throw Exception("Error fetching products");
    }
  }

  static Future<List<Rating>> fetchRatings(String productId) async {
    try {
      final response = await http.get(
        Uri.parse(
          baseUrlRatings +
              "?products_spu_id=" +
              productId +
              "&limit=100&page=1",
        ),
      );

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200) {
        // Nếu thành công, chuyển đổi dữ liệu JSON thành danh sách Product
        final data = jsonDecode(response.body);
        return (data['result']["discounts"] as List)
            .map((item) => Rating.fromJson(item))
            .toList();
      } else {
        throw Exception("Failed to load product detail");
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Error fetching products");
    }
  }
}
