import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:demo/presentation/user/model/user_model.dart';
import 'package:demo/presentation/user/service/user_service.dart';

class AgentProfileController with ChangeNotifier {
  final AgentProfileService _service = AgentProfileService(
    baseUrl: 'https://orado-backend.onrender.com',
  );

  AgentProfile? _profile;
  bool _isLoading = false;
  String? _error;

  AgentProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile() async {
    log('Fetching agent ID from SharedPreferences...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final agentId = prefs.getString('agentId');

      if (agentId == null || agentId.isEmpty) {
        throw Exception('Agent ID not found in SharedPreferences.');
      }

      log('Loading profile for agent ID: $agentId');
      _profile = await _service.fetchAgentProfile(agentId);
      log('Profile loaded successfully');
      _error = null;
    } catch (e) {
      log('Error loading agent profile: $e');
      _profile = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
