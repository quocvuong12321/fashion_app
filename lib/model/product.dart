class Product {
  final String productSpuId;
  final String name;
  final String image;
  final double price;
  final double rating;

  Product({
    required this.productSpuId,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productSpuId: json['product_spu_id'].toString(),
      name: json['name'],
      image: json['image'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      rating: double.tryParse(json['average_star'].toString()) ?? 0,
    );
  }
}
