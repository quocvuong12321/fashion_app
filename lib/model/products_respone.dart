import 'Product.dart';

class ProductResponse {
  final List<Product> products;
  final int totalPages;
  final int currentPage;

  ProductResponse({
    required this.products,
    required this.totalPages,
    required this.currentPage,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List;
    final productsList = productsJson.map((e) => Product.fromJson(e)).toList();
    return ProductResponse(
      products: productsList,
      totalPages: json['total_pages'] ?? 1,
      currentPage: json['current_page'],
    );
  }
}
