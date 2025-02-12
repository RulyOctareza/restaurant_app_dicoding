import 'package:flutter/material.dart';
import 'package:restaurant_app/data/database/database_helper.dart';

import 'package:restaurant_app/data/model/favorite/favorite_restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  FavoriteProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  List<FavoriteRestaurant> _favoriteRestaurants = [];
  List<FavoriteRestaurant> get favoriteRestaurants => _favoriteRestaurants;

  Future<void> _getFavorites() async {
    _favoriteRestaurants = await databaseHelper.getFavoriteRestaurants();
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteRestaurant restaurant) async {
    await databaseHelper.insertRestaurant(restaurant);
    _getFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await databaseHelper.deleteRestaurant(id);
    _getFavorites();
  }

  bool isFavorite(String id) {
    return _favoriteRestaurants.any((restaurant) => restaurant.id == id);
  }
}
