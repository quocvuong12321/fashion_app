class Product_Sku_Attr {
  String product_sku_attr_id; // SKU attribute ID
  String name; // Attribute name
  String value; // Attribute value
  String? image; // Attribute image (optional)
  String products_spu_id; // Associated SPU ID

  Product_Sku_Attr({
    required this.product_sku_attr_id,
    required this.name,
    required this.value,
    this.image,
    required this.products_spu_id,
  });

  factory Product_Sku_Attr.fromJson(Map<String, dynamic> json) {
    return Product_Sku_Attr(
      product_sku_attr_id: json['product_sku_attr_id'],
      name: json['name'],
      value: json['value'],
      image: json['image'],
      products_spu_id: json['products_spu_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_sku_attr_id': product_sku_attr_id,
      'name': name,
      'value': value,
      'image': image,
      'products_spu_id': products_spu_id,
    };
  }
}
