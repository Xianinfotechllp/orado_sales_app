import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo/presentation/orders/model/product_model.dart';
import 'package:demo/presentation/orders/service/order_service.dart';

class OrderController with ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<AssignedOrder> _orders = [];
  List<AssignedOrder> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token == null) {
        _error = 'Token not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final orderModel = await _orderService.fetchAssignedOrders(token);

      if (orderModel != null && orderModel.assignedOrders != null) {
        _orders = orderModel.assignedOrders!;
      } else {
        _error = 'Failed to fetch orders';
      }
    } catch (e) {
      _error = 'Something went wrong: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
