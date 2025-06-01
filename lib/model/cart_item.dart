class CartItem {
  final String id;
  final String productSkuId;
  final String productName;
  final String image;
  final double price;
  final String selectedAttributes;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.productSkuId,
    required this.productName,
    required this.image,
    required this.price,
    required this.selectedAttributes,
    required this.quantity,
    this.isSelected = true,
  });

  CartItem copyWith({
    String? id,
    String? productSkuId,
    String? productName,
    String? image,
    double? price,
    String? selectedAttributes,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      id: id ?? this.id,
      productSkuId: productSkuId ?? this.productSkuId,
      productName: productName ?? this.productName,
      image: image ?? this.image,
      price: price ?? this.price,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productSkuId': productSkuId,
      'productName': productName,
      'image': image,
      'price': price,
      'selectedAttributes': selectedAttributes,
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productSkuId: json['productSkuId'],
      productName: json['productName'],
      image: json['image'],
      price: json['price'],
      selectedAttributes: json['selectedAttributes'],
      quantity: json['quantity'],
      isSelected: json['isSelected'] ?? true,
    );
  }

  double get totalPrice => price * quantity;
}
