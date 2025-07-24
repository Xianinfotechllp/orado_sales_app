import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket; // Correct type declaration

  io.Socket? get instance => _socket; // Correct return type

  Future<void> connect({
    required String userId,
    required String userType,
    Function(dynamic data)? onOrderAssigned,
    Function()? onConnect,
    Function()? onDisconnect,
    Function(dynamic error)? onError,
  }) async {
    try {
      final url = 'https://orado-backend.onrender.com'; // Your backend URL

      _socket = io.io(
        // Use _socket here
        url,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .build(),
      );

      _socket!.onConnect((_) {
        // Use _socket! here
        log('✅ Connected to socket server');
        // Emit the 'join-room' event immediately after connection
        _socket!.emit('join-room', {
          // Use _socket! here
          'userId': userId,
          'userType': userType,
        });
        log('Emitted join-room event for userId: $userId, userType: $userType');
        if (onConnect != null) onConnect();
      });

      _socket!.onDisconnect((_) {
        // Use _socket! here
        log('❌ Disconnected from socket server');
        if (onDisconnect != null) onDisconnect();
      });

      _socket!.onError((data) {
        // Use _socket! here
        log('⚠ Socket error: $data');
        if (onError != null) onError(data);
      });

      _socket!.on('orderAssigned', (data) {
        // Use _socket! here
        log('📦 New order assigned: $data');
        if (onOrderAssigned != null) onOrderAssigned(data);
      });

      _socket!.connect(); // Use _socket! here
    } catch (e) {
      throw Exception('Socket connection error: $e');
    }
  }

  void disconnect() {
    _socket?.disconnect(); // Use _socket? here
    _socket = null;
    log('Socket disconnected explicitly.');
  }
}
