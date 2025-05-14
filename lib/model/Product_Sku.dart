class Product_Sku {
  String product_sku_id; // SKU ID
  String value; // SKU value
  int sku_stock; // SKU stock
  double price; // SKU price
  int sort; // Sort order
  DateTime create_date; // Creation date
  DateTime update_date; // Update date
  String products_spu_id; // Associated SPU ID

  Product_Sku({
    required this.product_sku_id,
    required this.value,
    required this.sku_stock,
    required this.price,
    required this.sort,
    required this.create_date,
    required this.update_date,
    required this.products_spu_id,
  });

  factory Product_Sku.fromJson(Map<String, dynamic> json) {
    return Product_Sku(
      product_sku_id: json['product_sku_id'],
      value: json['value'],
      sku_stock: json['sku_stock'],
      price: (json['price'] as num).toDouble(),
      sort: json['sort'],
      create_date: DateTime.parse(json['create_date']),
      update_date: DateTime.parse(json['update_date']),
      products_spu_id: json['products_spu_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_sku_id': product_sku_id,
      'value': value,
      'sku_stock': sku_stock,
      'price': price,
      'sort': sort,
      'create_date': create_date.toIso8601String(),
      'update_date': update_date.toIso8601String(),
      'products_spu_id': products_spu_id,
    };
  }
}
