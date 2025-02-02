import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/detail/body_of_detail_screen_widget.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

import '../../provider/detail/restaurant_detail_provider.dart';
import '../Error/error_page.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;
  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantDetailProvider>(context, listen: false)
          .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
      ),
      body:
          Consumer<RestaurantDetailProvider>(builder: (context, value, child) {
        return switch (value.resultState) {
          RestaurantDetailLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
          RestaurantDetailErrorState(error: var message) => ErrorPage(
              errorMessage: message,
              onRetry: () {
                context.read<RestaurantListProvider>().fetchRestaurantList();
              },
            ),
          RestaurantDetailLoadedState(data: var restaurants) =>
            BodyOfDetailScreenWidget(restaurant: restaurants),
          _ => const SizedBox(),
        };
      }),
    );
  }
}
