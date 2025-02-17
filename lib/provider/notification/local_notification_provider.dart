import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/model/notifications/models/received_notification.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  bool? _permission = false;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

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

  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
}
