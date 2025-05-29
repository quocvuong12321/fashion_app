import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/RequestAPI/Request_Product.dart';
import '../RequestAPI/api_Services.dart';
import '../model/Product.dart';
import 'product_list/filter_bottom.dart';
import 'product_list/product_card.dart';
import 'product_list/product_detail.dart';
import 'product_list/sort_bottom.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  const ProductListScreen({required this.categoryId, super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String selectedCategoryName = "";
  bool isLoading = true;
  bool isFiltering = false;
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Hàm xử lý sắp xếp sản phẩm
  void _handleSort(List<Product> sortedProducts) {
    setState(() {
      filteredProducts = sortedProducts;
    });
  }

  // Hàm lấy tên danh mục
  Future<void> fetchCategoryName() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiService.UrlVuong}categories/get?cate_id=${widget.categoryId}",
        ),
      ); // Sử dụng ApiService để gọi API lấy tên danh mục
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          selectedCategoryName = data[0]['name']; // Lấy tên danh mục
        });
      } else {
        print("Error fetching category name");
      }
    } catch (e) {
      print("Error fetching category name: $e");
    }
  }

  Future<void> fetchProducts() async {
    try {
      final productList = await Request_Products.fetchProducts();
      
      // Kiểm tra xem có đang sử dụng dữ liệu giả hay không
      bool usingFakeData = productList.any((product) => product.productSpuId.startsWith('fake_'));
      
      setState(() {
        products = productList;
        filteredProducts = List.from(
          products,
        ); // Ban đầu chưa lọc gì, hiển thị tất cả sản phẩm
        isLoading = false;
        
        // Nếu đang sử dụng dữ liệu giả, hiển thị thông báo snackbar
        if (usingFakeData && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đang hiển thị dữ liệu sản phẩm giả do lỗi kết nối'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm lọc sản phẩm theo danh mục và giá
  void filterProducts(
    List<String> selectedCategories,
    double minPrice,
    double maxPrice,
  ) async {
    setState(() {
      isFiltering = true;
    });

    try {
      List<Product> fetched = [];
      if (selectedCategories.isNotEmpty) {
        // Fetch products for each selected category
        for (String categoryId in selectedCategories) {
          final categoryProducts =
              await Request_Products.fetchProductsByCategory(categoryId);
          fetched.addAll(categoryProducts);
        }
      } else {
        fetched = await Request_Products.fetchProducts();
      }

      setState(() {
        filteredProducts =
            fetched.where((product) {
              final matchesPrice =
                  product.price >= minPrice && product.price <= maxPrice;
              return matchesPrice;
            }).toList();
        isFiltering = false;
      });
    } catch (e) {
      print("Error filtering products: $e");
      setState(() {
        isFiltering = false;
      });
    }
  }

  // Hàm sắp xếp sản phẩm theo giá tăng dần
  void sortByPriceAscending() {
    setState(() {
      filteredProducts = Request_Products.sortByPrice(
        List.from(filteredProducts),
        true,
      );
    });
  }

  // Hàm sắp xếp sản phẩm theo giá giảm dần
  void sortByPriceDescending() {
    setState(() {
      filteredProducts = Request_Products.sortByPrice(
        List.from(filteredProducts),
        false,
      );
    });
  }

  // Hàm sắp xếp sản phẩm theo đánh giá cao nhất
  void sortByRating() {
    setState(() {
      filteredProducts = Request_Products.sortByRating(
        List.from(filteredProducts),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product List ${selectedCategoryName.isEmpty ? '' : selectedCategoryName}",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),

      body: Stack(
        children: [
          if (isLoading || isFiltering)
            const Center(
              child: Text(
                "Đang tải dữ liệu, vui lòng đợi...",
                style: TextStyle(fontSize: 16),
              ),
            )
          else if (filteredProducts.isEmpty)
            const Center(
              child: Text(
                "Không có sản phẩm nào thuộc danh mục này!",
                style: TextStyle(fontSize: 16),
              ),
            )
          else
            GridView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductDetailScreen(
                              productSpuId: product.productSpuId,
                            ),
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            ),
          // Sort & Filter Button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SortFilterBar(
                onSort: _handleSort,
                products: filteredProducts,
                onFilter: () async {
                  final result = await FilterBottom.show(context);
                  if (result != null) {
                    final selectedCategories =
                        result['selectedCategories'] as List<String>;
                    final minPrice = result['minPrice'] as double;
                    final maxPrice = result['maxPrice'] as double;
                    filterProducts(selectedCategories, minPrice, maxPrice);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//thanh sort và filter
class SortFilterBar extends StatelessWidget {
  final Function(List<Product>) onSort;
  final List<Product> products;
  final VoidCallback onFilter;

  const SortFilterBar({
    Key? key,
    required this.onSort,
    required this.products,
    required this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nút Sort
          TextButton.icon(
            onPressed: () => SortBottom.show(context, products, onSort),
            icon: Icon(Icons.swap_vert, size: 20, color: Colors.black),
            label: Text(
              "Sort",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),

          // Đường kẻ ngăn cách
          Container(
            height: 20,
            width: 1,
            color: Colors.black26,
            margin: EdgeInsets.symmetric(horizontal: 5),
          ),

          // Nút Filter
          TextButton.icon(
            onPressed: onFilter,
            icon: Icon(Icons.tune, size: 20, color: Colors.black),
            label: Text(
              "Filter",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }
}
