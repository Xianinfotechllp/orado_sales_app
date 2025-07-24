import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo/presentation/notification_fcm/controller/fcm_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMHandler {
  final FCMTokenController _tokenController = FCMTokenController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final FlutterTts flutterTts = FlutterTts();
  // Initialize FCM
  Future<void> initialize() async {
    await Firebase.initializeApp();
    _setupLocalNotifications();
    await _setupFCM();
  }

  // Set up local notifications
  void _setupLocalNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Set up FCM and handle tokens
  Future<void> _setupFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Directly call method that gets token and sends to server
    await _sendTokenToServer();

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log('FCM Token refreshed: $newToken');
      await _sendTokenToServer(); // Automatically fetches the latest token
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        _showNotification(message);
        _speak("New order arrived");
      }
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  }

  // Updated to fetch token internally
  Future<void> _sendTokenToServer() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token == null) {
        log('FCM token is null');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      String? agentId = prefs.getString('agentId');

      if (agentId == null || agentId.isEmpty) {
        log('Agent ID not found in SharedPreferences');
        return;
      }

      bool success = await _tokenController.saveTokenToServer(
        agentId: agentId,
        fcmToken: token,
      );

      if (success) {
        log('FCM token successfully saved to server for agent $agentId');
      } else {
        log('Failed to save FCM token to server for agent $agentId');
      }
    } catch (e) {
      log('Error sending FCM token to server: $e');
    }
  }

  // Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  // Background message handler
  @pragma('vm:entry-point')
  static Future<void> _firebaseBackgroundMessageHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
    // You can add your background notification handling here
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
