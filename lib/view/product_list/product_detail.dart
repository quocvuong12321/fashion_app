import 'package:fashionshop_app/RequestAPI/auth_guard.dart';
import 'package:fashionshop_app/model/Product_Detail.dart';
import 'package:fashionshop_app/model/Product_In_pay.dart';
import 'package:fashionshop_app/view/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../RequestAPI/Request_Product_Detail.dart';
import 'package:fashionshop_app/view/product_list/product_image.dart';
import 'package:collection/collection.dart';
import 'product_rating.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart'; // Đảm bảo import đúng

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
  bool showFullDescription = false; // Biến trạng thái cho mô tả

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  // Hàm parse media nếu media là chuỗi
  List<String> parseMedia(dynamic media) {
    if (media is String) {
      return (media)
          .replaceAll(RegExp(r"[\[\]']"), "")
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (media is List) return List<String>.from(media);
    return [];
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

  // void showVariantBottomSheet(bool isBuyNow, BuildContext parentContext) async {
  //   navigateToPayment(createPaymentProducts());
  //   // if (!await launchUrl(url)) {
  //   //   throw Exception('Could not launch $url');
  //   // }
  // }

  // Ví dụ từ trang giỏ hàng hoặc trang chi tiết sản phẩm
  void navigateToPayment(List<Products_In_pay> products) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder:
            (context) => AuthGuard(child: PaymentScreen(products: products)),
      ),
    );
  }

  // Ví dụ tạo danh sách sản phẩm để thanh toán
  List<Products_In_pay> createPaymentProducts(
    String productSkuId,
    int amount,
    double price,
    String skuString,
  ) {
    return [
      Products_In_pay(
        productsSpuId: productDetail!.spu.productSpuId,
        name: productDetail!.spu.name,
        image: productDetail!.spu.image,
        key: productDetail!.spu.key,
        productSkuId: productSkuId,
        amount: amount,
        price: price,
        skuString: skuString,
      ),
    ];
  }

  void showVariantBottomSheet(bool isBuyNow, BuildContext parentContext) {
    final product = productDetail!.spu;
    final uniqueAttrNames =
        productDetail!.skuAttrs.map((attr) => attr.name).toSet().toList();

    // Biến lưu lựa chọn từng thuộc tính (KHÔNG gán mặc định)
    Map<String, String?> selectedValues = {};
    Map<String, String?> selectedAttrIds = {};
    // Không gán giá trị mặc định, để tất cả là null
    for (var attrName in uniqueAttrNames) {
      selectedValues[attrName] = null;
      selectedAttrIds[attrName] = null;
    }
    print("Initial selectedValues: $selectedValues");
    print("Initial selectedAttrIds: $selectedAttrIds");

    // Biến lưu số lượng sản phẩm, giá hiện tại và số lượng còn lại

    int quantity = 1;
    int stockAvailable = 0;
    double currentPrice = product.price;

    String findProductSKUID() {
      final selectedIds =
          selectedAttrIds.values
              .where((id) => id != null && id.isNotEmpty)
              .cast<String>()
              .toList();
      selectedIds.sort();
      final listEquality = const ListEquality<String>();

      final match = productDetail!.skus.firstWhere(
        (sku) {
          final parts = sku.value.split('/')..sort();
          return listEquality.equals(parts, selectedIds);
        },
        orElse:
            () => ProductSku(
              productSkuId: '',
              productSpuId: '',
              value: '',
              price: product.price,
              skuStock: 0,
              sort: 0,
            ),
      );
      return match.productSkuId;
    }

    void updateStockAndPrice(StateSetter setModalState) {
      final selectedIds =
          selectedAttrIds.values
              .where((id) => id != null && id.isNotEmpty)
              .cast<String>()
              .toList();
      selectedIds.sort();
      final listEquality = const ListEquality<String>();

      final match = productDetail!.skus.firstWhere(
        (sku) {
          final parts = sku.value.split('/')..sort();
          return listEquality.equals(parts, selectedIds);
        },
        orElse:
            () => ProductSku(
              productSkuId: '',
              productSpuId: '',
              value: '',
              price: product.price,
              skuStock: 0,
              sort: 0,
            ),
      );

      setModalState(() {
        stockAvailable = match.skuStock;
        currentPrice = match.price;
        if (quantity > stockAvailable) {
          quantity = stockAvailable;
        }
        ;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool hasUpdatedInitialStock = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Cập nhật stock và giá lần đầu khi modal build xong
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!hasUpdatedInitialStock) {
                hasUpdatedInitialStock = true;
                updateStockAndPrice(setModalState);
              }
            });

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: ProductImage(
                              imagePath:
                                  product.media.isNotEmpty
                                      ? product.media[0]
                                      : product.image,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),

                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ',
                                ).format(currentPrice),
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Kho: $stockAvailable",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Tự động tạo dropdown cho mỗi tên thuộc tính duy nhất
                    ...uniqueAttrNames.map((attrName) {
                      // Lấy tất cả các giá trị (và ProductSkuAttrId tương ứng) cho tên thuộc tính này
                      final options =
                          productDetail!.skuAttrs
                              .where((e) => e.name == attrName)
                              .toList();
                      final selectedValue = selectedValues[attrName];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(attrName),
                            SizedBox(height: 8),
                            Align(
                              alignment:
                                  Alignment
                                      .centerLeft, // Canh lề trái cho các chip
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    options.map((option) {
                                      final isSelected =
                                          option.value == selectedValue;
                                      Map<String, String?> tempSelectedAttrIds =
                                          Map.from(selectedAttrIds);
                                      tempSelectedAttrIds[attrName] =
                                          option.productSkuAttrId;

                                      // Lọc các SKU thỏa mãn tất cả lựa chọn trong tempSelectedAttrIds (bỏ null, rỗng)
                                      final matchedSkus =
                                          productDetail!.skus.where((sku) {
                                            for (var entry
                                                in tempSelectedAttrIds
                                                    .entries) {
                                              final selId = entry.value;
                                              if (selId != null &&
                                                  selId.isNotEmpty) {
                                                if (!sku.value
                                                    .split('/')
                                                    .contains(selId))
                                                  return false;
                                              }
                                            }
                                            return true;
                                          }).toList();
                                      final isOutOfStock = matchedSkus.every(
                                        (sku) => sku.skuStock == 0,
                                      );

                                      // final isOutOfStock = sku.skuStock == 0;

                                      return RawChip(
                                        label: Text(option.value),
                                        selected: isSelected,
                                        showCheckmark:
                                            false, // Thêm dòng này để ẩn dấu tick
                                        onSelected:
                                            isOutOfStock
                                                ? null
                                                : (selected) {
                                                  setModalState(() {
                                                    if (selected) {
                                                      selectedValues[attrName] =
                                                          option.value;
                                                      selectedAttrIds[attrName] =
                                                          option
                                                              .productSkuAttrId;
                                                    } else {
                                                      selectedValues[attrName] =
                                                          null;
                                                      selectedAttrIds[attrName] =
                                                          null;
                                                    }
                                                    updateStockAndPrice(
                                                      setModalState,
                                                    );
                                                  });
                                                },
                                        selectedColor: const Color.fromARGB(
                                          255,
                                          102,
                                          150,
                                          102,
                                        ),
                                        backgroundColor:
                                            isOutOfStock
                                                ? Colors.grey[300]
                                                : Colors.white,
                                        labelStyle: TextStyle(
                                          color:
                                              isOutOfStock
                                                  ? Colors.grey
                                                  : isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        side: BorderSide(
                                          color:
                                              isOutOfStock
                                                  ? Colors.grey
                                                  : isSelected
                                                  ? Color.fromARGB(
                                                    255,
                                                    102,
                                                    150,
                                                    102,
                                                  )
                                                  : Colors.grey,
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Số lượng"),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed:
                                  quantity > 1
                                      ? () => setModalState(() {
                                        quantity--;
                                      })
                                      : null,
                            ),
                            Text("$quantity"),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed:
                                  quantity < stockAvailable
                                      ? () => setModalState(() {
                                        quantity++;
                                      })
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
                            Color.fromARGB(
                              255,
                              102,
                              150,
                              102,
                            ), // luôn dùng màu xanh
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white, // luôn dùng màu chữ trắng
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
                          if (stockAvailable == 0) {
                            Navigator.pop(
                              context,
                            ); // Đóng bottom sheet khi hết hàng
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Sản phẩm đã hết hàng, vui lòng chọn sản phẩm khác",
                                ),
                              ),
                            );
                            return;
                          }

                          if (quantity <= 0) {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text("Số lượng phải lớn hơn 0"),
                              ),
                            );
                            Navigator.pop(context);
                            return;
                          }

                          // Kiểm tra đủ lựa chọn phân loại
                          bool allSelected = productDetail!.skuAttrs.every(
                            (attr) => selectedValues[attr.name] != null,
                          );
                          if (!allSelected) {
                            Navigator.pop(
                              context,
                            ); // Đóng bottom sheet khi thiếu phân loại
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text("Vui lòng chọn đủ phân loại"),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(
                            context,
                          ); // Đóng bottom sheet khi đặt hàng thành công
                          String selectedOptions = selectedValues.entries
                              .map((e) => "${e.key}: ${e.value}")
                              .join(", ");

                          if (isBuyNow) {
                            String skuID = findProductSKUID();
                            print("Mua ngay $quantity x $selectedOptions");
                            print("Product SKU ID: $skuID");
                            navigateToPayment(
                              createPaymentProducts(
                                skuID,
                                quantity,
                                currentPrice,
                                selectedOptions,
                              ),
                            );
                          } else {
                            // THÊM VÀO GIỎ HÀNG TOÀN CỤC
                            final cartProvider = Provider.of<CartProvider>(
                              parentContext,
                              listen: false,
                            );
                            cartProvider.addItem(
                              productSkuId: findProductSKUID(),
                              productName: productDetail!.spu.name,
                              image: productDetail!.spu.image,
                              price: currentPrice,
                              quantity: quantity,
                              selectedAttributes: selectedOptions,
                              // Thêm các trường khác nếu cần
                            );
                            setState(() {
                              cartItemCount = cartProvider.items.length;
                            });
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã thêm $quantity sản phẩm vào giỏ hàng thành công!',
                                ),
                                duration: Duration(seconds: 2),
                              ),
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
    // final ratings = productDetail!.ratings;

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
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.all(0),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: InteractiveViewer(
                                            child: ProductImage(
                                              imagePath: mediaList[index],
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 30,
                                          right: 30,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          child: ProductImage(
                            imagePath: mediaList[index],
                            width: double.infinity,
                            height: 200,
                          ),
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
            Divider(),
            Text(
              "Mô tả sản phẩm",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Thêm đoạn này thay cho Html(data: product.description),
            Builder(
              builder: (context) {
                final plainDescription = product.description.replaceAll(
                  RegExp(r'<[^>]*>|&[^;]+;'),
                  '',
                ); // Loại bỏ thẻ HTML nếu có
                const maxLines = 5;
                final isLong =
                    plainDescription.length > 100 ||
                    '\n'.allMatches(plainDescription).length > maxLines;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedCrossFade(
                      firstChild: Html(
                        data: product.description,
                        style: {
                          "body": Style(
                            maxLines: maxLines,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        },
                      ),
                      secondChild: Html(data: product.description),
                      crossFadeState:
                          showFullDescription
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 200),
                    ),
                    if (isLong)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showFullDescription = !showFullDescription;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                showFullDescription ? "Ẩn bớt" : "Xem thêm",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
            Divider(),
            // Thông tin chi tiết
            Text(
              "Thông tin chi tiết",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Html(data: product.description),
            Divider(),
            ...descriptionAttrs.map(
              (e) => ListTile(title: Text(e.name), subtitle: Text(e.value)),
            ),
            Divider(),
            // Đánh giá
            ProductRating(
              productSpuId: widget.productSpuId,
              // initialRatings: productDetail,
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
                  onPressed:
                      () => showVariantBottomSheet(
                        false,
                        context,
                      ), // truyền context cha
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
                  onPressed: () => showVariantBottomSheet(true, context),
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
