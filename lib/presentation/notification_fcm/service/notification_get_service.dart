import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/notification_fcm/model/notification_get_model.dart';
import 'package:http/http.dart' as http;

class NotificationGetService {
  final String url =
      'https://orado-backend.onrender.com/agent/agent-notifications/687789831759259f3fb25c67';

  Future<NotificationGetModel?> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return notificationGetModelFromJson(response.body);
      } else {
        log("Failed to load notifications: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error fetching notifications: $e");
      return null;
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    final url =
        'https://orado-backend.onrender.com/agent/mark-as-read/$notificationId';

    try {
      final response = await http.put(Uri.parse(url));
      if (response.statusCode == 200) {
        log("Notification $notificationId marked as read.");
        return true;
      } else {
        log("Failed to mark as read: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error in markAsRead: $e");
      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    final url =
        'https://orado-backend.onrender.com/agent/agent-notifications/$notificationId';

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        log("Notification $notificationId deleted.");
        return true;
      } else {
        log("Failed to delete: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error deleting notification: $e");
      return false;
    }
  }
}
