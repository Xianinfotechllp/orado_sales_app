import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo/presentation/user/model/user_model.dart';

class AgentProfileService {
  final String baseUrl;

  AgentProfileService({required this.baseUrl});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
      'userToken',
    ); // Replace 'token' with actual key
    if (token == null) {
      throw Exception('Token not found in SharedPreferences.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<AgentProfile> fetchAgentProfile(String agentId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/agent/$agentId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return AgentProfile.fromJson(data['data']);
      } else {
        throw Exception('Failed to load agent profile: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load agent profile: ${response.statusCode}');
    }
  }

  Future<bool> updateAgentStatus(
    String agentId,
    String status,
    String availabilityStatus,
  ) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/agent/$agentId/status'),
      headers: headers,
      body: json.encode({
        'status': status,
        'availabilityStatus': availabilityStatus,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Failed to update agent status: ${response.statusCode}');
    }
  }
}
