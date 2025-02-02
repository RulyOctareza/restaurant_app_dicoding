import 'package:flutter/material.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typhography/restaurant_text_style.dart';

import '../../data/model/restaurant_model.dart';

class CategoryCard extends StatelessWidget {
  final List<Category> categories;

  const CategoryCard({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Categories :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                children: categories
                    .map((category) => Chip(
                          color: const WidgetStatePropertyAll(Colors.black12),
                          label: Text(
                            category.name,
                            style: regularTextStyle.copyWith(color: blackColor),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
