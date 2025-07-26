import 'package:demo/presentation/letters/service/letter_service.dart';
import 'package:flutter/material.dart';
import '../model/termination_model.dart';
import '../model/warning_model.dart';

class LetterController with ChangeNotifier {
  final LetterService _agentService = LetterService();

  TerminationModel? termination;
  List<WarningModel> warnings = [];

  bool isLoading = false;

  Future<void> loadAgentInfo() async {
    isLoading = true;
    notifyListeners();

    termination = await _agentService.fetchTerminationInfo();
    warnings = await _agentService.fetchWarnings();

    isLoading = false;
    notifyListeners();
  }
}
