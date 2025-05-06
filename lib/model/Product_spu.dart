class Products_Spu {
  String? products_spu_id;
  String? name;
  String? brand_id;
  String? description;
  String? short_description;
  String? stock_status;
  String? delete_status;
  int? sort;
  String? create_date;
  String? update_date;
  String? image;
  String? media;
  String? key;
  String? category_id;

  Products_Spu({
    this.products_spu_id,
    this.name,
    this.brand_id,
    this.description,
    this.short_description,
    this.stock_status,
    this.delete_status,
    this.sort,
    this.create_date,
    this.update_date,
    this.image,
    this.media,
    this.key,
    this.category_id,
  });

  factory Products_Spu.fromJson(Map<String, dynamic> json) {
    return Products_Spu(
      products_spu_id: json['products_spu_id'],
      name: json['name'],
      brand_id: json['brand_id'],
      description: json['description'],
      short_description: json['short_description'],
      stock_status: json['stock_status'],
      delete_status: json['delete_status'],
      sort: json['sort'],
      create_date: json['create_date'],
      update_date: json['update_date'],
      image: json['image'],
      media: json['media'],
      key: json['key'],
      category_id: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products_spu_id': products_spu_id,
      'name': name,
      'brand_id': brand_id,
      'description': description,
      'short_description': short_description,
      'stock_status': stock_status,
      'delete_status': delete_status,
      'sort': sort,
      'create_date': create_date,
      'update_date': update_date,
      'image': image,
      'media': media,
      'key': key,
      'category_id': category_id,
    };
  }
}
