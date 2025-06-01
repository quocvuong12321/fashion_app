import 'package:flutter/material.dart';
import 'package:fashionshop_app/RequestAPI/Request_Product.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit fit;

  const ProductImage({
    required this.imagePath,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  // Hàm xem ảnh phóng to
  void showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
              color: Colors.black,
              child: PhotoViewGallery.builder(
                itemCount: 1, // Số lượng ảnh
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                ),
                pageController: PageController(initialPage: 0),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Request_Products.getImage(imagePath), // Gọi hàm lấy URL ảnh
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(
            "Error loading image URL for path: $imagePath, error: ${snapshot.error}",
          );
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: 40,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          print("Full image URL for $imagePath: ${snapshot.data}");
          return GestureDetector(
            onTap: () {
              // Kiểm tra xem có phải là trang chi tiết hay không trước khi phóng to ảnh
              if (Navigator.of(context).canPop()) {
                showFullScreenImage(
                  context,
                  snapshot.data!,
                ); // Gọi hàm phóng to ảnh khi nhấn vào ảnh
              }
            },
            child: Image.network(
              snapshot.data!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print(
                  "Error displaying image from URL: ${snapshot.data!}, error: $error",
                );
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          print("No data for image path: $imagePath");
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 40,
              ),
            ),
          );
        }
      },
    );
  }
}
