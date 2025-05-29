import 'package:flutter/material.dart';
import '../../RequestAPI/Request_Product.dart';
import '../../model/Product.dart';

enum SortOption { topRated, priceLowToHigh, priceHighToLow, nameAZ }

class SortBottom extends StatefulWidget {
  final List<Product> products;
  final Function(List<Product>) onSort;

  const SortBottom({
    super.key,
    required this.products,
    required this.onSort,
  });

  static void show(BuildContext context, List<Product> products, Function(List<Product>) onSort) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SortBottom(
        products: products,
        onSort: onSort,
      ),
    );
  }

  @override
  State<SortBottom> createState() => _SortBottomState();
}

class _SortBottomState extends State<SortBottom> {
  SortOption? selectedOption = SortOption.topRated;

  void _handleSort(SortOption option) {
    setState(() => selectedOption = option);
    List<Product> sortedProducts = List.from(widget.products);

    switch (option) {
      case SortOption.topRated:
        sortedProducts = Request_Products.sortByRating(sortedProducts);
        break;
      case SortOption.priceHighToLow:
        sortedProducts = Request_Products.sortByPrice(sortedProducts, false);
        break;
      case SortOption.priceLowToHigh:
        sortedProducts = Request_Products.sortByPrice(sortedProducts, true);
        break;
      case SortOption.nameAZ:
        sortedProducts = Request_Products.sortByName(sortedProducts);
        break;
    }

    widget.onSort(sortedProducts);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thanh kéo ở trên cùng
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Text(
            "Sắp xếp",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),
          const Divider(),

          // Danh sách các lựa chọn sort
          ...SortOption.values.map((option) {
            return RadioListTile<SortOption>(
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                if (value != null) {
                  _handleSort(value);
                }
              },
              title: Text(_getOptionLabel(option)),
              activeColor: const Color.fromARGB(255, 91, 137, 92),
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  String _getOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.topRated:
        return "Đánh giá cao nhất";
      case SortOption.priceHighToLow:
        return "Giá giảm dần";
      case SortOption.priceLowToHigh:
        return "Giá tăng dần";
      case SortOption.nameAZ:
        return "Tên A-Z";
    }
  }
}
