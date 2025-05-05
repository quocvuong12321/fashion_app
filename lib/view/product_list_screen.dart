import 'package:fashionshop_app/view/filter_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../view/product_card.dart';
import 'sort_bottom.dart';
import 'filter_bottom.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_detail.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi fetchProducts() một lần khi widget khởi tạo
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    final isLoading = productProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Product",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (products.isEmpty)
            const Center(child: Text("Không có sản phẩm"))
          else
            GridView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(productSpuId: product.productSpuId),
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
            child: Center(child: SortFilterBar()),
          ),
        ],
      ),
    );
  }
}

//thanh sort và filter
class SortFilterBar extends StatelessWidget {
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
            onPressed: () => SortBottom.show(context),
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
            onPressed: () => FilterBottom.show(context),
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
