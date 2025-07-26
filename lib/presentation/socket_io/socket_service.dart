import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;

  io.Socket? get instance => _socket;

  Future<void> connect({
    required String userId,
    required String userType,
    Function(dynamic data)? onOrderAssigned,
    Function()? onConnect,
    Function()? onDisconnect,
    Function(dynamic error)? onError,
  }) async {
    try {
      final url = 'https://orado-backend.onrender.com';

      _socket = io.io(
        url,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .build(),
      );

      // Corrected event handlers without type casting
      _socket!.onConnect((_) {
        log('✅ Connected to socket server');
        _socket!.emit('join-room', {'userId': userId, 'userType': userType});
        log('📢 Emitted join-room for userId: $userId, userType: $userType');
        onConnect?.call();
      });

      _socket!.onDisconnect((_) {
        log('❌ Disconnected from socket server');
        onDisconnect?.call();
      });

      _socket!.onError((error) {
        log('⚠ Socket error: $error');
        onError?.call(error);
      });

      _socket!.on('orderAssigned', (data) {
        log('📦 New order assigned: $data');
        onOrderAssigned?.call(data);
      });

      _socket!.connect();
    } catch (e) {
      throw Exception('Socket connection error: $e');
    }
  }

  void emitAgentLocation({
    required String agentId,
    required double lat,
    required double lng,
    required Map<String, dynamic> deviceInfo,
  }) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('agent:location', {
        'agentId': agentId,
        'lat': lat,
        'lng': lng,
        'deviceInfo': deviceInfo,
      });
      log(
        '📍 Emitted agent:location => agentId: $agentId, lat: $lat, lng: $lng, deviceInfo: $deviceInfo',
      );
    } else {
      log('⚠ Socket not connected. Cannot emit agent location.');
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    log('🔌 Socket disconnected manually.');
  }
}
