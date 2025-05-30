import 'dart:async';
import 'package:flutter/material.dart';
import '../model/Product.dart';
import '../view/product_list/product_card.dart';
import '../RequestAPI/Token.dart';
// import '../RequestAPI/request_product.dart';
import '../RequestAPI/Request_Product.dart';
import 'product_list/product_detail.dart';

class Home_Screen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _loading = true;

  Map<String, String?>? _userInfo; // Thông tin người dùng từ Token
  late TextEditingController _searchController; // Controller cho ô tìm kiếm
  String _searchQuery = '';

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  // Danh sách ảnh banner quảng cáo
  final List<String> _bannerImages = [
    'https://intphcm.com/data/upload/banner-thoi-trang-tuoi.jpg',
    'https://intphcm.com/data/upload/banner-thoi-trang.jpg',
    'https://upcontent.vn/wp-content/uploads/2024/06/banner-shop-thoi-trang-4.jpg',
    'https://intphcm.com/data/upload/dung-luong-banner-thoi-trang.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _searchQuery);
    _pageController = PageController(initialPage: 0);

    // Theo dõi thay đổi của trang trong PageView
    _pageController.addListener(() {
      if (_pageController.page != null) {
        _currentPage = _pageController.page!.round();
      }
    });

    _startAutoSlide(); // Khởi động slide banner tự động
    _loadUserInfo(); // Lấy thông tin người dùng
    _loadData(); // Gọi API để lấy danh sách sản phẩm
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Tự động chuyển banner mỗi 4 giây
  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int totalPages = _bannerImages.length;
        int nextPage = (_currentPage + 1) % totalPages;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _currentPage = nextPage;
      }
    });
  }

  // Lấy thông tin người dùng từ Token
  Future<void> _loadUserInfo() async {
    final data = await AuthStorage.getUserInfo();
    if (!mounted) return;
    setState(() {
      _userInfo = data;
    });
  }

  // Gọi API để lấy danh sách sản phẩm
  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });
    try {
      final allProducts = await Request_Products.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = allProducts;
        _filteredProducts = allProducts;
        _loading = false;
      });
    } catch (e) {
      print("Lỗi khi tải sản phẩm: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  // Hàm xử lý khi nhập vào ô tìm kiếm
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts =
          _searchQuery.isEmpty
              ? _products
              : _products
                  .where(
                    (p) => p.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();
    });
  }

  // Giao diện danh sách sản phẩm theo dạng lưới
  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return const Center(child: Text('Không có sản phẩm'));
    }
    return Expanded(
      child: GridView.builder(
        // padding: const EdgeInsets.only(bottom: 80),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return GestureDetector(
            onTap: () {
              // Mở trang chi tiết sản phẩm nếu cần
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _userInfo?['image'];
    final name = _userInfo?['name'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fashionista',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                // Ảnh đại diện người dùng
                if (imageUrl != null && imageUrl.isNotEmpty)
                  CircleAvatar(backgroundImage: NetworkImage(imageUrl))
                else
                  const Icon(Icons.account_circle, size: 30),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),

      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Hiển thị loading khi đang tải
              : Column(
                children: [
                  // Ô tìm kiếm sản phẩm
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm sản phẩm...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),

                  // Banner quảng cáo dạng slider tự động
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PageView(
                        controller: _pageController,
                        children:
                            _bannerImages
                                .map(
                                  (url) =>
                                      Image.network(url, fit: BoxFit.cover),
                                )
                                .toList(),
                      ),
                    ),
                  ),

                  // Tiêu đề phần sản phẩm nổi bật
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ShaderMask(
                        shaderCallback:
                            (bounds) => const LinearGradient(
                              colors: [Colors.pinkAccent, Colors.orangeAccent],
                            ).createShader(bounds),
                        child: const Text(
                          '🌟 Sản phẩm nổi bật',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1.5, 1.5),
                                blurRadius: 3,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Danh sách sản phẩm
                  Expanded(child: _buildProductGrid()),
                ],
              ),
    );
  }
}
