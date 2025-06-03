import 'package:fashionshop_app/main.dart';
import 'package:fashionshop_app/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'product_list/product_card.dart';
import 'product_list/sort_bottom.dart';
import 'product_list/filter_bottom.dart';
import '../model/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_list/product_detail.dart';
import '/RequestAPI/Request_Product.dart';
import '../RequestAPI/api_Services.dart';
import '../model/products_respone.dart';

class ProductListScreen extends StatefulWidget {
  final String? categoryId; // Cho phép null
  const ProductListScreen({this.categoryId, super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _currentCategoryId; // Thay vì sửa widget.categoryId
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String selectedCategoryName = "";
  bool isFiltering = false;
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _currentCategoryId = widget.categoryId;
    fetchProducts(1, limit);

    _scrollController.addListener(() {
      print(
        '==> Listener: currentPage: $currentPage, totalPages: $totalPages, isFiltering: $isFiltering',
      );
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          currentPage < totalPages &&
          !isFiltering) {
        final nextPage = currentPage + 1;
        print(
          '==> SCROLL GỌI fetchProducts với page: $nextPage, currentPage hiện tại: $currentPage',
        );
        fetchProducts(nextPage, limit);
      }
    });
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

  Future<void> fetchProducts(int page, int limit) async {
    print(
      '==> fetchProducts gọi với page: $page, _currentCategoryId: $_currentCategoryId',
    );
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Request_Products.fetchProductsResponse(
        page: page,
        limit: limit,
        categoryId: _currentCategoryId,
      );
      setState(() {
        if (page == 1) {
          products = response.products;
        } else {
          products.addAll(response.products);
        }
        filteredProducts = List.from(products);
        totalPages = response.totalPages;
        currentPage = page;
      });
    } catch (e, s) {
      print("Lỗi khi fetchProducts: $e");
      print("Stack trace: $s");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    print(
      'Sau fetchProducts: products.length = ${products.length}, currentPage = $currentPage',
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Hàm lọc sản phẩm theo danh mục và giá
  void filterProducts(
    List<String> selectedCategories,
    double minPrice,
    double maxPrice,
  ) async {
    if (selectedCategories.length == 1) {
      setState(() {
        isFiltering = false;
        _currentCategoryId = selectedCategories.first;
        currentPage = 1; // luôn reset về trang đầu
        totalPages = 1;
        products = []; // reset danh sách sản phẩm
      });
      fetchProducts(1, limit); // luôn gọi lại trang 1
    } else if (selectedCategories.isEmpty) {
      setState(() {
        isFiltering = false;
        _currentCategoryId = null;
        currentPage = 1;
        totalPages = 1;
        products = [];
      });
      fetchProducts(1, limit); // luôn gọi lại trang 1
    } else {
      // Nếu chọn nhiều danh mục, chỉ filter local, không phân trang
      setState(() {
        isFiltering = true;
        products = [];
        currentPage = 1;
        totalPages = 1;
      });
      print('Filter/Sắp xếp, reset products');
      try {
        List<Product> fetched = [];
        for (String categoryId in selectedCategories) {
          final categoryProducts =
              await Request_Products.fetchProductsByCategory(categoryId);
          fetched.addAll(categoryProducts);
        }
        setState(() {
          filteredProducts = fetched
              .where(
                (product) =>
                    product.price >= minPrice && product.price <= maxPrice,
              )
              .toList();
        });
      } catch (e) {
        print("Error filtering products: $e");
        setState(() {
          isFiltering = false;
        });
      }
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
      ),

      body: Stack(
        children: [
          if ((isLoading && products.isEmpty) || isFiltering)
            Center(
              child: Text(
                "Đang tải dữ liệu, vui lòng đợi...",
                style: TextStyle(fontSize: 16),
              ),
            )
          else if (filteredProducts.isEmpty)
            Center(
              child: Text(
                "Không có sản phẩm nào thuộc danh mục này!",
                style: TextStyle(fontSize: 16),
              ),
            )
          else
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 80),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                    itemCount:
                        filteredProducts.length +
                        (isLoading && currentPage <= totalPages && !isFiltering
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredProducts.length) {
                        return Center(child: CircularProgressIndicator());
                      }
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
                ),
              ],
            ),
          Positioned(
            bottom: 20, // hoặc lớn hơn chiều cao của BottomNavigationBar
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
