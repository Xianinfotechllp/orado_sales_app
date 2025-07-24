import 'dart:developer';

import 'package:demo/presentation/socket_io/socket_service.dart';
import 'package:demo/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketController extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connectSocket() async {
    developer.log('Connecting socket...', name: 'Socket');

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('agentId'); // Get the agentId
      const userType = 'agent';

      if (userId == null || userId.isEmpty) {
        throw Exception('Agent ID not found in SharedPreferences');
      }

      log('Attempting to connect with userId: $userId, userType: $userType');

      await _socketService.connect(
        userId: userId,
        userType: userType,
        onConnect: () {
          _isConnected = true;
          notifyListeners();
          developer.log('Socket connected successfully', name: 'Socket');
        },
        onDisconnect: () {
          _isConnected = false;
          notifyListeners();
          developer.log('Socket disconnected', name: 'Socket');
        },
        onError: (error) {
          _isConnected = false;
          notifyListeners();
          developer.log(
            'Socket error during connection: $error',
            name: 'Socket',
          );
        },
        onOrderAssigned: (data) async {
          // Handle the received orderAssigned data here
          log('Order assigned data received: $data', name: 'Socket');
          // You might want to update your UI or state with this new order
          // For example, if you have a list of assigned orders in your controller:
          // _assignedOrders.add(data);

          await NotificationService.showNotification(
            title: 'New Order Assigned',
            body: 'Tap to view order details',
            payload: data['orderId'].toString(),
          );
          notifyListeners();
        },
      );
    } catch (e) {
      _isConnected = false;
      notifyListeners();
      developer.log('Socket connection error: $e', name: 'Socket');
      rethrow;
    }
  }

  void disconnectSocket() {
    _socketService.disconnect();
    _isConnected = false;
    notifyListeners();
    developer.log('Socket disconnected', name: 'Socket');
  }

  // You can expose the socket instance if needed for sending other events
  io.Socket? get socket => _socketService.instance;
}
