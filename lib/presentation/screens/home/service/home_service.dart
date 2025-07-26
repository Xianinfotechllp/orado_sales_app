// api_services.dart
import 'dart:convert';
import 'package:demo/presentation/screens/home/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; // Import for debugPrint

class AgentHomeService {
  final String baseUrl = 'https://orado-backend.onrender.com/agent/home-data';

  Future<AgentHomeModel?> fetchAgentHomeData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null || token.isEmpty) {
      debugPrint('Error: Authentication token not found in SharedPreferences.');
      throw Exception('Authentication required. Please log in.');
    }

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('API Response Status Code: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['status'] == 'success') {
          return AgentHomeModel.fromJson(jsonBody['data']);
        } else {
          // Backend returned 200 but with a 'status' other than 'success'
          final message = jsonBody['message'] ?? 'Unknown error from server';
          debugPrint('Backend reported: $message');
          throw Exception('Failed to fetch agent home data: $message');
        }
      } else if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized: Invalid or expired token. Please log in again.',
        );
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found.');
      } else {
        // Handle other HTTP status codes
        throw Exception(
          'Failed to fetch agent home data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("Error during API call: $e");
      // Re-throw to be caught by the provider
      rethrow;
    }
  }
}
