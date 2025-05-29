import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/cart_item.dart';
import '../providers/cart_provider.dart';
import 'product_list/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearCartDialog(context),
              tooltip: 'Xóa tất cả',
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartItemsList(context, cartItems, cartProvider),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : _buildCheckoutSection(context, cartProvider),
    );
  }

  Widget _buildEmptyCart() {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Giỏ hàng của bạn đang trống',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to home screen or product list
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('Mua sắm ngay'),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildCartItemsList(
      BuildContext context, List<CartItem> items, CartProvider cartProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        return _buildCartItemTile(context, item, cartProvider);
      },
    );
  }

  Widget _buildCartItemTile(
      BuildContext context, CartItem item, CartProvider cartProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: ProductImage(
                    imagePath: item.image,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              // checkbox
              Positioned(
                top: 0,
                left: 0,
                child: Checkbox(
                  value: item.isSelected,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool? value) {
                    cartProvider.toggleItemSelection(item.id);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(width: 10),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Product name
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Attributes with edit button
                Text(
                  item.selectedAttributes,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                // Quantity
                Row(
                  spacing: 10,
                  children: [
                    Text("Qty:"),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                      .format(item.price),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // edit
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Show edit options
                    _showEditAttributesDialog(context, item);
                  },
                ),

                // delete
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    _confirmDismiss(context).then((value) {
                      if (value) {
                        _removeItem(context, item.id);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(
      BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cartProvider.selectedItemCount > 0
                  ? () => _navigateToCheckout(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                disabledBackgroundColor: Colors.grey.shade400,
              ),
              child: Text(
                'THANH TOÁN ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(cartProvider.totalAmount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDismiss(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa sản phẩm'),
        content: const Text('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showDeleteSelectedDialog(
      BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa sản phẩm đã chọn'),
        content: Text(
            'Bạn có chắc muốn xóa ${cartProvider.selectedItemCount} sản phẩm đã chọn?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeSelectedItems();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa sản phẩm đã chọn khỏi giỏ hàng'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditAttributesDialog(BuildContext context, CartItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _buildEditProductBottomSheet(context, item),
    );
  }
  
  Widget _buildEditProductBottomSheet(BuildContext context, CartItem item) {
    int quantity = item.quantity;
    String selectedAttributes = item.selectedAttributes;
    
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Chỉnh sửa sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                
                // Product image and name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: ProductImage(
                        imagePath: item.image,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                                .format(item.price),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Attributes selection
                const Text(
                  'Thuộc tính:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                // For now, we'll keep the text field, but in a production app
                // this would be replaced with the same selectors used when adding products
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    selectedAttributes,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Quantity adjustment
                const Text(
                  'Số lượng:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: quantity > 1 
                          ? () => setState(() => quantity--) 
                          : null,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => quantity++),
                      color: Theme.of(context).primaryColor,
                    ),
                    const Spacer(),
                    Text(
                      'Tổng: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(item.price * quantity)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _updateItemAttributes(context, item.id, quantity, selectedAttributes);
                      Navigator.pop(context);
                    },
                    child: const Text('CẬP NHẬT', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    );
  }
  
  // New method to update item attributes and quantity
  void _updateItemAttributes(BuildContext context, String id, int quantity, String attributes) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // Update quantity
    cartProvider.updateQuantity(id, quantity);
    
    // Update attributes (you'll need to add this method to your CartProvider)
    cartProvider.updateAttributes(id, attributes);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sản phẩm đã được cập nhật'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCheckout(BuildContext context) {
    // Navigate to checkout screen
  }

  void _removeItem(BuildContext context, String id) {
    Provider.of<CartProvider>(context, listen: false).removeItem(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content:
            const Text('Bạn có chắc muốn xóa tất cả sản phẩm khỏi giỏ hàng?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clear();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa tất cả sản phẩm trong giỏ hàng'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
