import 'dart:convert';
import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import '../model/Order.dart';

class Request_Order {
  Request_Order._();

  static Future<List<Order>> fetchOrders(String accessToken) async {
    try {
      final response = await ApiService.get(
        //Ví dụ gọi service api. do dùng baseurl mặc định nên ko cần truyền
        'order/myorder', //đứa nào gọi api của t thì gán baseurl của t là dc: baseUrl = UrlVuong
        token: accessToken,
      );

      final decoded = jsonDecode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final ordersData = decoded['result']?['orders'];
      if (ordersData == null || ordersData is! List) {
        return [];
      }
      return ordersData.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Failed to load orders');
    }
  }

  static String getImage(String imagePath) {
    return '${ApiService.UrlHien}media/products?id=$imagePath';
  }

  static String getImageAVT(String imagePath) {
    return '${ApiService.UrlHien}media/avatar/$imagePath';
  }
}
