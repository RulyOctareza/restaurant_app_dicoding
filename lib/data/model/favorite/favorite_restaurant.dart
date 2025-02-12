class FavoriteRestaurant {
  final String id;
  final String name;
  final String city;
  final String pictureUrl;
  final double rating;

  FavoriteRestaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.pictureUrl,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'pictureUrl': pictureUrl,
      'rating': rating,
    };
  }

  factory FavoriteRestaurant.fromMap(Map<String, dynamic> map) {
    return FavoriteRestaurant(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      pictureUrl: map['pictureUrl'],
      rating: map['rating'],
    );
  }
}
