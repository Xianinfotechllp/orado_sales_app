import 'dart:developer';
import 'package:demo/services/agetn_available_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentAvailableController extends ChangeNotifier {
  bool isAvailable = false;
  final AgentAvailabilityService _service = AgentAvailabilityService();

  String? _agentId;
  String? get agentId => _agentId;

  AgentAvailableController() {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _agentId = prefs.getString('agentId');
      isAvailable = prefs.getBool('isAvailable') ?? false;
      log('🔑 Loaded agentId: $_agentId');
      log('🔄 Loaded availability state: $isAvailable');
      notifyListeners();
    } catch (e, stackTrace) {
      log('❌ Failed to load initial state', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> persistAvailability(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAvailable', value);
  }

  Future<void> toggleAvailability() async {
    if (_agentId == null) {
      log('⚠️ agentId is null. Aborting toggle.');
      return;
    }

    final newState = !isAvailable;
    log(
      '🔁 Changing availability to: ${newState ? 'AVAILABLE' : 'UNAVAILABLE'}',
    );

    try {
      await Geolocator.requestPermission();
      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      log(
        '📍 Current Position - Lat: ${pos.latitude}, Lng: ${pos.longitude}, Accuracy: ${pos.accuracy}',
      );

      final success = await _service.updateAvailability(
        agentId: _agentId!,
        status: newState ? 'AVAILABLE' : 'UNAVAILABLE',
        lat: pos.latitude,
        lng: pos.longitude,
        accuracy: pos.accuracy,
      );

      if (success) {
        isAvailable = newState;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAvailable', isAvailable);

        log(
          '✅ Updated availability to $isAvailable and saved to SharedPreferences',
        );
      } else {
        log('❌ Failed to update availability on server. State not changed.');
      }
    } catch (e, stackTrace) {
      log(
        '❌ Error during toggleAvailability',
        error: e,
        stackTrace: stackTrace,
      );
    }

    notifyListeners();
  }
}
