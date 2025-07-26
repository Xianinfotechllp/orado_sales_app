import 'package:demo/presentation/notification_fcm/model/notification_get_model.dart';
import 'package:demo/presentation/notification_fcm/service/notification_get_service.dart';
import 'package:flutter/material.dart';

class NotificationController with ChangeNotifier {
  final NotificationGetService _service = NotificationGetService();

  List<Datum> _notifications = [];
  List<Datum> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.fetchNotifications();
    if (result != null && result.data != null) {
      _notifications = result.data!;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String id) async {
    bool success = await _service.markAsRead(id);
    if (success) {
      int index = _notifications.indexWhere((item) => item.id == id);
      if (index != -1) {
        _notifications[index].read = true;
        notifyListeners();
      }
    }
  }

  Future<void> deleteNotificationById(String id) async {
    bool success = await _service.deleteNotification(id);
    if (success) {
      _notifications.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }
}
