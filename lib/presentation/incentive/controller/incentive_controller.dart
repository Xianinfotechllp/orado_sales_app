// incentive_controller.dart
import 'package:demo/presentation/incentive/model/incentive_model.dart';
import 'package:flutter/material.dart';
import '../service/incentive_service.dart';

class IncentiveController extends ChangeNotifier {
  final IncentiveService _service = IncentiveService();

  IncentiveSummaryModel? incentiveData;
  bool isLoading = false;

  Future<void> loadIncentive(String type) async {
    isLoading = true;
    notifyListeners();

    final result = await _service.fetchIncentiveSummary(type.toLowerCase());
    incentiveData = result;

    isLoading = false;
    notifyListeners();
  }
}
