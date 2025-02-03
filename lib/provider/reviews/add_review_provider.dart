import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/model/restaurant/restaurant_review.dart';

class AddReviewProvider extends ChangeNotifier {
  List<CustomerReview> _reviews = [];

  List<CustomerReview> get reviews => _reviews;

  Future<void> addReview(
      String restaurantId, String name, String review) async {
    final url = Uri.parse('https://restaurant-api.dicoding.dev/review');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': restaurantId, 'name': name, 'review': review}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['customerReviews'] != null) {
          final List<CustomerReview> updatedReviews =
              (responseData['customerReviews'] as List)
                  .map((review) =>
                      CustomerReview.fromJson(review as Map<String, dynamic>))
                  .toList();
          _reviews = updatedReviews;
          notifyListeners();
        } else {
          throw Exception('Customer reviews tidak ditemukan dalam response');
        }
      } else {
        throw Exception('Gagal menambahkan review: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Terjadi kesalahan: $error');
    }
  }

  void setReviews(List<CustomerReview> reviews) {
    _reviews = reviews;
    notifyListeners();
  }
}
