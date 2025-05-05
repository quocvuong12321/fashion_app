import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class FilterBottom extends StatefulWidget {
  const FilterBottom({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterBottom(),
    );
  }

  @override
  State<FilterBottom> createState() => _FilterBottomState();
}

class _FilterBottomState extends State<FilterBottom> {
  // Sample state
  final List<String> selectedCategories = [];
  double minPrice = 50;
  double maxPrice = 250;
  int selectedRating = 3;
  String selectedSize = 'L';
  Color? selectedColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height *
          0.9, // Chiếm 90% chiều cao màn hình
      child: Stack(
        children: [
          // Nội dung filter scrollable
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              100,
            ), // Dư 100px để chừa chỗ cho nút
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  "Filter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategorySection(),
                        _buildPriceSection(),
                        _buildRatingSection(),
                        _buildSizeSection(),
                        _buildColorSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nút Reset và Apply nổi cố định
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,

            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(12),
                    ),

                    onPressed: () {
                      setState(() {
                        selectedCategories.clear();
                        minPrice = 50;
                        maxPrice = 250;
                        selectedRating = 3;
                        selectedSize = '';
                        selectedColor = null;
                      });
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Color.fromARGB(255, 91, 137, 92)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Gửi dữ liệu lọc về Provider tại đây
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 91, 137, 92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      'Women',
      'Men',
      'Shoe',
      'Bag',
      'Luxury',
      'Kids',
      'Sports',
      'Beauty',
      'Lifestyle',
      'Other',
    ];
    return _buildSection(
      title: "Categories",
      children: Wrap(
        spacing: 10,
        runSpacing: 10,
        children:
            categories.map((c) {
              final selected = selectedCategories.contains(c);
              return FilterChip(
                label: Text(c),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    selected
                        ? selectedCategories.remove(c)
                        : selectedCategories.add(c);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                selectedColor: Colors.green.shade100,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPriceSection() {
    return _buildSection(
      title: "Price",
      children: Column(
        children: [
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            min: 0,
            max: 500,
            divisions: 100,
            activeColor: Colors.green,
            labels: RangeLabels(
              "\$${minPrice.round()}",
              "\$${maxPrice.round()}",
            ),
            onChanged: (value) {
              setState(() {
                minPrice = value.start;
                maxPrice = value.end;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return _buildSection(
      title: "Rating",
      children: Wrap(
        spacing: 10,
        children:
            [3, 4, 5].map((r) {
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    Text(" $r "),
                  ],
                ),
                selected: selectedRating == r,
                onSelected: (_) => setState(() => selectedRating = r),
                selectedColor: Colors.green.shade100,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSizeSection() {
    final sizes = [
      'XXS',
      'XS',
      'S',
      'M',
      'L',
      'XL',
      'XXL',
      '35',
      '36',
      '37',
      '38',
      '39',
      '40',
      '41',
      '42',
      '43',
      '44',
      '45',
    ];
    return _buildSection(
      title: "Size",
      children: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            sizes.map((size) {
              final isSelected = size == selectedSize;
              return ChoiceChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (_) => setState(() => selectedSize = size),
                selectedColor: Colors.green.shade100,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildColorSection() {
    final colors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.teal,
      Colors.green,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.blueGrey,
    ];

    return _buildSection(
      title: "Color",
      children: Wrap(
        spacing: 10,
        runSpacing: 10,
        children:
            colors.map((color) {
              final selected = selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => selectedColor = color),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child:
                      selected
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                          : null,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget children}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          children,
        ],
      ),
    );
  }
}
