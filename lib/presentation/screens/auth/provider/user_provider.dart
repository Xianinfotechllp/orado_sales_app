import 'dart:developer';
import 'package:demo/presentation/profile_review_screen/profile_review_screen.dart';
import 'package:demo/presentation/screens/auth/view/login.dart';
import 'package:demo/presentation/screens/main_screen.dart';
import 'package:demo/services/device_info_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo/presentation/screens/auth/service/login_reg_service.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class AuthController extends ChangeNotifier {
  final AgentService _agentService = AgentService();
  BuildContext? _context;

  String _message = '';
  String? _token;
  String? _agentId;
  bool _isLoading = false;

  String get message => _message;
  String? get token => _token;
  String? get agentId => _agentId;
  bool get isLoading => _isLoading;

  void setContext(BuildContext context) {
    _context = context;
  }

  AuthController() {
    log('AuthController initialized. Loading stored data...');
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('userToken');
    _agentId = prefs.getString('agentId');
    log(
      'Stored data loaded: Token=${_token != null ? "exists" : "null"}, Agent ID=${_agentId ?? "null"}',
    );
    notifyListeners();
  }

  Future<void> _saveLoginData(String token, String agentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
    await prefs.setString('agentId', agentId);
    _token = token;
    _agentId = agentId;
    log('Login data saved.');
    notifyListeners();
  }

  Future<void> clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _agentId = null;
    _message = 'Stored data cleared!';
    log('All SharedPreferences cleared.');
    notifyListeners();
  }

  Future<void> logout() async {
    log('Logout triggered. Clearing data...');
    await clearStoredData();
    _message = 'You have been logged out.';
    if (_context != null && _context!.mounted) {
      GoRouter.of(_context!).go(LoginScreen.route);
    }
  }

  Future<void> login(String identifier, String password) async {
    _isLoading = true;
    _message = '';
    log('Login started for $identifier');
    notifyListeners();

    try {
      final response = await _agentService.login(identifier, password);
      await _saveLoginData(response.token, response.agent.id);
      _message = response.message;
      log('Login successful.');

      // ✅ Send device info to backend
      await DeviceInfoService().sendDeviceInfo(response.agent.id);

      // ✅ Navigate after successful login
      if (_context != null && _context!.mounted) {
        await Future.delayed(const Duration(milliseconds: 100));

        if (response.statusCode == 200) {
          log('Navigating to MainScreen');
          GoRouter.of(_context!).go(MainScreen.route);
        } else if (response.statusCode == 403) {
          log('Navigating to ProfileReviewScreen');
          GoRouter.of(_context!).go(ProfileReviewScreen.route);
        }
      }
    } catch (e) {
      _message = e.toString().replaceFirst('Exception: ', '');
      _token = null;
      _agentId = null;
      log('Login failed: $_message');
      await clearStoredData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
