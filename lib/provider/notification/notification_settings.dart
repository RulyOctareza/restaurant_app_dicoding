import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _notificationTimeKey = 'notification_time';

  
  static Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? true; 
  }

  
  static Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);
  }

  
  static Future<TimeOfDay> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString =
        prefs.getString(_notificationTimeKey) ?? '11:00'; 
    final timeParts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  
  static Future<void> setNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _notificationTimeKey,
      '${time.hour}:${time.minute}',
    );
  }
}
