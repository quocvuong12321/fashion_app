import 'dart:convert';

class ProductDetail {
  final ProductSPU spu;
  final List<DescriptionAttr> descriptionAttrs;
  final List<ProductSkuAttr> skuAttrs;
  final List<ProductSku> skus;
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
          (json['description_attrs'] as List? ?? [])
              .map((e) => DescriptionAttr.fromJson(e))
              .toList(),
      skuAttrs:
          (json['sku_attrs'] as List? ?? [])
              .map((e) => ProductSkuAttr.fromJson(e))
              .toList(),
      skus:
          (json['skus'] as List? ?? [])
              .map((e) => ProductSku.fromJson(e))
              .toList(),
      ratings:
          (json['ratings'] as List? ?? [])
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
  final String productSpuId;
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
    required this.productSpuId,
    required this.key,
    required this.averageStar,
    required this.brandId,
    required this.totalRating,
  });

  factory ProductSPU.fromJson(Map<String, dynamic> json) {
    // Parse media: nếu là chuỗi thì decode, nếu là list thì giữ nguyên
    List<String> mediaList;
    if (json['media'] is String) {
      mediaList = List<String>.from(
        jsonDecode(json['media'].toString().replaceAll("'", '"')),
      );
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
      productSpuId: json['products_spu_id']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      averageStar: json['average_star']?.toString() ?? '',
      brandId: json['brand_id']?.toString() ?? '',
      totalRating: int.tryParse(json['total_rating'].toString()) ?? 0,
    );
  }
}

class DescriptionAttr {
  final String descriptionAttrId;
  final String name;
  final String value;
  final String productSpuId;

  DescriptionAttr({
    required this.descriptionAttrId,
    required this.name,
    required this.value,
    required this.productSpuId,
  });

  factory DescriptionAttr.fromJson(Map<String, dynamic> json) {
    return DescriptionAttr(
      descriptionAttrId: json['description_attr_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      productSpuId: json['products_spu_id']?.toString() ?? '',
    );
  }
}

class ProductSkuAttr {
  final String productSkuAttrId;
  final String name;
  final String value;
  final String image;
  final String productSpuId;

  ProductSkuAttr({
    required this.productSkuAttrId,
    required this.name,
    required this.value,
    required this.image,
    required this.productSpuId,
  });

  factory ProductSkuAttr.fromJson(Map<String, dynamic> json) {
    return ProductSkuAttr(
      productSkuAttrId: json['sku_attr_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '', // Lấy trực tiếp dưới dạng String
      image: json['image']?.toString() ?? '',
      productSpuId: json['products_spu_id']?.toString() ?? '',
    );
  }
}

class ProductSku {
  final String productSkuId;
  final String value;
  final int skuStock;
  final double price;
  final int sort;
  final String productSpuId;

  ProductSku({
    required this.productSkuId,
    required this.value,
    required this.skuStock,
    required this.price,
    required this.sort,
    required this.productSpuId,
  });

  factory ProductSku.fromJson(Map<String, dynamic> json) {
    return ProductSku(
      productSkuId: json['product_sku_id']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      skuStock: int.tryParse(json['sku_stock'].toString()) ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0,
      sort: int.tryParse(json['sort'].toString()) ?? 0,
      productSpuId: json['products_spu_id']?.toString() ?? '',
    );
  }
}

class Rating {
  final String name;
  final String comment;
  final String? avatar;
  final int star;
  final String createDate;

  Rating({
    required this.name,
    this.avatar,
    required this.comment,
    required this.star,
    required this.createDate,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    String? avatarUrl;
    try {
      if (json['user_info'] != null &&
          json['user_info']['data'] != null &&
          json['user_info']['data']['image'] != null &&
          json['user_info']['data']['image']['data'] != null) {
        avatarUrl = json['user_info']['data']['image']['data'].toString();
      }
    } catch (e) {
      print('Error parsing avatar: $e');
    }

    return Rating(
      name: json['user_info']?['data']?['name'] ?? 'Anonymous',
      comment: json['comment']?['data'] ?? '',
      avatar: avatarUrl,
      star: json['star'] ?? 0,
      createDate: json['create_date'] ?? '',
    );
  }
}
