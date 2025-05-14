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
      descriptionAttrs: (json['description_attrs'] as List)
          .map((e) => Attr.fromJson(e))
          .toList(),
      skuAttrs: (json['sku_attrs'] as List)
          .map((e) => SkuAttr.fromJson(e))
          .toList(),
      skus: (json['skus'] as List)
          .map((e) => Sku.fromJson(e))
          .toList(),
      ratings: (json['ratings'] as List)
          .map((e) => Rating.fromJson(e))
          .toList(),
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
  final String productsSpuId;
  final String key;
  final String averageStar;
  final String brandId;
  final int totalRating;

  ProductSPU({
    required this.name,
    required this.image,
    required this.media,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.categoryId,
    required this.productsSpuId,
    required this.key,
    required this.averageStar,
    required this.brandId,
    required this.totalRating,
  });

  factory ProductSPU.fromJson(Map<String, dynamic> json) {
    // Parse media: nếu là chuỗi thì decode, nếu là list thì giữ nguyên
    List<String> mediaList;
    if (json['media'] is String) {
      mediaList = List<String>.from(jsonDecode(json['media'].toString().replaceAll("'", '"')));
    } else {
      mediaList = List<String>.from(json['media']);
    }
    return ProductSPU(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      media: mediaList,
      description: json['description']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      categoryId: json['category_id']?.toString() ?? '',
      productsSpuId: json['products_spu_id']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      averageStar: json['average_star']?.toString() ?? '',
      brandId: json['brand_id']?.toString() ?? '',
      totalRating: int.tryParse(json['total_rating'].toString()) ?? 0,
    );
  }
}

class Attr {
  final String attrId;
  final String name;
  final String value;

  Attr({required this.attrId, required this.name, required this.value});

  factory Attr.fromJson(Map<String, dynamic> json) {
    return Attr(
      attrId: json['attr_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

class SkuAttr {
  final String skuAttrId;
  final String name;
  final String value;
  final String image;

  SkuAttr({
    required this.skuAttrId,
    required this.name,
    required this.value,
    required this.image,
  });

  factory SkuAttr.fromJson(Map<String, dynamic> json) {
    return SkuAttr(
      skuAttrId: json['sku_attr_id'] ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      image: json['image'] ?? '',
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
      productSkuId: json['product_sku_id'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      skuStock: json['sku_stock'] ?? 0,
      value: json['value'] ?? '',
    );
  }
}

class Rating {
  final String name;
  final String comment;
  final int star;
  final String createDate;

  Rating({
    required this.name,
    required this.comment,
    required this.star,
    required this.createDate,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      name: json['name'] ?? '',
      comment: json['comment'] ?? '',
      star: json['star'] ?? 0,
      createDate: json['create_date'] ?? '',
    );
  }
}
