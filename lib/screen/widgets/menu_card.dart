import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class MenuCard extends StatelessWidget {
  final Menus menus;

  const MenuCard({required this.menus, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foods :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ...menus.foods.map((food) => Chip(
                      label: Text(food.name),
                    )),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Drinks :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Wrap(
              spacing: 4,
              children: [
                ...menus.drinks.map((drink) => Chip(
                      label: Text(drink.name),
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
