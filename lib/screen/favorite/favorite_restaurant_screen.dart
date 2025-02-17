import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/favorite/favorite_restaurant_provider.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Restaurants")),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.favoriteRestaurants.isEmpty) {
            return const Center(child: Text("Belum ada restoran favorit"));
          }

          return ListView.builder(
            itemCount: favoriteProvider.favoriteRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = favoriteProvider.favoriteRestaurants[index];
              return ListTile(
                leading: Image.network(restaurant.pictureUrl,
                    errorBuilder: (_, __, ___) {
                  return const Icon(Icons.error_outline);
                }, width: 70, height: 70, fit: BoxFit.cover),
                title: Text(restaurant.name),
                subtitle: Row(
                  children: [
                    Text(restaurant.city),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text((restaurant.rating.toString())),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    favoriteProvider.removeFavorite(restaurant.id);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(restaurantId: restaurant.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
