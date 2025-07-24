import 'package:demo/services/api_services.dart';
import 'package:flutter/material.dart';

class AgentHomeProvider with ChangeNotifier {
  final APIServices apiServices = APIServices();

  int cancelledOrders = 0;
  int totalOrders = 0;
  List<dynamic> incentiveGraph = [];

  Future<void> loadAgentHomeData() async {
    try {
      final data = await apiServices.fetchAgentHomeData();
      cancelledOrders = data['cancelledOrders'];
      totalOrders = data['totalOrders'];
      incentiveGraph = data['incentiveGraph'];
      notifyListeners();
    } catch (error) {
      print("Error loading agent home data: $error");
    }
  }
}
