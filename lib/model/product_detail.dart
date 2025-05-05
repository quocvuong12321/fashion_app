import 'dart:convert';

class ProductDetail {
  final ProductSPU spu;
  final List<Attr> descriptionAttrs;
  final List<SkuAttr> skuAttrs;
  final List<Sku> skus;
  final List<Rating> ratings;

  ProductDetail({
    required this.spu,
    required this.descriptionAttrs,
    required this.skuAttrs,
    required this.skus,
    required this.ratings,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      spu: ProductSPU.fromJson(json['spu']),
      descriptionAttrs:
          (json['description_attrs'] as List)
              .map((e) => Attr.fromJson(e))
              .toList(),
      skuAttrs:
          (json['sku_attrs'] as List).map((e) => SkuAttr.fromJson(e)).toList(),
      skus: (json['skus'] as List).map((e) => Sku.fromJson(e)).toList(),
      ratings:
          (json['ratings'] as List).map((e) => Rating.fromJson(e)).toList(),
    );
  }
}

class ProductSPU {
  final String name;
  final String image;
  final List<String> media;
  final String description;
  final String shortDescription;
  final double price;
  final String categoryId;

  ProductSPU({
    required this.name,
    required this.image,
    required this.media,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.categoryId, 
  });

  factory ProductSPU.fromJson(Map<String, dynamic> json) {
    return ProductSPU(
      name: json['name'],
      image: json['image'],
      media: List<String>.from(jsonDecode(json['media'].replaceAll("'", '"'))),
      description: json['description'],
      shortDescription: json['short_description'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      categoryId: json['category_id'],
    );
  }
}

class Attr {
  final String name;
  final String value;

  Attr({required this.name, required this.value});

  factory Attr.fromJson(Map<String, dynamic> json) {
    return Attr(name: json['name'], value: json['value']);
  }
}

class SkuAttr {
  final String skuAttrId;
  final String name;
  final String value;

  SkuAttr({required this.skuAttrId, required this.name, required this.value});

  factory SkuAttr.fromJson(Map<String, dynamic> json) {
    return SkuAttr(
      skuAttrId: json['sku_attr_id'],
      name: json['name'],
      value: json['value'],
    );
  }
}

class Sku {
  final String productSkuId;
  final double price;
  final int skuStock;
  final String value;

  Sku({
    required this.productSkuId,
    required this.price,
    required this.skuStock,
    required this.value,
  });

  factory Sku.fromJson(Map<String, dynamic> json) {
    return Sku(
      productSkuId: json['product_sku_id'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      skuStock: json['sku_stock'],
      value: json['value'],
    );
  }
}

class Rating {
  final String name;
  final String comment;
  final int star;

  Rating({required this.name, required this.comment, required this.star});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      name: json['name'],
      comment: json['comment'],
      star: json['star'],
    );
  }
}
