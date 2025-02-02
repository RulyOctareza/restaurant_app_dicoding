import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class ReviewCard extends StatelessWidget {
  final List<CustomerReview> reviews;

  const ReviewCard({required this.reviews, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Customer Reviews :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Column(
          children: reviews
              .map((review) => Card(
                    color: Colors.amberAccent,
                    elevation: 3,
                    child: ListTile(
                      title: Text(review.name),
                      subtitle: Text(review.review),
                      trailing: Text(review.date),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
