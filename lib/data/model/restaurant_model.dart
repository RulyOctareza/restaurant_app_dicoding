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

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );
}

class Menus {
  final List<Food> foods;
  final List<Drink> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: List<Food>.from(json['foods'].map((x) => Food.fromJson(x))),
      drinks: List<Drink>.from(json['drinks'].map((x) => Drink.fromJson(x))),
    );
  }
}

class Food {
  final String name;

  Food({
    required this.name,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
    );
  }
}

class Drink {
  final String name;

  Drink({
    required this.name,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      name: json['name'],
    );
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}
