// lib/presentation/screens/home/orders/service/order_details_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:demo/presentation/screens/home/orders/model/agent_delivery_status.dart';
import 'package:http/http.dart' as http;
import '../model/order_details_model.dart';

class OrderDetailsService {
  Future<Order?> fetchOrderDetails({
    required String orderId,
    required String token,
  }) async {
    final url = Uri.parse(
      'https://orado-backend.onrender.com/agent/assigned-orders/$orderId',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      log(
        'Order Details API Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "success") {
          return OrderDetailsModel.fromJson(data).order;
        } else {
          log('API returned non-success status: ${data['message']}');
        }
      } else {
        log('Failed with status code: ${response.statusCode}');
        throw Exception('Failed to load order details: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching order details: $e');
      throw Exception('Failed to load order details: $e');
    }
    return null;
  }

  // Add this method to your OrderDetailsService class
  Future<UpdateStatusResponse?> updateDeliveryStatus({
    required String orderId,
    required String status,
    required String token,
  }) async {
    final url = Uri.parse(
      'https://orado-backend.onrender.com/agent/agent-delivery-status/$orderId',
    );

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      log(
        'Update Status API Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UpdateStatusResponse.fromJson(data);
      } else {
        log('Failed with status code: ${response.statusCode}');
        throw Exception('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error updating delivery status: $e');
      throw Exception('Failed to update status: $e');
    }
  }

  //   Future<bool> updateOrderStatus({
  //     required String orderId,
  //     required String status,
  //     required String token,
  //   }) async {
  //     final url = Uri.parse(
  //       'https://orado-backend.onrender.com/agent/agent-delivery-status/$orderId',
  //     );

  //     try {
  //       final response = await http.put(
  //         url,
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Accept': 'application/json',
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({'status': status}),
  //       );

  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         return data['status'] == "success";
  //       }
  //       return false;
  //     } catch (e) {
  //       log('Error updating order status: $e');
  //       return false;
  //     }
  //   }
}
