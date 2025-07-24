import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/screens/home/orders/model/product_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String _baseUrl =
      'https://orado-backend.onrender.com/agent/assigned-orders';

  Future<OrderModel?> fetchAssignedOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderModel.fromJson(jsonData);
      } else {
        log('Failed to fetch orders: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error in fetchAssignedOrders: $e');
      return null;
    }
  }
}
