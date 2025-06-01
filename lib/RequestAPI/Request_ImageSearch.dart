import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import 'package:fashionshop_app/model/Product.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class RequestImageSearch {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiService.UrlVuong));
  Future<List<Product>> searchImage(String imagePath) async {
    try {
      String fileName = basename(imagePath);

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      // Giả sử _dio là instance của Dio đã được cấu hình baseUrl, headers,...
      final response = await _dio.post(
        '/products/image-search',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> productList = data['products'];
        return productList.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in searchImage: $e');
      rethrow;
    }
  }
}
