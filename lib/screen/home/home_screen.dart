import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_restaurant_screen.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widgets.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import '../../provider/notification/local_notification_provider.dart';
import '../Error/error_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermission();
    });

    Future.microtask(() async {
      if (!mounted) {
        return;
      }
      await context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant List',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/searchpage');
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: themeProvider.isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantListLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantListLoadedState(data: var restaurantList) =>
              ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];
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
            RestaurantListErrorState(error: var message) => ErrorPage(
                errorMessage: message,
                onRetry: () {
                  context.read<RestaurantListProvider>().fetchRestaurantList();
                },
              ),
            _ => const Center(
                child: Text('Tidak ada data yang tersedia.'),
              ),
          };
        },
      ),
    );
  }
}
