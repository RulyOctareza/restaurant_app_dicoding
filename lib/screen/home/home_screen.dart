import 'package:flutter/material.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widgets.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

import '../../provider/theme/theme_provider.dart';
import '../../static/navigation_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) {
        return;
      }
      await context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: themeProvider.isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(builder: (context, value, child) {
        return switch (value.resultState) {
          RestaurantListLoadedState(data: var restautantList) =>
            ListView.builder(
              itemCount: restautantList.length,
              itemBuilder: (context, index) {
                final restaurant = restautantList[index];

                return RestaurantCardWidgets(
                  restaurants: restaurant,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.name,
                      arguments: restaurant.id,
                    );
                  },
                );
              },
            ),
          RestaurantListErrorState(error: var message) => Center(
              child: Text(message),
            ),
          _ => const SizedBox(),
        };
      }),
    );
  }
}
