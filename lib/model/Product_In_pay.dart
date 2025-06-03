import 'package:fashionshop_app/model/Order_Detail.dart';

class Products_In_pay {
  String productsSpuId;
  String name;
  String image;
  String key;
  String productSkuId;
  int amount;
  double price;
  String skuString;

  Products_In_pay({
    required this.productsSpuId,
    required this.name,
    required this.image,
    required this.productSkuId,
    required this.amount,
    required this.price,
    required this.key,
    required this.skuString,
  });
}
