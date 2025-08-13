// agent_home_provider.dart

import 'package:demo/presentation/home/home/model/home_model.dart';
import 'package:demo/presentation/home/home/service/home_service.dart';
import 'package:flutter/material.dart';

class AgentHomeProvider extends ChangeNotifier {
  final AgentHomeService _service = AgentHomeService();

  AgentHomeModel? _homeData;
  AgentHomeModel? get homeData => _homeData;

  int cancelledOrders = 2; // Placeholder
  int totalOrders = 10; // Placeholder
  List<Map<String, dynamic>> incentiveGraph = [
    {"period": "Daily", "value": 1200},
    {"period": "Weekly", "value": 2200},
    {"period": "Monthly", "value": 3850},
  ];

  bool isLoading = false;

  Future<void> loadAgentHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      _homeData = await _service.fetchAgentHomeData();
    } catch (e) {
      debugPrint("Error loading home data: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
