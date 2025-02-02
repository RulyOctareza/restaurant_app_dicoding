import 'package:restaurant_app/data/model/restaurant/restaurant_review_dart';

import 'restaurant_category_model.dart';
import 'restaurant_menu_model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final String address;
  final List<Category>? categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.address,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      categories: json['categories'] == null
          ? []
          : List<Category>.from(
              (json['categories'] as List).map((x) => Category.fromJson(x))),
      menus: json['menus'] != null
          ? Menus.fromJson(json['menus']) // Parse menus if not null
          : Menus(foods: [], drinks: []), // Provide default value if null
      customerReviews: json['customerReviews'] == null
          ? []
          : List<CustomerReview>.from(
              json['customerReviews'].map((x) => CustomerReview.fromJson(x))),
    );
  }

  String get imageUrlsmall {
    final url = 'https://restaurant-api.dicoding.dev/images/small/$pictureId';
    return url;
  }

  String get imageUrllarge {
    final url = 'https://restaurant-api.dicoding.dev/images/small/$pictureId';
    return url;
  }
}
