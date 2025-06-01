// filepath: d:\Downloads\fashion_app-truc\lib\providers\cart_provider.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Product_Detail.dart';
import '../model/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final String _cartStorageKey = 'cart_data';

  List<CartItem> get items => [..._items];

  List<CartItem> get selectedItems =>
      _items.where((item) => item.isSelected).toList();

  int get itemCount => _items.length;

  int get selectedItemCount => selectedItems.length;

  double get totalAmount {
    return selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool get isAllSelected {
    return _items.isNotEmpty && _items.every((item) => item.isSelected);
  }

  Future<void> loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartStorageKey);

      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
      // Handle error (optional)
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartStorageKey, encodedData);
    } catch (e) {
      debugPrint('Error saving cart: $e');
      // Handle error (optional)
    }
  }

  void addItem({
    required String productSkuId,
    required String productName,
    required String image,
    required double price,
    required String selectedAttributes,
    int quantity = 1,
  }) {
    final existingItemIndex = _items.indexWhere(
      (item) =>
          item.productSkuId == productSkuId &&
          item.selectedAttributes == selectedAttributes,
    );

    if (existingItemIndex >= 0) {
      // Increase quantity if item already exists with same attributes
      _items[existingItemIndex].quantity += quantity;
    } else {
      // Add new item
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productSkuId: productSkuId,
          productName: productName,
          image: image,
          price: price,
          selectedAttributes: selectedAttributes,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
    _saveCartToStorage();
  }

  void addItemFromProductDetail({
    required ProductSPU product,
    required ProductSku selectedSku,
    required String selectedAttributes,
    int quantity = 1,
  }) {
    addItem(
      productSkuId: selectedSku.productSkuId,
      productName: product.name,
      image: product.image,
      price: selectedSku.price,
      selectedAttributes: selectedAttributes,
      quantity: quantity,
    );
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }

    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
      _saveCartToStorage();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    _saveCartToStorage();
  }

  void toggleItemSelection(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        isSelected: !_items[index].isSelected,
      );
      notifyListeners();
      _saveCartToStorage();
    }
  }

  void toggleAllSelection(bool select) {
    _items = _items.map((item) => item.copyWith(isSelected: select)).toList();
    notifyListeners();
    _saveCartToStorage();
  }

  void removeSelectedItems() {
    _items.removeWhere((item) => item.isSelected);
    notifyListeners();
    _saveCartToStorage();
  }

  void updateAttributes(String id, String attributes) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(selectedAttributes: attributes);
      notifyListeners();
      _saveCartToStorage();
    }
  }

  void clear() {
    _items = [];
    notifyListeners();
    _saveCartToStorage();
  }
}
