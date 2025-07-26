import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import 'package:demo/presentation/notification_fcm/controller/fcm_controller.dart';

class FCMHandler {
  final FCMTokenController _tokenController = FCMTokenController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final FlutterTts flutterTts = FlutterTts();

  // Initialize FCM, local notifications, and TTS
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _initTTS();
    _setupLocalNotifications();
    await _setupFCM();
  }

  Future<void> _initTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
  }

  void _setupLocalNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setupFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    await _sendTokenToServer();

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log('FCM Token refreshed: $newToken');
      await _sendTokenToServer();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Foreground message: ${message.data}');
      if (message.notification != null) {
        _showNotification(message);
        final String spokenText =
            message.notification?.title ?? "New notification received";
        await _speak(spokenText);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  }

  Future<void> _sendTokenToServer() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        log('FCM token is null');
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      // 🔐 Save token to SharedPreferences
      await prefs.setString('fcmToken', token);
      log('FCM token saved to SharedPreferences: $token');

      String? agentId = prefs.getString('agentId');

      if (agentId == null || agentId.isEmpty) {
        log('Agent ID not found');
        return;
      }

      // Send to server via controller
      bool success = await _tokenController.saveTokenToServer(
        agentId: agentId,
        fcmToken: token,
      );

      if (success) {
        log('Token saved to server successfully');
      } else {
        log('Failed to save token to server');
      }
    } catch (e) {
      log('Error sending token: $e');
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "Title",
      message.notification?.body ?? "Body",
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(text);
    } catch (e) {
      log("TTS error: $e");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseBackgroundMessageHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
  }
}
