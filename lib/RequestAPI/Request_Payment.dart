import 'dart:convert';
import 'package:fashionshop_app/RequestAPI/Token.dart';
import 'package:fashionshop_app/model/CacModelNho.dart';
import 'package:http/http.dart' as http;
import '../model/Product.dart';
import 'api_Services.dart';
import '../model/products_respone.dart';

class Request_Payment {
  // URL của API để lấy danh sách sản phẩm
  static final String baseUrl = ApiService.UrlHien;

  // Hàm fetch sản phẩm từ API
  // static Future<List<Product>> fetchProducts() async {
  //   try {
  //     final response = await http.get(Uri.parse(baseUrl));

  //     // Kiểm tra mã trạng thái HTTP
  //     if (response.statusCode == 200) {
  //       // Nếu thành công, chuyển đổi dữ liệu JSON thành danh sách Product
  //       final List data = jsonDecode(response.body);
  //       return data.map((product) => Product.fromJson(product)).toList();
  //     } else {
  //       throw Exception("Failed to load products");
  //     }
  //   } catch (e) {
  //     print("Error fetching products: $e");
  //     throw Exception("Error fetching products");
  //   }
  // }

  static Future<List<Payment>> fetchPaymentMethodResponse() async {
    try {
      final url = Uri.parse("${ApiService.UrlHien}payments/get");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final payments = jsonData['result']['payments'] as List;

        return payments.map((payment) => Payment.fromJson(payment)).toList();
      } else {
        throw Exception("Failed to load payment methods");
      }
    } catch (e) {
      print("Error fetching payment methods: $e");
      throw Exception("Error fetching payment methods");
    }
  }

  static Future<List<CustomerAddress>> fetchCustomerAddressResponse() async {
    try {
      final accessToken = await AuthStorage.getRefreshToken();
      if (accessToken == null) throw Exception('Access token is null');
      final url = Uri.parse("${ApiService.UrlHien}user/info/get_address");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${accessToken}'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final address = jsonData['result']['addrs'] as List;

        return address
            .map((address) => CustomerAddress.fromJson(address))
            .toList();
      } else {
        throw Exception("Failed to load customer address");
      }
    } catch (e) {
      print("Error fetching customer address: $e");
      throw Exception("Error fetching customer address");
    }
  }

  static Future<List<Discount>> fetchMaGiamGiaResponse() async {
    try {
      final url = Uri.parse(
        "${ApiService.UrlHien}discount/get?limit=100&page=1",
      );
      final response = await http.get(
        url,
        // headers: {'Authorization': 'Bearer ${ApiService.token}'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final discount = jsonData['result']['discounts'] as List;

        return discount.map((address) => Discount.fromJson(address)).toList();
      } else {
        throw Exception("Failed to load discount");
      }
    } catch (e) {
      print("Error fetching discount: $e");
      throw Exception("Error fetching discount");
    }
  }

  static Future<Map<String, dynamic>> postOrderResponse(
    Map<String, Object> body,
  ) async {
    try {
      final accessToken = await AuthStorage.getRefreshToken();
      if (accessToken == null) throw Exception('Access token is null');
      final url = Uri.parse("${ApiService.UrlHien}order/create");
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);

        // Kiểm tra xem có payUrl trong kết quả không
        if (jsonData['result'] != null &&
            jsonData['result']['payUrl'] != null) {
          return {
            'success': true,
            'payUrl': jsonData['result']['payUrl'],
            'message': 'Chuyển hướng đến trang thanh toán',
          };
        } else {
          return {'success': true, 'message': 'Đặt hàng thành công'};
        }
      } else {
        throw Exception("Failed to create order");
      }
    } catch (e) {
      print("Error post create order: $e");
      throw Exception("Error post create order");
    }
  }

  // // Lọc sản phẩm theo danh mục (category_id) và giá
  // static Future<List<Product>> filterProducts(
  //   String categoryId,
  //   double minPrice,
  //   double maxPrice,
  // ) async {
  //   try {
  //     final url = Uri.parse(
  //       "$baseUrl/$categoryId?min_price=$minPrice&max_price=$maxPrice",
  //     );
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body);
  //       return data.map((e) => Product.fromJson(e)).toList();
  //     } else {
  //       throw Exception("Failed to load filtered products");
  //     }
  //   } catch (e) {
  //     print("Error fetching filtered products: $e");
  //     throw Exception("Error fetching filtered products");
  //   }
  // }

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
    return '${ApiService.UrlHien}media/products?id=$imagePath';
  }

  static Future<String> getAvt(String imagePath) async {
    return '${ApiService.UrlHien}media/products?id=$imagePath';
  }
  // Hàm fetch sản phẩm theo categoryId
  // static Future<List<Product>> fetchProductsByCategory(
  //   String categoryId,
  // ) async {
  //   try {
  //     final url = Uri.parse("$baseUrl/$categoryId");
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       // Nếu API trả về danh sách ở data['result'] hoặc data['products'] thì sửa lại cho đúng
  //       final List productsData =
  //           data is List ? data : (data['result'] ?? data['products'] ?? []);
  //       return productsData.map((e) => Product.fromJson(e)).toList();
  //     } else {
  //       throw Exception("Failed to load products by category");
  //     }
  //   } catch (e) {
  //     print("Error fetching products by category: $e");
  //     throw Exception("Error fetching products by category");
  //   }
  // }

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
