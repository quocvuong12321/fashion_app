import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Category.dart';  
import 'api_Services.dart';

class Request_Category {
  // Request_Category(); // Constructor riêng tư để không thể tạo đối tượng từ bên ngoài
  // URL của API để lấy danh mục
  static final String baseUrl = ApiService.UrlHien + "categories/get";

  // Hàm fetch danh mục từ API
  static Future<List<Category>> fetchCategories() async {
    try {
      final url = "${ApiService.UrlHien}categories/get";
      print("Fetching categories from URL: $url");
      
      final response = await http.get(Uri.parse(url));
      print("Categories API Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("Decoded data: $data");
        
        if (data.containsKey('result') && data['result'] is Map) {
          final result = data['result'] as Map<String, dynamic>;
          if (result.containsKey('categories')) {
            final List<dynamic> categoriesData = result['categories'];
            return categoriesData.map((category) => Category.fromJson(category)).toList();
          }
        }
        throw Exception('Invalid response format: missing result.categories field');
      } else {
        throw Exception('Failed to load categories. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      throw Exception('Error fetching categories: $e');
    }
  }

  //Hàm fetch subcategories theo parent category ID
  static Future<List<Category>> fetchSubcategories(String parentId) async {
    try {
      final url = "${ApiService.UrlHien}categories/get?cate_id=$parentId";
      print("Fetching subcategories from URL: $url");
      
      final response = await http.get(Uri.parse(url));
      print("Subcategories API Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("Decoded subcategories data: $data");
        
        if (data.containsKey('result') && data['result'] is Map) {
          final result = data['result'] as Map<String, dynamic>;
          if (result.containsKey('categories')) {
            final List<dynamic> categoriesData = result['categories'];
            return categoriesData.map((category) => Category.fromJson(category)).toList();
          }
        }
        throw Exception('Invalid response format: missing result.categories field');
      } else {
        throw Exception('Failed to load subcategories. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      throw Exception('Error fetching subcategories: $e');
    }
  }
}
