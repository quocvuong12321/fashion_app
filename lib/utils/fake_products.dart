// This file contains fake product data for use when API calls fail
import '../model/Product.dart';
import '../model/Product_Detail.dart';

class FakeProducts {
  // Generate a list of fake products
  static List<Product> generateFakeProducts() {
    return [
      Product(
        productSpuId: 'fake_spu_001',
        name: 'Áo Thun Nam Basic',
        categoryId: '1',
        image: 'assets/images/product1.jpg',
        price: 149000,
        rating: 4.5,
      ),
      Product(
        productSpuId: 'fake_spu_002',
        name: 'Quần Jean Nam Slim Fit',
        categoryId: '2',
        image: 'assets/images/product2.png',
        price: 349000,
        rating: 4.7,
      ),
      Product(
        productSpuId: 'fake_spu_003',
        name: 'Áo Sơ Mi Nữ Dài Tay',
        categoryId: '3',
        image: 'assets/images/product3.png',
        price: 256000,
        rating: 4.3,
      ),
      Product(
        productSpuId: 'fake_spu_004',
        name: 'Váy Đầm Nữ Công Sở',
        categoryId: '4',
        image: 'assets/images/product4.jpg',
        price: 367000,
        rating: 4.8,
      ),
      Product(
        productSpuId: 'fake_spu_005',
        name: 'Giày Thể Thao Nam',
        categoryId: '5',
        image: '',
        price: 599000,
        rating: 4.6,
      ),
      Product(
        productSpuId: 'fake_spu_006',
        name: 'Túi Xách Nữ Thời Trang',
        categoryId: '6',
        image: 'assets/images/product2.png',
        price: 357000,
        rating: 4.4,
      ),
    ];
  }

  // Generate a product detail from a product ID
  static ProductDetail generateProductDetail(String productSpuId) {
    // Default product detail structure
    ProductSPU spu = ProductSPU(
      name: 'Sản phẩm mẫu',
      image: 'assets/images/product4.jpg',
      media: [
        'assets/images/product4.jpg',
        'assets/images/product4.jpg',
      ],
      description:
          'Đây là mô tả chi tiết về sản phẩm mẫu. Sản phẩm có chất liệu cao cấp, thiết kế hiện đại và phù hợp với nhiều dịp sử dụng khác nhau.',
      shortDescription: 'Sản phẩm chất lượng cao',
      price: 299000,
      categoryId: '1',
      productsSpuId: productSpuId,
      key: 'product_key',
      averageStar: '4.5',
      brandId: '1',
      totalRating: 10,
    );

    // Find matching fake product to use its data
    final fakeProducts = generateFakeProducts();
    final matchingProduct = fakeProducts.firstWhere(
      (product) => product.productSpuId == productSpuId,
      orElse: () => fakeProducts.first,
    );

    // Update spu with matching product data
    spu = ProductSPU(
      name: matchingProduct.name,
      image: matchingProduct.image,
      media: [matchingProduct.image, matchingProduct.image],
      description:
          'Đây là mô tả chi tiết về ${matchingProduct.name}. Sản phẩm có chất liệu cao cấp, thiết kế hiện đại và phù hợp với nhiều dịp sử dụng khác nhau.',
      shortDescription: 'Sản phẩm chất lượng cao',
      price: matchingProduct.price,
      categoryId: matchingProduct.categoryId,
      productsSpuId: matchingProduct.productSpuId,
      key: 'product_key',
      averageStar: matchingProduct.rating.toString(),
      brandId: '1',
      totalRating: 10,
    );

    // Sample description attributes
    List<Attr> descriptionAttrs = [
      Attr(attrId: 'attr_1', name: 'Chất liệu', value: 'Cotton 100%'),
      Attr(attrId: 'attr_2', name: 'Xuất xứ', value: 'Việt Nam'),
      Attr(attrId: 'attr_3', name: 'Kiểu dáng', value: 'Regular Fit'),
    ];

    // Sample SKU attributes
    List<SkuAttr> skuAttrs = [
      SkuAttr(
          skuAttrId: 'sku_attr_1', name: 'Màu sắc', value: 'Đen', image: ''),
      SkuAttr(
          skuAttrId: 'sku_attr_2', name: 'Màu sắc', value: 'Trắng', image: ''),
      SkuAttr(
          skuAttrId: 'sku_attr_3',
          name: 'Màu sắc',
          value: 'Xanh Navy',
          image: ''),
      SkuAttr(
          skuAttrId: 'sku_attr_4', name: 'Kích thước', value: 'S', image: ''),
      SkuAttr(
          skuAttrId: 'sku_attr_5', name: 'Kích thước', value: 'M', image: ''),
      SkuAttr(
          skuAttrId: 'sku_attr_6', name: 'Kích thước', value: 'L', image: ''),
      SkuAttr(
          skuAttrId: 'sku_attr_7', name: 'Kích thước', value: 'XL', image: ''),
    ];

    // Sample SKUs
    List<Sku> skus = [
      Sku(
          productSkuId: 'sku_1',
          price: matchingProduct.price,
          skuStock: 10,
          value: 'Đen-S'),
      Sku(
          productSkuId: 'sku_2',
          price: matchingProduct.price,
          skuStock: 15,
          value: 'Đen-M'),
      Sku(
          productSkuId: 'sku_3',
          price: matchingProduct.price,
          skuStock: 20,
          value: 'Đen-L'),
      Sku(
          productSkuId: 'sku_4',
          price: matchingProduct.price,
          skuStock: 5,
          value: 'Đen-XL'),
      Sku(
          productSkuId: 'sku_5',
          price: matchingProduct.price,
          skuStock: 12,
          value: 'Trắng-S'),
      Sku(
          productSkuId: 'sku_6',
          price: matchingProduct.price,
          skuStock: 18,
          value: 'Trắng-M'),
      Sku(
          productSkuId: 'sku_7',
          price: matchingProduct.price,
          skuStock: 15,
          value: 'Trắng-L'),
      Sku(
          productSkuId: 'sku_8',
          price: matchingProduct.price,
          skuStock: 8,
          value: 'Trắng-XL'),
      Sku(
          productSkuId: 'sku_9',
          price: matchingProduct.price,
          skuStock: 7,
          value: 'Xanh Navy-S'),
      Sku(
          productSkuId: 'sku_10',
          price: matchingProduct.price,
          skuStock: 9,
          value: 'Xanh Navy-M'),
      Sku(
          productSkuId: 'sku_11',
          price: matchingProduct.price,
          skuStock: 11,
          value: 'Xanh Navy-L'),
      Sku(
          productSkuId: 'sku_12',
          price: matchingProduct.price,
          skuStock: 4,
          value: 'Xanh Navy-XL'),
    ];

    // Sample ratings
    List<Rating> ratings = [
      Rating(
        name: 'Nguyễn Văn A',
        comment: 'Sản phẩm chất lượng tốt, giao hàng nhanh.',
        star: 5,
        createDate: '2025-04-15',
      ),
      Rating(
        name: 'Trần Thị B',
        comment: 'Đúng với mô tả, sẽ mua lại lần sau.',
        star: 4,
        createDate: '2025-04-10',
      ),
      Rating(
        name: 'Lê Văn C',
        comment: 'Hài lòng với chất lượng sản phẩm.',
        star: 5,
        createDate: '2025-03-25',
      ),
    ];

    return ProductDetail(
      spu: spu,
      descriptionAttrs: descriptionAttrs,
      skuAttrs: skuAttrs,
      skus: skus,
      ratings: ratings,
    );
  }
}
