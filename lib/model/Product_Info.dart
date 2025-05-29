// ignore_for_file: public_member_api_docs, sort_constructors_first

class Product_Info {
  String product_sku_id;
  String products_spu_id;
  String name;
  String short_description;
  String info_sku_attr;
  String image;
  int price;
  int sku_stock;
  int sort;
  DateTime create_date;
  DateTime update_date;

  Product_Info({
    required this.product_sku_id,
    required this.products_spu_id,
    required this.name,
    required this.short_description,
    required this.info_sku_attr,
    required this.image,
    required this.price,
    required this.sku_stock,
    required this.sort,
    required this.create_date,
    required this.update_date,
  });

  factory Product_Info.fromJson(Map<String, dynamic> json) {
    return Product_Info(
      product_sku_id: json['product_sku_id'] ?? "",
      products_spu_id: json['products_spu_id'] ?? "",
      name: json['name'] ?? "",
      short_description: json['short_description'] ?? "",
      info_sku_attr: json['info_sku_attr'] ?? "",
      image: json['image'] ?? "",
      price: (json['price'] ?? 0 as num).toInt(),
      sku_stock: (json['sku_stock'] ?? 0 as num).toInt(),
      sort: (json['sort'] ?? 0 as num).toInt(),
      create_date: DateTime.parse(
        json['create_date'] ?? '0001-01-01T00:00:00Z',
      ),
      update_date: DateTime.parse(
        json['update_date']['data'] ?? '0001-01-01T00:00:00Z',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_sku_id': product_sku_id,
      'products_spu_id': products_spu_id,
      'name': name,
      'short_description': short_description,
      'info_sku_attr': info_sku_attr,
      'image': image,
      'price': price,
      'sku_stock': sku_stock,
      'sort': sort,
      'create_date': create_date.toIso8601String(),
      'update_date': update_date.toIso8601String(),
    };
  }
}
