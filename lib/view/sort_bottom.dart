import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

enum SortOption { topRated, priceLowToHigh, priceHighToLow }

class SortBottom extends StatefulWidget {
  const SortBottom({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SortBottom(),
    );
  }

  @override
  State<SortBottom> createState() => _SortBottomState();
}

class _SortBottomState extends State<SortBottom> {
  SortOption? selectedOption = SortOption.topRated;

  void _handleSort(SortOption option, ProductProvider provider) {
    setState(() => selectedOption = option);

    switch (option) {
      case SortOption.topRated:
        provider.sortByRating();
        break;
      case SortOption.priceHighToLow:
        provider.sortByPriceDescending();
        break;
      case SortOption.priceLowToHigh:
        provider.sortByPriceAscending();
        break;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
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
                "Sort",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                      _handleSort(value, productProvider);
                    }
                  },
                  title: Text(_getOptionLabel(option)),
                  activeColor: Colors.green,
                  contentPadding: EdgeInsets.zero,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.topRated:
        return "Đánh giá";
      case SortOption.priceHighToLow:
        return "Giá giảm dần";
      case SortOption.priceLowToHigh:
        return "Giá tăng dần";
    }
  }
}
// class SortBottom extends StatelessWidget {
//   const SortBottom({super.key});
//   static void show(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => const SortBottom(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductProvider>(
//       builder: (context, productProvider, child) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Sort",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               ListTile(
//                 title: const Text("Giá tăng dần"),
//                 onTap: () {
//                   productProvider.sortByPriceAscending();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text("Giá giảm dần"),
//                 onTap: () {
//                   productProvider.sortByPriceDescending();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text("Đánh giá cao nhất"),
//                 onTap: () {
//                   productProvider.sortByRating();
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text("Tên (A-Z)"),
//                 onTap: () {
//                   productProvider.sortByName();
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
