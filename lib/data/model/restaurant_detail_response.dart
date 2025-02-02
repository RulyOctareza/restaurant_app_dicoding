import 'package:restaurant_app/data/model/restaurant_model.dart';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final Restaurant restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  // String toJson() => json.encode(toMap());

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResponse(
          error: json["error"],
          message: json["message"],
          restaurant: Restaurant.fromJson(json["restaurant"]));

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "restaurant": restaurant,
      };
}
