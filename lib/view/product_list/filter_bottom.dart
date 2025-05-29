import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../RequestAPI/Request_Category.dart';
import '../../model/Category.dart';

class FilterBottom extends StatefulWidget {
  const FilterBottom({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) async {
    return showModalBottomSheet<Map<String, dynamic>>(
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
  final List<String> selectedCategories = [];
  String? selectedParentCategoryId;
  Map<String, List<Category>> subcategoriesMap = {};
  Map<String, bool> expandedCategories = {};
  double minPrice = 50000;
  double maxPrice = 250000;
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final loadedCategories = await Request_Category.fetchCategories();
      if (mounted) {
        setState(() {
          categories = loadedCategories;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading categories: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategories.clear();
                        selectedParentCategoryId = null;
                        subcategoriesMap.clear();
                        expandedCategories.clear();
                        minPrice = 50000;
                        maxPrice = 250000;
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
                      Navigator.pop(context, {
                        'selectedCategories': selectedCategories,
                        'selectedParentCategoryId': selectedParentCategoryId,
                        'minPrice': minPrice,
                        'maxPrice': maxPrice,
                      });
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return const Center(child: Text("No categories available"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...categories.map((category) => _buildCategoryItem(category, 0)).toList(),
      ],
    );
  }

  Widget _buildCategoryItem(Category category, int indent) {
    final isExpanded = expandedCategories[category.categoryId] ?? false;
    final hasChildren = category.children != null && category.children!.isNotEmpty;
    final isSelected = selectedCategories.isNotEmpty && selectedCategories.first == category.categoryId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: hasChildren
              ? () {
                  setState(() {
                    expandedCategories[category.categoryId] = !isExpanded;
                  });
                }
              : () {
                  setState(() {
                    selectedCategories
                      ..clear()
                      ..add(category.categoryId);
                  });
                },
          child: Container(
            margin: EdgeInsets.only(left: 16.0 * indent, top: 4, bottom: 4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 91, 137, 92).withOpacity(0.1)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? const Color.fromARGB(255, 91, 137, 92)
                          : Colors.black,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 91, 137, 92),
                    size: 20,
                  ),
                if (hasChildren)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
              ],
            ),
          ),
        ),
        if (isExpanded && hasChildren)
          ...category.children!
              .map((child) => _buildCategoryItem(child, indent + 1))
              .toList(),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 5000000,
          divisions: 100,
          activeColor: const Color.fromARGB(255, 91, 137, 92),
          labels: RangeLabels(
            "${minPrice.round()}₫",
            "${maxPrice.round()}₫",
          ),
          onChanged: (value) {
            setState(() {
              minPrice = value.start;
              maxPrice = value.end;
            });
          },
        ),
      ],
    );
  }
}
