import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/api_constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AgentAvailabilityService {
  Future<bool> updateAvailability({
    required String agentId,
    required String status,
    required double lat,
    required double lng,
    required double accuracy,
  }) async {
    final url = Uri.parse(ApiConstants.updateAvailability(agentId));

    final body = {
      "status": status,
      "location": {"lat": lat, "lng": lng, "accuracy": accuracy},
    };

    log('📤 Sending PUT request to $url');
    log('📦 Request Body: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      log('✅ Response Status: ${response.statusCode}');
      log('📨 Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      log(
        '❌ Error occurred during PUT request',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
