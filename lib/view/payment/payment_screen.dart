import 'package:fashionshop_app/RequestAPI/Request_Order.dart';
import 'package:fashionshop_app/RequestAPI/Request_Payment.dart';
import 'package:fashionshop_app/model/CacModelNho.dart';
import 'package:fashionshop_app/model/Product_In_pay.dart';
import 'package:fashionshop_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  final List<Products_In_pay> products;
  final bool inCard;

  const PaymentScreen({Key? key, required this.products, required this.inCard})
    : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Payment> _paymentMethods = [];
  List<CustomerAddress> _customerAddresses = [];
  List<Discount> _discounts = [];
  Payment? _selectedPaymentMethod;
  CustomerAddress? _selectedAddress;
  Discount? _selectedDiscount;
  bool _isLoading = true;
  final CartProvider cartPro = CartProvider();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final paymentMethods = await Request_Payment.fetchPaymentMethodResponse();
      final addresses = await Request_Payment.fetchCustomerAddressResponse();
      final discount = await Request_Payment.fetchMaGiamGiaResponse();

      setState(() {
        _currentAmount = totalAmount;

        _paymentMethods = paymentMethods;
        _customerAddresses = addresses;
        _discounts = discount;
        if (_discounts.isNotEmpty) {
          // chọn mã giảm giá có discountValue lớn nhất
          _selectedDiscount = _discounts
              .where(
                (discount) =>
                    discount.amount > 0 &&
                    discount.startDate.isBefore(DateTime.now()) &&
                    discount.endDate.isAfter(DateTime.now()) &&
                    discount.minOrderValue <= totalAmount,
              )
              .reduce((a, b) => a.discountValue > b.discountValue ? a : b);
        }
        if (_paymentMethods.isNotEmpty) {
          _selectedPaymentMethod = _paymentMethods.first;
        }
        if (_customerAddresses.isNotEmpty) {
          _selectedAddress = _customerAddresses.first;
        }
        _currentAmount = totalAmount - (_selectedDiscount?.discountValue ?? 0);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get totalAmount => widget.products.fold(
    0,
    (sum, product) => sum + product.price * product.amount,
  );
  double _currentAmount = 0;
  void _processPayment() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn địa chỉ giao hàng')),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn phương thức thanh toán')),
      );
      return;
    }

    // Tạo danh sách num_of_products
    final numOfProducts =
        widget.products
            .map(
              (product) => {
                'product_sku_id': product.productSkuId,
                'amount': product.amount,
              },
            )
            .toList();

    // Tạo dữ liệu đơn hàng
    final orderData = {
      'address_id': _selectedAddress!.idAddress,
      'payment_id': _selectedPaymentMethod!.paymentMethodId,
      'num_of_products': numOfProducts,
    };
    if (_selectedDiscount != null) {
      orderData['discount_id'] = _selectedDiscount!.discountId;
    }
    try {
      final result = await Request_Payment.postOrderResponse(orderData);

      if (result['success']) {
        if (result['payUrl'] != null) {
          // Chuyển hướng đến trang thanh toán
          final Uri paymentUrl = Uri.parse(result['payUrl']);
          if (!await launchUrl(paymentUrl)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Không thể mở trang thanh toán')),
            );
          }
          // if (await canLaunchUrl(paymentUrl)) {
          //   await launchUrl(paymentUrl, mode: LaunchMode.externalApplication);
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Không thể mở trang thanh toán')),
          //   );
          // }
        } else {
          // Hiển thị thông báo thành công và quay về trang chính
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (widget.inCard) {
          cartPro.loadCartFromStorage();
          for (var element in widget.products) {
            cartPro.removeItem(element.productsSpuId);
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Có lỗi xảy ra khi đặt hàng')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Thanh toán')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Thanh toán')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Danh sách sản phẩm
            Text(
              'Sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              Request_Order.getImage(product.image),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Phân loại: ${product.skuString}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Số lượng: ${product.amount}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'vi_VN',
                              symbol: 'đ',
                            ).format(product.price),
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 24),

            // Thông tin giao hàng
            Text(
              'Thông tin giao hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (_customerAddresses.isNotEmpty)
              DropdownButtonFormField<CustomerAddress>(
                isExpanded: true,
                value: _selectedAddress,
                decoration: InputDecoration(
                  labelText: 'Chọn địa chỉ',
                  border: OutlineInputBorder(),
                ),

                // Dữ liệu khi mở dropdown
                items:
                    _customerAddresses.map((address) {
                      return DropdownMenuItem(
                        value: address,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.address,
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              address.phoneNumber,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                // Dữ liệu khi dropdown đóng lại
                selectedItemBuilder: (context) {
                  return _customerAddresses.map((address) {
                    return Row(
                      children: [
                        Icon(Icons.location_on, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address.address,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },

                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value;
                  });
                },
              ),

            SizedBox(height: 24),

            // Phương thức thanh toán
            Text(
              'Phương thức thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (_paymentMethods.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = _paymentMethods[index];
                  return RadioListTile<Payment>(
                    title: Text(paymentMethod.name),
                    subtitle: Text(paymentMethod.description!),
                    value: paymentMethod,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  );
                },
              ),
            SizedBox(height: 24),
            // Mã giảm giá
            Text(
              'Mã giảm giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (_discounts.isNotEmpty)
              DropdownButtonFormField<Discount>(
                isExpanded: true,
                value: _selectedDiscount,
                decoration: InputDecoration(
                  labelText: 'Chọn mã giảm giá',
                  border: OutlineInputBorder(),
                ),

                // Dữ liệu khi mở dropdown
                // items:
                //     _discounts.map((discount) {
                //       final check =
                //           discount.amount > 0 &&
                //           discount.startDate.isBefore(DateTime.now()) &&
                //           discount.endDate.isAfter(DateTime.now()) &&
                //           discount.minOrderValue <= totalAmount;
                //       return DropdownMenuItem(
                //         value: discount,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               discount.discountCode,
                //               style: TextStyle(fontSize: 14),
                //             ),
                //             Text(
                //               discount.minOrderValue > 0
                //                   ? 'Giảm ${discount.discountValue}đ cho đơn hàng từ ${discount.minOrderValue}đ'
                //                   : 'Giảm ${discount.amount}đ',
                //               style: TextStyle(
                //                 fontSize: 12,
                //                 color: Colors.grey[600],
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     }).toList(),
                items:
                    _discounts.map((discount) {
                      final check =
                          discount.amount > 0 &&
                          discount.startDate.isBefore(DateTime.now()) &&
                          discount.endDate.isAfter(DateTime.now()) &&
                          discount.minOrderValue <= totalAmount;

                      return DropdownMenuItem(
                        value: check ? discount : null, // null nếu không hợp lệ
                        enabled:
                            check, // không có tác dụng thật sự trong Dropdown, nhưng để dễ đọc
                        child: Opacity(
                          opacity:
                              check ? 1.0 : 0.5, // mờ item nếu không hợp lệ
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                discount.discountCode,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                discount.minOrderValue > 0
                                    ? 'Giảm ${discount.discountValue}đ cho đơn hàng từ ${discount.minOrderValue}đ'
                                    : 'Giảm ${discount.amount}đ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                // Dữ liệu khi dropdown đóng lại
                selectedItemBuilder: (context) {
                  return _discounts.map((discount) {
                    return Row(
                      children: [
                        Icon(Icons.local_offer, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            discount.discountCode,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },

                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      _selectedDiscount = null;
                      return;
                    }
                    if (totalAmount < value.minOrderValue) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đơn hàng không đủ điều kiện áp dụng mã giảm giá',
                          ),
                        ),
                      );
                      return;
                    }
                    if (value.amount > totalAmount) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mã giảm giá không hợp lệ')),
                      );
                      return;
                    }
                    if (value.startDate.isAfter(DateTime.now()) ||
                        value.endDate.isBefore(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Mã giảm giá không trong thoi gian sử dụng',
                          ),
                        ),
                      );
                      return;
                    }
                    if (value.amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hết mã giảm giá')),
                      );
                      return;
                    }
                    _currentAmount = totalAmount - value.discountValue;
                    _selectedDiscount = value;
                  });
                },
              ),

            SizedBox(height: 24),

            // Tổng tiền
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng tiền:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'vi_VN',
                      symbol: 'đ',
                    ).format(_currentAmount),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF28804F),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _processPayment,
          child: Text(
            'Đặt hàng',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
