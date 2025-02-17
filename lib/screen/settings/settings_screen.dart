import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/notifications/models/received_notification.dart';
import 'package:restaurant_app/provider/notification/notification_settings.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/services/local_notification_service.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TimeOfDay _selectedTime = TimeOfDay.now(); // Waktu default
  bool _isNotificationEnabled = true; // Status notifikasi

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeNotifications();
    _createNotificationChannel(); // Buat channel notifikasi
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  // Memuat pengaturan dari SharedPreferences
  Future<void> _loadSettings() async {
    final isEnabled = await NotificationSettings.isNotificationEnabled();
    final notificationTime = await NotificationSettings.getNotificationTime();

    setState(() {
      _isNotificationEnabled = isEnabled;
      _selectedTime = notificationTime;
    });
  }

  // Inisialisasi notifikasi
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle ketika notifikasi diklik
        print('Notifikasi diklik: ${response.payload}');
      },
    );

    tz.initializeTimeZones(); // Inisialisasi data zona waktu
  }

  // Membuat channel notifikasi
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'meal_reminder_channel', // ID channel
      'Meal Reminder', // Nama channel
      importance: Importance.max,
      description: 'Channel untuk notifikasi pengingat makan siang',
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Konfigurasi stream untuk notifikasi yang dipilih
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, '/detail', arguments: payload);
    });
  }

  // Konfigurasi stream untuk notifikasi yang diterima
  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, '/detail',
          arguments: receivedNotification.payload);
    });
  }

  // Memilih waktu untuk notifikasi
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      await NotificationSettings.setNotificationTime(_selectedTime);
      if (_isNotificationEnabled) {
        await _scheduleNotification(_selectedTime);
      }
    }
  }

  // Menjadwalkan notifikasi
  Future<void> _scheduleNotification(TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Pastikan waktu yang dipilih tidak di masa lalu
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Ambil data acak dari API
    final randomMealInfo = await _fetchRandomMealInfo();

    // Konversi DateTime ke TZDateTime
    final tz.TZDateTime scheduledTZTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    // Atur notifikasi
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID notifikasi
      'Waktunya Makan Siang!', // Judul notifikasi
      randomMealInfo, // Pesan notifikasi (data acak dari API)
      scheduledTZTime, // Waktu notifikasi
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminder_channel', // ID channel
          'Meal Reminder', // Nama channel
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Jadwalkan notifikasi
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Mengambil data acak dari API
  Future<String> _fetchRandomMealInfo() async {
    final apiService = Provider.of<ApiServices>(context, listen: false);
    final restaurantList = await apiService.getRestaurantList();

    if (restaurantList.restaurants.isNotEmpty) {
      final randomIndex = Random().nextInt(restaurantList.restaurants.length);
      final randomRestaurant = restaurantList.restaurants[randomIndex];
      return 'Coba ${randomRestaurant.name} untuk makan siang!';
    } else {
      return 'Waktunya makan siang! Jangan lupa makan ya!';
    }
  }

  // Menampilkan notifikasi sekarang (untuk pengujian)
  Future<void> _testNotificationNow() async {
    print('Tombol Tes Notifikasi Sekarang diklik');
    try {
      final randomMealInfo = await _fetchRandomMealInfo();
      print('Data restoran acak: $randomMealInfo');

      await flutterLocalNotificationsPlugin.show(
        1, // ID notifikasi
        'Waktunya Makan Siang!', // Judul notifikasi
        randomMealInfo, // Pesan notifikasi
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meal_reminder_channel', // ID channel
            'Meal Reminder', // Nama channel
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
      print('Notifikasi berhasil ditampilkan');
    } catch (e) {
      print('Error menampilkan notifikasi: $e');
    }
  }

  // Mengaktifkan/menonaktifkan notifikasi
  Future<void> _toggleNotification(bool enabled) async {
    setState(() {
      _isNotificationEnabled = enabled;
    });
    await NotificationSettings.setNotificationEnabled(enabled);

    if (enabled) {
      await _scheduleNotification(_selectedTime);
    } else {
      await flutterLocalNotificationsPlugin.cancel(0); // Batalkan notifikasi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Atur Waktu Notifikasi Makan Siang'),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Aktifkan Notifikasi'),
            value: _isNotificationEnabled,
            onChanged: _toggleNotification,
          ),
          ElevatedButton(
            onPressed: () => _selectTime(context),
            child: Text(
              "Atur Waktu Notifikasi: ${_selectedTime.format(context)}",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _testNotificationNow,
            child: const Text('Tes Notifikasi Sekarang'),
          ),
        ],
      ),
    );
  }
}
