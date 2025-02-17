import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/database/database_helper.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/favorite/favorite_restaurant_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/notification/notification_provider.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/provider/reviews/add_review_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/search/search_page.dart';
import 'package:restaurant_app/screen/settings/settings_screen.dart';
import 'package:restaurant_app/services/http_service.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/theme/restaurant_theme.dart';
import 'data/api/api_services.dart';
import 'provider/main/index_nav_provider.dart';
import 'screen/home/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String? payload;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails!.notificationResponse;
    NavigationRoute.homeRoute;
    payload = notificationResponse?.payload;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => IndexNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
            create: (_) => FavoriteProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => AddReviewProvider()),
        Provider(
          create: (_) => ApiServices(),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantListProvider(
            context.read<ApiServices>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            context.read<ApiServices>(),
          ),
        ),
        Provider(
          create: (context) => HttpService(),
        ),
        Provider(
          create: (context) => LocalNotificationService(
            context.read<HttpService>(),
          )..init(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(
            flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
            apiServices: ApiServices(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PayloadProvider(
            payload: payload,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Restaurant App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: NavigationRoute.homeRoute.name,
      routes: {
        NavigationRoute.homeRoute.name: (context) => const HomeScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId:
                  ModalRoute.of(context)?.settings.arguments as String? ?? '',
            ),
        NavigationRoute.searchPage.name: (context) => const SearchPage(),
        NavigationRoute.settingScreen.name: (context) => const SettingsScreen(),
      },
    );
  }
}
