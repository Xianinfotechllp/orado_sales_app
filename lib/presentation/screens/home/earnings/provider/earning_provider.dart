import 'package:demo/presentation/screens/home/earnings/model/earning_model.dart';
import 'package:demo/services/api_services.dart';
import 'package:flutter/material.dart';

class EarningsProvider with ChangeNotifier {
  final APIServices apiServices = APIServices();
  List<EarningModel> earningsList = [];
  bool isLoading = false;

  Future<void> fetchAgentEarnings(String date) async {
    print('hi');
    isLoading = true;
    notifyListeners();
    try {
      final data = await apiServices.agentViewEarnings(date);
      earningsList =
          (data['detail'] as List)
              .map((json) => EarningModel.fromJson(json))
              .toList();
    } catch (error) {
      print(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
