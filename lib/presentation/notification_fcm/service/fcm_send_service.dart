// services/fcm_token_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/notification_fcm/model/fcm_model.dart';
import 'package:http/http.dart' as http;

class FCMTokenService {
  static const String _baseUrl = 'https://orado-backend.onrender.com';
  static const String _saveTokenEndpoint = '/agent/save-fcm-token';

  Future<bool> saveFCMToken(FCMTokenModel tokenData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_saveTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers like authorization if needed
          // 'Authorization': 'Bearer $yourToken',
        },
        body: jsonEncode(tokenData.toJson()),
      );

      if (response.statusCode == 200) {
        // Assuming your API returns success on 200
        return true;
      } else {
        // Handle different status codes as needed
        log('Failed to save FCM token. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error saving FCM token: $e');
      return false;
    }
  }
}
