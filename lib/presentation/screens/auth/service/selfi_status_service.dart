import 'dart:convert';
import 'package:demo/presentation/screens/auth/model/selfi_status_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelfieStatusService {
  final String baseUrl =
      'https://orado-backend.onrender.com/agent/selfie/status';

  Future<SelfieStatusModel?> fetchSelfieStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token == null) throw Exception('Token not found');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SelfieStatusModel.fromJson(data);
      } else {
        throw Exception('Failed to load status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
