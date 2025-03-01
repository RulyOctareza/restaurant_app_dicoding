import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_category_model.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_menu_model.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_model.dart';
import 'package:restaurant_app/data/model/restaurant/restaurant_review.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

import 'restoran_provider_test.mocks.dart';

@GenerateMocks([ApiServices])
void main() {
  late RestaurantListProvider provider;
  late MockApiServices mockApiService;

  final testRestaurant = Restaurant(
      id: "rqdv5juczeskfw1e867",
      name: "Melting Pot",
      description: "Lorem ipsum",
      pictureId: "14",
      city: "Medan",
      rating: 4.2,
      address: "Jln. Pandeglang no 19",
      categories: [Category(name: "Italia"), Category(name: "Modern")],
      menus: Menus(foods: [], drinks: []),
      customerReviews: [
        CustomerReview(
            name: "Ahmad",
            review: "Tidak rekomendasi untuk pelajar!",
            date: "13 November 2019")
      ]);

  final successResponse = RestaurantListResponse(
      error: false,
      message: "success",
      count: 1,
      restaurants: [testRestaurant]);

  final errorResponse = RestaurantListResponse(
      error: true, message: "Failed to load data", count: 0, restaurants: []);

  setUp(() {
    mockApiService = MockApiServices();
    provider = RestaurantListProvider(mockApiService);
  });

  group('Restaurant List Provider Test', () {
    test('initial state should be none', () {
      expect(provider.resultState, isA<RestaurantListNoneState>());
    });

    test('should change state to loading when fetching data', () async {
      when(mockApiService.getRestaurantList())
          .thenAnswer((_) async => successResponse);

      provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListLoadingState>());
    });

    test('should have error state when API returns error', () async {
      when(mockApiService.getRestaurantList())
          .thenAnswer((_) async => errorResponse);

      await provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListErrorState>());
      final state = provider.resultState as RestaurantListErrorState;
      expect(state.error.toString(), "Failed to load data");
    });

    test('should have error state when exception occurs', () async {
      when(mockApiService.getRestaurantList())
          .thenThrow(Exception('No Internet Connection'));

      await provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListErrorState>());
      final state = provider.resultState as RestaurantListErrorState;
      expect(state.error.toString(), "Exception: No Internet Connection");
    });
  });
}
