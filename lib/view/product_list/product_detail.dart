import 'package:fashionshop_app/model/Product_Detail.dart';
import 'package:flutter/material.dart';
import '../../model/Product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../model/Product_Detail.dart';
import '../../RequestAPI/Request_Product.dart';
import '../../RequestAPI/Request_Product_Detail.dart';
import 'product_card.dart';
import 'package:fashionshop_app/view/product_list/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productSpuId;
  const ProductDetailScreen({required this.productSpuId, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetail? productDetail;
  bool isLoading = true;
  int _currentImageIndex = 0;
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  //   // Hàm parse media nếu media là chuỗi
  List<String> parseMedia(dynamic media) {
    if (media is String) {
      return (media as String)
          .replaceAll(RegExp(r"[\[\]']"), "")
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (media is List) return List<String>.from(media);
    return [];
  }

  //   // Lấy giá trị phân loại theo tên
  List<String> getSkuValuesByName(String name) {
    return productDetail!.skuAttrs
        .where((attr) => attr.name == name)
        .map((attr) => attr.value)
        .toSet()
        .toList();
  }

  String findSkuAttrIdByValue(String attrName, String value) {
    final match = productDetail!.skuAttrs.firstWhere(
      (attr) => attr.name == attrName && attr.value == value,
      orElse: () => SkuAttr(skuAttrId: '', name: '', value: '', image: ''),
    );
    return match.skuAttrId;
  }

  Future<void> fetchProduct() async {
    try {
      final result = await Request_Product_Detail.fetchProductDetail(
        widget.productSpuId,
      );
      setState(() {
        productDetail = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void incrementCart(int quantity) {
    setState(() {
      cartItemCount += quantity;
    });
  }

  void showVariantBottomSheet(bool isBuyNow) {
    final product = productDetail!.spu;
    final colors = getSkuValuesByName("Màu sắc");
    final sizes = getSkuValuesByName("Kích thước");
    final hasColor = colors.isNotEmpty;
    final hasSize = sizes.isNotEmpty;

    String? selectedColor;
    String? selectedSize;
    int quantity = 1;
    int stockAvailable = 0;
    String? selectedColorImage;

    if (selectedColor != null) {
      final colorAttr = productDetail!.skuAttrs.firstWhere(
        (attr) => attr.name == "Màu sắc" && attr.value == selectedColor,
        orElse: () => SkuAttr(skuAttrId: '', name: '', value: '', image: ''),
      );
      if (colorAttr.image.isNotEmpty) {
        selectedColorImage = colorAttr.image;
      }
    }

    final displayImage =
        selectedColorImage != null && selectedColorImage.isNotEmpty
            ? selectedColorImage
            : (product.media.isNotEmpty ? product.media[0] : product.image);

    if (!hasColor && !hasSize && productDetail!.skus.isNotEmpty) {
      stockAvailable = productDetail!.skus[0].skuStock;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void updateStock() {
              final ids = [
                if (hasSize)
                  findSkuAttrIdByValue("Kích thước", selectedSize ?? ""),
                if (hasColor)
                  findSkuAttrIdByValue("Màu sắc", selectedColor ?? ""),
              ];
              final skuKey = ids.join('/');

              final match = productDetail!.skus.firstWhere(
                (sku) => sku.value == skuKey,
                orElse:
                    () => Sku(
                      productSkuId: '',
                      price: 0.0,
                      skuStock: 0,
                      value: '',
                    ),
              );

              setModalState(() {
                stockAvailable = match.skuStock;
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ProductImage(
                            imagePath:
                                displayImage, // Truyền trực tiếp đường dẫn ảnh
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ',
                                ).format(product.price),
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (hasColor || hasSize)
                      Row(
                        children: [
                          if (hasColor)
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text("Chọn màu"),
                                value: selectedColor,
                                items:
                                    colors
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setModalState(() {
                                    selectedColor = value;
                                    updateStock();
                                  });
                                },
                              ),
                            ),
                          if (hasColor && hasSize) SizedBox(width: 8),
                          if (hasSize)
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text("Chọn size"),
                                value: selectedSize,
                                items:
                                    sizes
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setModalState(() {
                                    selectedSize = value;
                                    updateStock();
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Số lượng còn lại: $stockAvailable"),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed:
                                  quantity > 1
                                      ? () => setModalState(() => quantity--)
                                      : null,
                            ),
                            Text("$quantity"),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed:
                                  quantity < stockAvailable
                                      ? () => setModalState(() => quantity++)
                                      : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isBuyNow
                                ? Color.fromARGB(255, 102, 150, 102)
                                : Colors.white,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            isBuyNow
                                ? Colors.white
                                : Color(0xFF28804F), // màu chữ
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 14),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(2),
                        ),
                        onPressed: () {
                          if ((hasColor && selectedColor == null) ||
                              (hasSize && selectedSize == null)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Vui lòng chọn đủ phân loại"),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          if (isBuyNow) {
                            print(
                              "Mua ngay $quantity x $selectedColor - $selectedSize",
                            );
                          } else {
                            print(
                              "Đã thêm vào giỏ $quantity x $selectedColor - $selectedSize",
                            );
                          }
                        },
                        child: Text(
                          isBuyNow ? "Mua ngay" : "Thêm vào giỏ hàng",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (productDetail == null) return Center(child: Text("Không có dữ liệu"));

    final product = productDetail!.spu;
    final mediaList = product.media;
    final descriptionAttrs = productDetail!.descriptionAttrs;
    final ratings = productDetail!.ratings;

    final PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Stack(
            children: [
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
              if (cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm
            if (mediaList.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        return ProductImage(
                          imagePath: mediaList[index],
                          width: double.infinity,
                          height: 200,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentImageIndex,
                    count: mediaList.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.black87,
                      dotColor: Colors.grey[300]!,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            // Tên, giá, mô tả
            Text(
              product.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              NumberFormat.currency(
                locale: 'vi_VN',
                symbol: 'đ',
              ).format(product.price),
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Html(data: product.description),
            Divider(),
            // Thông tin chi tiết
            Text(
              "Thông tin chi tiết",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...descriptionAttrs.map(
              (e) => ListTile(title: Text(e.name), subtitle: Text(e.value)),
            ),
            Divider(),
            // Đánh giá
            Text(
              "Đánh giá sản phẩm",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final rating = ratings[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    rating.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < rating.star
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                rating.comment.isEmpty
                                    ? "(Không có bình luận)"
                                    : rating.comment,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 254, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => showVariantBottomSheet(false),
                  child: Text(
                    "Thêm giỏ hàng",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 40, 128, 79),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 102, 150, 102),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => showVariantBottomSheet(true),
                  child: Text(
                    "Mua ngay",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
