import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class MenuCard extends StatelessWidget {
  final Menus menus;

  const MenuCard({required this.menus, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foods',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: menus.foods
                .map((food) => ListTile(
                      title: Text(food.name),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Drinks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: menus.drinks
                .map((drink) => ListTile(
                      title: Text(drink.name),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
