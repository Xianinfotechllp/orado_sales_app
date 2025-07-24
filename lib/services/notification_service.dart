import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Create notification channel for Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_channel',
      'Order Notifications',
      description: 'Notifications for new orders and updates',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && context.mounted) {
          Navigator.of(context).pushNamed('/order-details', arguments: payload);
        }
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'order_channel',
        'Order Notifications',
        channelDescription: 'Notifications for new orders and updates',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
        visibility: NotificationVisibility.public,
      );

      NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformDetails,
        payload: payload,
      );
    } catch (e) {
      log('Error showing notification: $e');
    }
  }
}
