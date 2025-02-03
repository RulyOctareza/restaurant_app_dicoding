import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_model.dart';
import 'package:restaurant_app/provider/reviews/add_review_provider.dart';
import 'package:restaurant_app/screen/widgets/add_review_form.dart';
import 'package:restaurant_app/screen/widgets/category_card.dart';
import 'package:restaurant_app/screen/widgets/menu_card.dart';
import 'package:restaurant_app/screen/widgets/review_card.dart';
import 'package:restaurant_app/style/typhography/restaurant_text_style.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  final Restaurant restaurant;
  const BodyOfDetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddReviewProvider>(context, listen: false)
          .setReviews(widget.restaurant.customerReviews);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider =
        Provider.of<AddReviewProvider>(context, listen: false);

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: 'restaurant-image-${widget.restaurant.id}',
                  child: Image.network(
                    widget.restaurant.imageUrllarge,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: regularTextStyle.copyWith(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.restaurant.city,
                            style: regularTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.restaurant.address,
                        style: regularTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      CategoryCard(
                          categories: widget.restaurant.categories ?? []),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icon_star.png',
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox.square(dimension: 9),
                      Text(
                        widget.restaurant.rating.toString(),
                        style: regularTextStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox.square(dimension: 8),
              Text(
                widget.restaurant.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
              ),
              const SizedBox(
                height: 12,
              ),
              MenuCard(menus: widget.restaurant.menus),
              ReviewCard(reviews: context.watch<AddReviewProvider>().reviews),
              AddReviewForm(
                onSubmit: (
                  name,
                  review,
                ) async {
                  try {
                    await reviewProvider.addReview(
                        widget.restaurant.id, name, review);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Review berhasil ditambahkan!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menambahkan review: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
