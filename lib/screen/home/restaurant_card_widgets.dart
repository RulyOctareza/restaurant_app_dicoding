import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_model.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';

import '../../style/typhography/restaurant_text_style.dart';

class RestaurantCardWidgets extends StatelessWidget {
  final Restaurant restaurants;
  final VoidCallback onTap;

  const RestaurantCardWidgets(
      {super.key, required this.restaurants, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 130,
                height: 110,
                child: Stack(
                  children: [
                    Hero(
                        tag: 'restaurant-image-${restaurants.id}',
                        child: Image.network(restaurants.imageUrllarge)),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                          color: purpleColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon_star.png',
                              width: 22,
                              height: 22,
                            ),
                            Text(
                              restaurants.rating.toString(),
                              style: whiteTextStyle.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurants.name,
                    style: regularTextStyle.copyWith(
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    restaurants.description,
                    style: regularTextStyle.copyWith(
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Wrap(
                        children: [
                          const Icon(Icons.location_on),
                          Text(
                            restaurants.city,
                            style: regularTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
