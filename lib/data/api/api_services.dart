import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';

class ApiServices {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  /// Mengambil daftar restoran
  Future<RestaurantListResponse> getRestaurantList() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/list'))
          .timeout(const Duration(seconds: 10)); // Tambahkan timeout

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load restaurant list (Code: ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('No Internet Connection');
    } on HttpException {
      throw Exception('Couldn\'t find the server');
    } on FormatException {
      throw Exception('Bad response format');
    }
  }

  /// Mengambil detail restoran berdasarkan ID
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http
          .get(Uri.parse("$_baseUrl/detail/$id"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load restaurant detail (Code: ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('No Internet Connection');
    } on HttpException {
      throw Exception('Couldn\'t find the server');
    } on FormatException {
      throw Exception('Bad response format');
    }
  }
}
