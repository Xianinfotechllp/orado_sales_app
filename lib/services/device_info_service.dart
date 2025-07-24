import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:root_check_flutter/root_check_flutter.dart';
import 'package:http/http.dart' as http;

class DeviceInfoService {
  Future<void> sendDeviceInfo(String agentId) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final battery = Battery();
      final connectivity = Connectivity();

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

      final Map<String, dynamic> data = {
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

      final url = Uri.parse(
        'https://orado-backend.onrender.com/agent/device-info',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Device info sent successfully: ${response.body}');
      } else {
        log(
          '❌ Failed to send device info. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      log("❌ Exception sending device info: $e");
    }
  }
}
