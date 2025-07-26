// controllers/leave_controller.dart

import 'package:demo/presentation/leave/model/leave_model.dart';
import 'package:demo/presentation/leave/service/leave_service.dart';
import 'package:flutter/material.dart';

class LeaveController extends ChangeNotifier {
  final LeaveService _leaveService = LeaveService();

  // State variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LeaveStatusResponse? _leaveStatus;
  LeaveStatusResponse? get leaveStatus => _leaveStatus;

  // Clear any existing error
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get leave status with proper state management
  Future<void> getLeaveStatus() async {
    _clearError();
    _setLoading(true);

    try {
      final status = await _leaveService.getLeaveStatus();
      _leaveStatus = status;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Apply for leave with proper state management
  Future<String> applyForLeave({
    required String startDate,
    required String endDate,
    required String leaveType,
    required String reason,
  }) async {
    _clearError();
    _setLoading(true);

    try {
      final leave = LeaveApplication(
        leaveStartDate: startDate,
        leaveEndDate: endDate,
        leaveType: leaveType,
        reason: reason,
      );

      final message = await _leaveService.applyForLeave(leave);

      // Refresh leave status after successful application
      await getLeaveStatus();

      return message;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh leave status
  Future<void> refreshLeaveStatus() async {
    await getLeaveStatus();
  }
}
