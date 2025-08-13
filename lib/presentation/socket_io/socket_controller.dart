import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/presentation/socket_io/socket_service.dart';
import 'package:demo/services/device_info_service.dart';
import 'package:demo/services/notification_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:root_check_flutter/root_check_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketController extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  Timer? _locationUpdateTimer;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connectSocket() async {
    if (_isConnected) return; // Already connected

    log('Connecting socket...', name: 'Socket');

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('agentId');
      const userType = 'agent';

      if (userId == null || userId.isEmpty) {
        throw Exception('Agent ID not found in SharedPreferences');
      }

      await _socketService.connect(
        userId: userId,
        userType: userType,
        onConnect: () {
          _isConnected = true;
          notifyListeners();
          log('Socket connected successfully', name: 'Socket');
          _startLocationUpdates(userId: userId);
        },
        onDisconnect: () {
          _isConnected = false;
          _stopLocationUpdates();
          notifyListeners();
          log('Socket disconnected', name: 'Socket');
        },
        onError: (error) {
          _isConnected = false;
          _stopLocationUpdates();
          notifyListeners();
          log('Socket error during connection: $error', name: 'Socket');
        },
        onOrderAssigned: (data) async {
          log('Order assigned data received: $data', name: 'Socket');
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
      _stopLocationUpdates();
      notifyListeners();
      log('Socket connection error: $e', name: 'Socket');
      rethrow;
    }
  }

  void _startLocationUpdates({required String userId}) {
    _stopLocationUpdates(); // Stop any existing timer

    _locationUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        final deviceInfo = await _getDeviceInfo(userId);

        _socketService.emitAgentLocation(
          agentId: userId,
          lat: position.latitude,
          lng: position.longitude,
          deviceInfo: deviceInfo,
        );

        _socketService.instance?.emit('agentStatusUpdate', {
          'agentId': userId,
          'availabilityStatus': 'available',
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          'deviceInfo': deviceInfo,
        });
      } catch (e) {
        log('Error getting/sending location: $e', name: 'Socket');
      }
    });
  }

  void _stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  void disconnectSocket() {
    _stopLocationUpdates();
    _socketService.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  // Helper method to get device info in the required format
  Future<Map<String, dynamic>> _getDeviceInfo(String agentId) async {
    final deviceInfo = DeviceInfoPlugin();
    final battery = Battery();
    final connectivity = Connectivity();

    Map<String, dynamic> info = {};

    try {
      String deviceId = '';
      String os = Platform.operatingSystem;
      String osVersion = '';
      String model = '';
      String appVersion = '';
      int batteryLevel = await battery.batteryLevel;
      String networkType = '';
      String timezone = await FlutterTimezone.getLocalTimezone();
      bool locationEnabled = await Geolocator.isLocationServiceEnabled();
      bool isRooted = await RootCheckFlutter.isDeviceRooted;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id ?? '';
        osVersion = androidInfo.version.release ?? '';
        model = androidInfo.model ?? '';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        osVersion = iosInfo.systemVersion ?? '';
        model = iosInfo.utsname.machine ?? '';
      }

      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;

      final connectivityResult = await connectivity.checkConnectivity();
      networkType =
          (connectivityResult == ConnectivityResult.wifi)
              ? "WiFi"
              : (connectivityResult == ConnectivityResult.mobile)
              ? "Mobile"
              : "None";

      info = {
        "agent": agentId,
        "deviceId": deviceId,
        "os": os,
        "osVersion": osVersion,
        "appVersion": appVersion,
        "model": model,
        "batteryLevel": batteryLevel,
        "networkType": networkType,
        "timezone": timezone,
        "locationEnabled": locationEnabled,
        "isRooted": isRooted,
      };
    } catch (e) {
      log("❌ Error getting device info: $e");
    }

    return info;
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    _socketService.disconnect();
    super.dispose();
  }

  io.Socket? get socket => _socketService.instance;
}
