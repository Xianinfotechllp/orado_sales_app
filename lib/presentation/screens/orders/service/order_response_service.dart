// agent_order_response_service.dart
import 'dart:convert';
import 'package:demo/presentation/screens/orders/model/order_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AgentOrderResponseService {
  final String baseUrl = "https://orado-backend.onrender.com";

  Future<OrderResponseModel> respondToOrder({
    required String orderId,
    required String action,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    final url = Uri.parse("$baseUrl/agent/agent-order-response/$orderId");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add token here
      },
      body: jsonEncode({"action": action}),
    );

    if (response.statusCode == 200) {
      return OrderResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to respond: ${response.body}");
    }
  }
}
