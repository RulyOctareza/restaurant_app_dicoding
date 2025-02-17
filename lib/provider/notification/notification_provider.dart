import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'dart:math';
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final ApiServices apiServices;

  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isNotificationEnabled = false;

  NotificationProvider({
    required this.flutterLocalNotificationsPlugin,
    required this.apiServices,
  });

  TimeOfDay get selectedTime => _selectedTime;
  bool get isNotificationEnabled => _isNotificationEnabled;

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setNotificationEnabled(bool enabled) {
    _isNotificationEnabled = enabled;
    notifyListeners();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    // initializeTimeZone();
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'meal_reminder_channel',
      'Meal Reminder',
      importance: Importance.max,
      description: 'Channel untuk notifikasi pengingat makan siang',
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleNotification(TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final randomMealInfo = await fetchRandomMealInfo();
    final tz.TZDateTime scheduledTZTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Waktunya Makan Siang!',
      randomMealInfo,
      scheduledTZTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminder_channel',
          'Meal Reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<String> fetchRandomMealInfo() async {
    final restaurantList = await apiServices.getRestaurantList();

    if (restaurantList.restaurants.isNotEmpty) {
      final randomIndex = Random().nextInt(restaurantList.restaurants.length);
      final randomRestaurant = restaurantList.restaurants[randomIndex];
      return 'Coba ${randomRestaurant.name} untuk makan siang!';
    } else {
      return 'Waktunya makan siang! Jangan lupa makan ya!';
    }
  }

  Future<void> testNotificationNow() async {
    try {
      final randomMealInfo = await fetchRandomMealInfo();

      await flutterLocalNotificationsPlugin.show(
        1,
        'Waktunya Makan Siang!',
        randomMealInfo,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meal_reminder_channel',
            'Meal Reminder',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      return;
    }
  }

  Future<void> toggleNotification(bool enabled) async {
    setNotificationEnabled(enabled);
    if (enabled) {
      await scheduleNotification(_selectedTime);
    } else {
      await flutterLocalNotificationsPlugin.cancel(0);
    }
  }
}
