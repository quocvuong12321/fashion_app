import 'package:fashionshop_app/RequestAPI/Request_Order.dart';
import 'package:fashionshop_app/RequestAPI/Request_Product_Detail.dart';
import 'package:flutter/material.dart';
import '../../model/Product_Detail.dart';

class ProductRating extends StatefulWidget {
  final String productSpuId;
  final List<Rating> initialRatings;

  const ProductRating({
    Key? key,
    required this.productSpuId,
    this.initialRatings = const [],
  }) : super(key: key);

  @override
  State<ProductRating> createState() => _ProductRatingState();
}

class _ProductRatingState extends State<ProductRating> {
  bool isRatingsExpanded = false;
  bool isLoadingRatings = false;
  List<Rating> ratings = [];
  final TextEditingController _ratingCommentController =
      TextEditingController();
  int _userRating = 0;

  @override
  void initState() {
    super.initState();
    ratings = widget.initialRatings;
  }

  @override
  void dispose() {
    _ratingCommentController.dispose();
    super.dispose();
  }

  Future<void> loadRatings() async {
    if (isLoadingRatings) return;

    setState(() {
      isLoadingRatings = true;
    });

    // try {
    //   //   TODO: Implement API call to fetch ratings
    //   final result = await Request_Product_Detail.fetchRatings(
    //     widget.productSpuId,
    //   );
    //   setState(() {
    //     ratings = result;
    //     isLoadingRatings = false;
    //   });
    // } catch (e) {
    //   setState(() {
    //     isLoadingRatings = false;
    //   });
    // }
  }

  Future<void> submitRating() async {
    if (_userRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng chọn số sao đánh giá')));
      return;
    }

    try {
      // TODO: Implement API call to submit rating
      // await Request_Product_Detail.submitRating(
      //   widget.productSpuId,
      //   _userRating,
      //   _ratingCommentController.text,
      // );

      _ratingCommentController.clear();
      _userRating = 0;
      loadRatings(); // Reload ratings after submission

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cảm ơn bạn đã đánh giá sản phẩm')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Có lỗi xảy ra khi gửi đánh giá')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isRatingsExpanded = !isRatingsExpanded;
              if (isRatingsExpanded && ratings.isEmpty) {
                loadRatings();
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đánh giá sản phẩm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  isRatingsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (isRatingsExpanded) ...[
          // Rating input form
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Viết đánh giá của bạn",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _userRating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _userRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _ratingCommentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Viết nhận xét của bạn về sản phẩm...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF28804F),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: submitRating,
                    child: Text(
                      "Gửi đánh giá",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Ratings list
          if (isLoadingRatings)
            Center(child: CircularProgressIndicator())
          else if (ratings.isEmpty)
            Center(
              child: Text(
                "Chưa có đánh giá nào cho sản phẩm này",
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final rating = ratings[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            rating.avatar != null && rating.avatar!.isNotEmpty
                                ? NetworkImage(
                                  Request_Order.getImageAVT(rating.avatar!),
                                )
                                : null,
                        child:
                            rating.avatar == null || rating.avatar!.isEmpty
                                ? Icon(Icons.person, color: Colors.grey[600])
                                : null,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  rating.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < rating.star
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                      size: 16,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              rating.comment.isEmpty
                                  ? "(Không có bình luận)"
                                  : rating.comment,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}
