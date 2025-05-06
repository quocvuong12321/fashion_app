import 'dart:convert';
import 'package:fashionshop_app/RequestAPI/config.dart';
import 'package:http/http.dart' as http;
import '../model/Order.dart';
import 'dart:typed_data';

class Request_Order {
  Request_Order._();

  static const String getUrl = Config.apiOrder;

  static Future<List<Order>> fetchOrders(String accessToken) async {
    final url = Uri.parse(getUrl);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final ordersData = decoded['result']?['orders'];

      if (ordersData == null || ordersData is! List) {
        return [];
      }

      // final List<dynamic> data = decoded['data'];
      return ordersData.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<Uint8List?> fetchProtectedImage({
    required String relativePath,
    required String accessToken,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8080/v1/$relativePath');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Failed to load image: ${response.statusCode}');
      return null;
    }
  }
}
