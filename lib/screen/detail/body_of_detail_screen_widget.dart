import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_model.dart';
import 'package:restaurant_app/screen/widgets/category_card.dart';
import 'package:restaurant_app/screen/widgets/menu_card.dart';
import 'package:restaurant_app/screen/widgets/review_card.dart';
import 'package:restaurant_app/style/typhography/restaurant_text_style.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  const BodyOfDetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: 'restaurant-image-${restaurant.id}',
                  child: Image.network(
                    restaurant.imageUrllarge,
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
                        restaurant.name,
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
                            restaurant.city,
                            style: regularTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        restaurant.address,
                        style: regularTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      CategoryCard(categories: restaurant.categories ?? []),
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
                        restaurant.rating.toString(),
                        style: regularTextStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox.square(dimension: 8),
              Text(
                restaurant.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
              ),
              const SizedBox(
                height: 12,
              ),
              MenuCard(menus: restaurant.menus),
              ReviewCard(reviews: restaurant.customerReviews),
            ],
          ),
        ),
      ),
    );
  }
}
