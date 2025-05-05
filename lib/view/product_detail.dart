import 'package:fashionshop_app/model/product_detail.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/product_detail_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../model/product_detail.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productSpuId;

  const ProductDetailScreen({required this.productSpuId, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int cartItemCount = 0;
  List<ProductSPU> relatedProducts = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    provider.fetchProductDetail(widget.productSpuId);
  }

  void incrementCart(int quantity) {
    setState(() {
      cartItemCount += quantity;
    });
  }

  void showVariantBottomSheet(ProductDetailProvider provider, bool isBuyNow) {
    final product = provider.productDetail!.spu;
    final colors = provider.getValuesByAttrName("Màu sắc");
    final sizes = provider.getValuesByAttrName("Kích thước");
    final hasColor = colors.isNotEmpty;
    final hasSize = sizes.isNotEmpty;

    String? selectedColor;
    String? selectedSize;
    int quantity = 1;
    int stockAvailable = 0;

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
                  provider.findSkuAttrIdByValue(
                    "Kích thước",
                    selectedSize ?? "",
                  ),
                if (hasColor)
                  provider.findSkuAttrIdByValue("Màu sắc", selectedColor ?? ""),
              ];
              final skuKey = ids.join('/');

              final match = provider.productDetail!.skus.firstWhere(
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
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "http://192.168.10.111:5000/uploads/${product.image}",
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ',
                                ).format(product.price),
                                style: TextStyle(color: Colors.redAccent),
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
                                ? const Color.fromARGB(255, 102, 150, 102)
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
    final provider = Provider.of<ProductDetailProvider>(context);
    final product = provider.productDetail?.spu;
    final PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(product?.name ?? "Chi tiết sản phẩm"),
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
      body:
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.productDetail == null
              ? Center(child: Text("Không có dữ liệu"))
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            itemCount: product!.media.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                "http://192.168.10.111:5000/uploads/${product.media[index]}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        AnimatedSmoothIndicator(
                          activeIndex: _currentImageIndex,
                          count: product.media.length,
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
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                    Text(
                      "Thông tin chi tiết",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...provider.productDetail!.descriptionAttrs.map(
                      (e) => ListTile(
                        title: Text(e.name),
                        subtitle: Text(e.value),
                      ),
                    ),
                    Divider(),
                    Text(
                      "Đánh giá sản phẩm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(bottom: 12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.productDetail!.ratings.length,
                        itemBuilder: (context, index) {
                          final rating = provider.productDetail!.ratings[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
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

                    Divider(),
                    Text(
                      "Sản phẩm liên quan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        itemBuilder: (context, index) {
                          final related = relatedProducts[index];
                          return Container(
                            width: 160,
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    "http://192.168.10.111:5000/uploads/${related.image}",
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        related.name,
                                        style: TextStyle(fontSize: 14),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'vi_VN',
                                          symbol: 'đ',
                                        ).format(related.price),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                  onPressed: () => showVariantBottomSheet(provider, false),
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
                  onPressed: () => showVariantBottomSheet(provider, true),
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
