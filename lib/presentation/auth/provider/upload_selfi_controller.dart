// controllers/selfie_upload_controller.dart
import 'dart:io';
import 'package:demo/presentation/auth/model/upload_selfi_model.dart';
import 'package:demo/presentation/auth/service/upload_selfi_service.dart';
import 'package:flutter/material.dart';

class SelfieUploadController extends ChangeNotifier {
  final SelfieUploadService _service = SelfieUploadService();

  bool isLoading = false;
  String? error;
  UploadSelfieResponse? uploadResponse;

  Future<void> uploadSelfie(File file) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _service.uploadSelfie(file);
      uploadResponse = response;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
