import 'package:fashionshop_app/RequestAPI/Request_Order.dart';
import 'package:fashionshop_app/RequestAPI/api_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackForm extends StatefulWidget {
  final List<String> productsSpuId;
  const FeedbackForm({super.key, required this.productsSpuId});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int _star = 5;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    setState(() {
      _isSubmitting = true;
    });

    final success = await Request_Order.feedBack(
      widget.productsSpuId,
      _commentController.text,
      _star,
      ApiService.token,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit feedback'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Đánh giá sản phẩm",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Trải nghiệm của bạn như thế nào?",
              style: TextStyle(fontSize: 16, color: Colors.black38),
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: _star.toDouble(),
              minRating: 1,
              maxRating: 5,
              itemCount: 5,
              glow: true,
              glowRadius: 2,
              itemSize: 48,
              allowHalfRating: false,
              itemBuilder:
                  (context, _) =>
                      const Icon(Icons.star_rounded, color: Colors.amber),
              onRatingUpdate:
                  (rating) => setState(() => _star = rating.toInt()),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Hãy chia sẽ nhận xét cho sản phẩm này của bạn nhé",
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Hủy",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitFeedback,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              _isSubmitting
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text(
                    "Gửi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
