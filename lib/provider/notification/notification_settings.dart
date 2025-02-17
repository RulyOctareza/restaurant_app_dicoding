import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _notificationTimeKey = 'notification_time';

  // Cek apakah notifikasi aktif
  static Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? true; // Default aktif
  }

  // Set status notifikasi (aktif/tidak aktif)
  static Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);
  }

  // Ambil waktu notifikasi
  static Future<TimeOfDay> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString =
        prefs.getString(_notificationTimeKey) ?? '11:00'; // Default pukul 11:00
    final timeParts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  // Set waktu notifikasi
  static Future<void> setNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _notificationTimeKey,
      '${time.hour}:${time.minute}',
    );
  }
}
