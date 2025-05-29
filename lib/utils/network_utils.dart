// This file contains utility functions for network operations and error handling
import 'package:flutter/material.dart';

import '../model/Product.dart';
import '../model/Product_Detail.dart';
import '../utils/fake_products.dart';

class NetworkUtils {
  /// Shows a snackbar notification when fake data is being used
  static void showFakeDataNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang hiển thị dữ liệu giả do lỗi kết nối'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Checks if the given list of products contains fake data
  static bool containsFakeData(List<Product> products) {
    return products.any((product) => product.productSpuId.startsWith('fake_'));
  }

  /// Checks if the product detail is fake data
  static bool isFakeProductDetail(ProductDetail productDetail) {
    return productDetail.spu.productsSpuId.startsWith('fake_');
  }

  /// Gets fake products filtered by category ID
  static List<Product> getFakeProductsByCategory(String categoryId) {
    return FakeProducts.generateFakeProducts()
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  /// Gets fake products filtered by price range
  static List<Product> getFakeProductsByPriceRange(double minPrice, double maxPrice) {
    return FakeProducts.generateFakeProducts()
        .where((product) => 
            product.price >= minPrice &&
            product.price <= maxPrice)
        .toList();
  }
}
