import 'package:flutter/material.dart';
import 'package:demo/presentation/earnings/model/earnings_model.dart';
import 'package:demo/presentation/earnings/service/earnings_service.dart';

class EarningsController extends ChangeNotifier {
  final EarningsService _service = EarningsService();
  EarningsSummaryModel? summaryModel;
  bool isLoading = false;
  String? errorMessage;
  String selectedPeriod = 'daily'; // Default to daily
  DateTimeRange? customDateRange;

  // Mapping between UI period names and API period values
  final Map<String, String> periodMapping = {
    'Today': 'daily',
    'This Week': 'weekly',
    'This Month': 'monthly',
    'Custom': 'custom',
  };

  Future<void> loadSummary(String uiPeriod) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      if (uiPeriod == 'Custom') {
        if (customDateRange != null) {
          await _loadCustomDateRange(customDateRange!);
        }
        return;
      }

      // Convert UI period to API period value
      final apiPeriod = periodMapping[uiPeriod] ?? 'daily';
      summaryModel = await _service.fetchEarningsSummary(apiPeriod);
      selectedPeriod = uiPeriod;
    } catch (e) {
      errorMessage = 'Failed to load earnings data: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCustomDateRange(DateTimeRange dateRange) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      summaryModel = await _service.fetchCustomDateRangeSummary(
        dateRange.start,
        dateRange.end,
      );
      selectedPeriod = 'Custom';
      customDateRange = dateRange;
    } catch (e) {
      errorMessage = 'Failed to load custom date range data: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          customDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
    );

    if (picked != null) {
      await _loadCustomDateRange(picked);
    }
  }

  String getFormattedPeriod() {
    if (summaryModel == null) return 'Loading...';

    if (selectedPeriod == 'Custom' && customDateRange != null) {
      final start = customDateRange!.start;
      final end = customDateRange!.end;
      return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
    }

    final now = DateTime.now();
    switch (summaryModel!.period) {
      case 'daily':
        return '${now.day}/${now.month}/${now.year}';
      case 'weekly':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${startOfWeek.day}/${startOfWeek.month} - ${endOfWeek.day}/${endOfWeek.month} ${endOfWeek.year}';
      case 'monthly':
        return '${now.month}/${now.year}';
      default:
        return 'Custom Period';
    }
  }
}
