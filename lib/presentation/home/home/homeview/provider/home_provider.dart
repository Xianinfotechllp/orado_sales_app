import 'dart:developer';
import 'package:demo/presentation/home/home/model/home_model.dart';
import 'package:demo/presentation/home/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:demo/services/api_services.dart'; // Create this model as previously shared

class AgentHomeProvider with ChangeNotifier {
  final AgentHomeService apiServices = AgentHomeService();

  bool isLoading = false;
  AgentHomeModel? homeData;

  int cancelledOrders = 0;
  int totalOrders = 0;

  List<Map<String, dynamic>> incentiveGraph = [
    {"period": "Daily", "value": 1200},
    {"period": "Weekly", "value": 2200},
    {"period": "Monthly", "value": 3850},
  ];

  Future<void> loadAgentHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      homeData = await apiServices.fetchAgentHomeData();
      // If your API also returns cancelledOrders and totalOrders separately,
      // extract them here, otherwise use logic to compute them if needed.

      isLoading = false;
      notifyListeners();
    } catch (error) {
      log("Error loading agent home data: $error");
      isLoading = false;
      notifyListeners();
    }
  }
}
