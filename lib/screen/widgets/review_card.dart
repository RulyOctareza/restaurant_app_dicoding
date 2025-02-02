import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class ReviewCard extends StatelessWidget {
  final List<CustomerReview> reviews;

  const ReviewCard({required this.reviews, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: reviews
                  .map((review) => ListTile(
                        title: Text(review.name),
                        subtitle: Text(review.review),
                        trailing: Text(review.date),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
