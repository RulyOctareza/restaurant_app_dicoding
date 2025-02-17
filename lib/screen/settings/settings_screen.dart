// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/notifications/models/received_notification.dart';
import 'package:restaurant_app/provider/notification/notification_provider.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/services/local_notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    provider.initializeNotifications();
    provider.createNotificationChannel();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, '/detail', arguments: payload);
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, '/detail',
          arguments: receivedNotification.payload);
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.selectedTime,
    );
    if (picked != null && picked != provider.selectedTime) {
      provider.setSelectedTime(picked);
      if (provider.isNotificationEnabled) {
        await provider.scheduleNotification(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Atur Waktu Notifikasi Makan Siang'),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Aktifkan Notifikasi'),
                value: provider.isNotificationEnabled,
                onChanged: (value) => provider.toggleNotification(value),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  "Atur Waktu Notifikasi: ${provider.selectedTime.format(context)}",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => provider.testNotificationNow(),
                child: const Text('Tes Notifikasi Sekarang'),
              ),
            ],
          );
        },
      ),
    );
  }
}
