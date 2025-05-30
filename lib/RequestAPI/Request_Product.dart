import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Product.dart';
import 'api_Services.dart';
import '../model/products_respone.dart';

class Request_Products {
  // URL của API để lấy danh sách sản phẩm
  static final String baseUrl = ApiService.UrlVuong + "products/";

  static Future<ProductResponse> fetchProductsResponse({
    required int page,
    required int limit,
  }) async {
    try {
      final url = Uri.parse("$baseUrl?page=$page&limit=$limit");
      print("Requesting URL: $url");
      final response = await http.get(url);
      // final response = await http.get(url).timeout(Duration(seconds: 10));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ProductResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Error fetching products");
    }
  }
  static Future<List<Product>> fetchProducts() async {
  try {
    print("Fetching products from URL: $baseUrl");
    final response = await http.get(Uri.parse(baseUrl));
    print("Products API Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("Decoded products data: $data");

      if (data.containsKey('result') && data['result'] is Map<String, dynamic>) {
        final result = data['result'] as Map<String, dynamic>;
        if (result.containsKey('products') && result['products'] is List) {
          final List<dynamic> productsData = result['products'];

          final List<Product> products = productsData.map<Product>((productJson) {
            return Product.fromJson(productJson as Map<String, dynamic>);
          }).toList();

          return products;
        } else {
          throw Exception('Missing or invalid products list in result');
        }
      } else {
        throw Exception('Missing or invalid result field in response');
      }
    } else {
      throw Exception("Failed to load products. Status code: ${response.statusCode}, Response: ${response.body}");
    }
  } catch (e) {
    print("Error fetching products: $e");
    throw Exception("Error fetching products: $e");
  }
}

  static Future<List<Product>> fetchProductsByCategory(
    String categoryId, {
    int page = 1,
  }) async {
    final url = Uri.parse("$baseUrl?category_id=$categoryId&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final productsJson = jsonData['products'] as List;
      return productsJson.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products by category");
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
      double ratingA = a.rating ?? 0.0;
      double ratingB = b.rating ?? 0.0;
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
    final encodedPath = Uri.encodeComponent(imagePath);
    return '${ApiService.UrlHien}media/products?id=$encodedPath';
  }

  static Future<Product> fetchProductDetail(String productId) async {
    final url = Uri.parse("${ApiService.UrlVuong}products/detail/$productId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(
        data,
      ); // hoặc ProductDetail.fromJson nếu có model riêng
    } else {
      throw Exception("Failed to load product detail");
    }
  }
}
