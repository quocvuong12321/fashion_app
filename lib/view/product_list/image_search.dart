import 'dart:io';
import 'package:fashionshop_app/RequestAPI/Request_ImageSearch.dart';
import 'package:fashionshop_app/view/product_list/result_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

void showPickImageDialog(
  BuildContext parentContext, {
  void Function(bool)? onLoading,
}) {
  showModalBottomSheet(
    context: parentContext,
    builder:
        (context) => Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Chụp ảnh'),
              onTap: () async {
                Navigator.pop(context);
                if (onLoading != null) onLoading(true);
                File? imageFile = await pickImage(ImageSource.camera);
                if (imageFile != null) {
                  try {
                    final products = await RequestImageSearch().searchImage(
                      imageFile.path,
                    );
                    if (Navigator.of(parentContext).mounted) {
                      if (onLoading != null) onLoading(false);
                      Navigator.push(
                        parentContext,
                        MaterialPageRoute(
                          builder:
                              (context) => ResultSearch(products: products),
                        ),
                      );
                    }
                  } catch (e) {
                    if (Navigator.of(parentContext).mounted) {
                      if (onLoading != null) onLoading(false);
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text('Có lỗi xảy ra khi tìm kiếm ảnh'),
                        ),
                      );
                    }
                  }
                } else {
                  if (onLoading != null) onLoading(false);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Chọn từ thư viện'),
              onTap: () async {
                Navigator.pop(context);
                if (onLoading != null) onLoading(true);
                File? imageFile = await pickImage(ImageSource.gallery);
                if (imageFile != null) {
                  try {
                    final products = await RequestImageSearch().searchImage(
                      imageFile.path,
                    );
                    if (Navigator.of(parentContext).mounted) {
                      if (onLoading != null) onLoading(false);
                      Navigator.push(
                        parentContext,
                        MaterialPageRoute(
                          builder:
                              (context) => ResultSearch(products: products),
                        ),
                      );
                    }
                  } catch (e) {
                    if (Navigator.of(parentContext).mounted) {
                      if (onLoading != null) onLoading(false);
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text('Có lỗi xảy ra khi tìm kiếm ảnh'),
                        ),
                      );
                    }
                  }
                } else {
                  if (onLoading != null) onLoading(false);
                }
              },
            ),
          ],
        ),
  );
}
