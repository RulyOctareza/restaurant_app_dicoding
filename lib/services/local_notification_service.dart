import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/model/notifications/models/received_notification.dart';
import 'package:restaurant_app/services/http_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class LocalNotificationService {
  final HttpService httpService;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationService(this.httpService);

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final notificationEnabled = await _isAndroidPermissionGranted();
      if (!notificationEnabled) {
        final requestNotificationsPermission =
            await _requestAndroidNotificationsPermission();
        return requestNotificationsPermission;
      }
      return notificationEnabled;
    } else {
      return false;
    }
  }

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Metode untuk menjadwalkan notifikasi
  Future<void> scheduleNotification({
    required DateTime scheduledTime,
    required String title,
    required String body,
  }) async {
    // Konversi DateTime ke TZDateTime
    final tz.TZDateTime scheduledTZTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    // Atur notifikasi
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID notifikasi
      title, // Judul notifikasi
      body, // Pesan notifikasi
      scheduledTZTime, // Waktu notifikasi dalam TZDateTime
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminder_channel', // ID channel
          'Meal Reminder', // Nama channel
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Jadwalkan notifikasi
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Metode untuk mengambil data acak dari API
  Future<String> fetchRandomMealInfo() async {
    try {
      // Ambil daftar restoran dari API
      final response = await httpService
          .getDataFromUrl('https://restaurant-api.dicoding.dev/list');
      final data = jsonDecode(response);
      final restaurantListResponse = RestaurantListResponse.fromJson(data);

      if (restaurantListResponse.restaurants.isNotEmpty) {
        // Pilih restoran secara acak
        final random = Random();
        final randomIndex =
            random.nextInt(restaurantListResponse.restaurants.length);
        final randomRestaurant =
            restaurantListResponse.restaurants[randomIndex];

        // Kembalikan informasi restoran untuk notifikasi
        return 'Coba ${randomRestaurant.name} di ${randomRestaurant.city} untuk makan siang!';
      } else {
        return 'Tidak ada restoran yang tersedia. Silakan coba lagi nanti.';
      }
    } catch (e) {
      return 'Gagal mengambil data restoran. Silakan coba lagi nanti.';
    }
  }
}

Future<void> showNotificationNow({
  required String title,
  required String body,
}) async {
  await flutterLocalNotificationsPlugin.show(
    0, // ID notifikasi
    title, // Judul notifikasi
    body, // Pesan notifikasi
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'meal_reminder_channel', // ID channel
        'Meal Reminder', // Nama channel
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}

void backgroundHandler(NotificationResponse notificationResponse) {
  print("Received background notification: ${notificationResponse.payload}");
}
