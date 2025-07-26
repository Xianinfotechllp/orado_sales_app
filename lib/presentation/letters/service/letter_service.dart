import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/termination_model.dart';
import '../model/warning_model.dart';

class LetterService {
  final String baseUrl = 'https://orado-backend.onrender.com';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<TerminationModel?> fetchTerminationInfo() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/agent/termination-info'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TerminationModel.fromJson(data['termination']);
    }
    return null;
  }

  Future<List<WarningModel>> fetchWarnings() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/agent/warnings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['warnings'] as List)
          .map((e) => WarningModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
