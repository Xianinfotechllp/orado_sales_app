// incentive_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/incentive/model/incentive_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IncentiveService {
  final String baseUrl = 'https://orado-backend.onrender.com';

  Future<IncentiveSummaryModel?> fetchIncentiveSummary(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final url = '$baseUrl/agent/incentive/summary?type=$type';

      log('Fetching incentive summary from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IncentiveSummaryModel.fromJson(data);
      } else {
        log('Failed to load incentive summary: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching incentive summary: $e');
      return null;
    }
  }
}
