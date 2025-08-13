import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/earnings/model/earnings_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EarningsService {
  final String _baseUrl = 'https://orado-backend.onrender.com/agent/earning';

  Future<EarningsSummaryModel?> fetchEarningsSummary(String period) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      final uri = Uri.parse('$_baseUrl/summary?period=$period');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return EarningsSummaryModel.fromJson(data);
      } else {
        log('Failed to load summary: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
    return null;
  }

  Future<EarningsSummaryModel?> fetchCustomDateRangeSummary(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      final formattedStart = _formatDate(startDate);
      final formattedEnd = _formatDate(endDate);

      final uri = Uri.parse(
        '$_baseUrl/summary?startDate=$formattedStart&endDate=$formattedEnd',
      );
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return EarningsSummaryModel.fromJson(data);
      } else {
        log('Failed to load custom date range summary: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching custom date range: $e');
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
