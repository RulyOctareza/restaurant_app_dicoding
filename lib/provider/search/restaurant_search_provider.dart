import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_model.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  List<Restaurant> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Restaurant> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> searchRestaurants(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          _searchResults = (data['restaurants'] as List)
              .map((restaurant) => Restaurant.fromJson(restaurant))
              .toList();
        } else {
          _errorMessage = 'Tidak ada hasil yang ditemukan.';
        }
      } else {
        _errorMessage = 'Gagal memuat data.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults.clear();
    _errorMessage = '';
    notifyListeners();
  }
}
