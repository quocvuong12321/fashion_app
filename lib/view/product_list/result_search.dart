import 'package:fashionshop_app/model/Product.dart';
import 'package:fashionshop_app/view/product_list/product_card.dart';
import 'package:fashionshop_app/view/product_list/product_detail.dart';
import 'package:flutter/material.dart';

class ResultSearch extends StatefulWidget {
  final List<Product> products;
  const ResultSearch({super.key, required this.products});

  @override
  State<ResultSearch> createState() => ResultSearchState();
}

class ResultSearchState extends State<ResultSearch> {
  @override
  Widget build(BuildContext context) {
    final List<Product> products = widget.products;

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả tìm kiếm')),
      body:
          products.isEmpty
              ? const Center(child: Text("Không tìm thấy sản phẩm nào"))
              : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 sản phẩm mỗi hàng
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.5, // Tỉ lệ chiều rộng/cao cho thẻ
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final Product product = products[index];
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
}
