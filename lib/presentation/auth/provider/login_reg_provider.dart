import 'dart:io';
import 'package:demo/presentation/auth/model/reg_model.dart';
import 'package:demo/presentation/auth/service/login_reg_service.dart';
import 'package:flutter/material.dart';

class AgentProvider extends ChangeNotifier {
  final AgentService _agentService = AgentService();

  Agent? _agent;
  Agent? get agent => _agent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> registerAgent({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password,
    required File license,
    required File rcBook,
    required File pollutionCertificate,
    required File profilePicture,
    required File insurance,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _agentService.registerAgent(
        name: name,
        email: email,
        phone: phone,
        password: password,
        license: license,
        rcBook: rcBook,
        pollutionCertificate: pollutionCertificate,
        profilePicture: profilePicture,
        insurance: insurance,
      );
      _agent = result;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration submitted. Awaiting approval.")),
      );
    } catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $_error")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
