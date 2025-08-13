import 'package:demo/presentation/auth/model/selfi_status_model.dart';
import 'package:demo/presentation/auth/service/selfi_status_service.dart';
import 'package:flutter/material.dart';

class SelfieStatusController extends ChangeNotifier {
  final SelfieStatusService _service = SelfieStatusService();

  bool isLoading = false;
  String? error;
  SelfieStatusModel? statusModel;

  Future<void> loadSelfieStatus() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      statusModel = await _service.fetchSelfieStatus();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
