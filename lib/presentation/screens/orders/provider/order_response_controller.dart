// agent_order_response_controller.dart
import 'package:demo/presentation/screens/orders/model/order_response_model.dart';
import 'package:demo/presentation/screens/orders/service/order_response_service.dart';
import 'package:flutter/material.dart';

class AgentOrderResponseController extends ChangeNotifier {
  final AgentOrderResponseService _service = AgentOrderResponseService();

  bool isLoading = false;
  String? error;
  OrderResponseModel? response;

  Future<void> respond(String orderId, String action) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      response = await _service.respondToOrder(
        orderId: orderId,
        action: action,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
