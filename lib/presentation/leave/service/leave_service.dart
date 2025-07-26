// services/leave_service.dart

import 'dart:convert';
import 'package:demo/presentation/leave/model/leave_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveService {
  static const String _baseUrl =
      'https://orado-backend.onrender.com/agent/leave';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<LeaveStatusResponse> getLeaveStatus() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return LeaveStatusResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load leave status: ${response.statusCode}');
    }
  }

  Future<String> applyForLeave(LeaveApplication leave) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/apply'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(leave.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['message'];
    } else {
      throw Exception('Failed to apply for leave: ${response.statusCode}');
    }
  }
}
