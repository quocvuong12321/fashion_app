import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/Product.dart';
import '../utils/fake_products.dart';
import 'api_Services.dart';

class Request_Products {
  // URL của API để lấy danh sách sản phẩm
  static final String baseUrl = ApiService.UrlVuong + "products/";

  // Hàm fetch sản phẩm từ API
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200) {
        // Nếu thành công, chuyển đổi dữ liệu JSON thành danh sách Product
        final List data = jsonDecode(response.body);
        return data.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error fetching products: $e");
      print("Using fake products data instead");
      return FakeProducts.generateFakeProducts();
    }
  }

  // Lọc sản phẩm theo danh mục (category_id) và giá
  static Future<List<Product>> filterProducts(
    String categoryId,
    double minPrice,
    double maxPrice,
  ) async {
    try {
      final url = Uri.parse(
        "$baseUrl/$categoryId?min_price=$minPrice&max_price=$maxPrice",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load filtered products");
      }
    } catch (e) {
      print("Error fetching filtered products: $e");
      print("Using fake products data instead");
      // Lấy dữ liệu giả và lọc theo yêu cầu
      return FakeProducts.generateFakeProducts()
          .where((product) => 
              (categoryId.isEmpty || product.categoryId == categoryId) &&
              product.price >= minPrice &&
              product.price <= maxPrice)
          .toList();
    }
  }

  // Hàm sort sản phẩm theo giá (tăng dần hoặc giảm dần)
  static List<Product> sortByPrice(List<Product> products, bool isAscending) {
    products.sort(
      (a, b) =>
          isAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );
    return products;
  }

  // Hàm sort sản phẩm theo đánh giá (cao nhất)
  static List<Product> sortByRating(List<Product> products) {
    products.sort((a, b) {
      double ratingA = a.rating;
      double ratingB = b.rating;
      return ratingB.compareTo(ratingA); // Sort from highest to lowest rating
    });
    return products;
  }

  // Hàm sort sản phẩm theo tên (A-Z)
  static List<Product> sortByName(List<Product> products) {
    products.sort((a, b) => a.name.compareTo(b.name));
    return products;
  }

  static Future<String> getImage(String imagePath) async {
    return '${ApiService.UrlHien}media/products?id=$imagePath';
  }

  // Hàm fetch sản phẩm theo categoryId
  static Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    try {
      final url = Uri.parse(
        "$baseUrl/$categoryId",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Nếu API trả về danh sách ở data['result'] hoặc data['products'] thì sửa lại cho đúng
        final List productsData = data is List
            ? data
            : (data['result'] ?? data['products'] ?? []);
        return productsData.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load products by category");
      }
    } catch (e) {
      print("Error fetching products by category: $e");
      print("Using fake products data instead");
      // Lấy dữ liệu giả và lọc theo categoryId
      return FakeProducts.generateFakeProducts()
          .where((product) => product.categoryId == categoryId)
          .toList();
    }
  }

  static Future<Product> fetchProductDetail(String productId) async {
    try {
      final url = Uri.parse("${ApiService.UrlVuong}products/detail/$productId");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data); // hoặc ProductDetail.fromJson nếu có model riêng
      } else {
        throw Exception("Failed to load product detail");
      }
    } catch (e) {
      print("Error fetching product detail: $e");
      print("Using fake product data instead");
      // Tìm sản phẩm giả tương ứng với productId
      return FakeProducts.generateFakeProducts().firstWhere(
        (product) => product.productSpuId == productId,
        orElse: () => FakeProducts.generateFakeProducts().first,
      );
    }
  }
}
