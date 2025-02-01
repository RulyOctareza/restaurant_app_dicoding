import 'package:restaurant_app/data/model/restaurant_model.dart';

class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse(
      {required this.error,
      required this.count,
      required this.message,
      required this.restaurants});

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
        error: json['error'],
        count: json['count'],
        message: json['message'],
        restaurants: json['restaurants'] != null
            ? List<Restaurant>.from(
                json['restaurants']!.map((x) => Restaurant.fromJson(x)))
            : <Restaurant>[]);
  }
}
