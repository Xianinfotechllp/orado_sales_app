// lib/presentation/screens/home/orders/controller/order_detail_controller.dart
import 'dart:developer';
import 'package:demo/presentation/screens/orders/service/order_details_sevice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order_details_model.dart';

class OrderDetailController extends ChangeNotifier {
  final OrderDetailsService _service = OrderDetailsService();

  bool isLoading = false;
  Order? order;
  String? errorMessage;
  String? successMessage;

  Future<void> loadOrderDetails(String orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final Order? fetchedOrder = await _service.fetchOrderDetails(
        orderId: orderId,
        token: token,
      );

      if (fetchedOrder != null) {
        order = fetchedOrder;
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      errorMessage = e.toString();
      log('Error loading order details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String status) async {
    if (order == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final token = await _getUserToken(); // Extract token logic
      final response = await _service.updateDeliveryStatus(
        orderId: order!.id,
        status: status,
        token: token,
      );

      if (response != null && response.message != null) {
        successMessage = response.message!;
        await loadOrderDetails(order!.id);
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      log('Status update error: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Authentication token not found');
    return token;
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
