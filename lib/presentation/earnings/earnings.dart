import 'package:demo/presentation/earnings/model/earnings_model.dart';
import 'package:demo/presentation/earnings/provider/earnings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EarningsDashboard extends StatefulWidget {
  @override
  _EarningsDashboardState createState() => _EarningsDashboardState();
}

class _EarningsDashboardState extends State<EarningsDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<EarningsController>(
        context,
        listen: false,
      );
      controller.loadSummary(controller.selectedPeriod);
    });
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Play animations only if there's content to show initially,
    // otherwise the loading indicator will cover it.
    // The animations will be re-triggered when content loads after the loading state.
    // For now, we'll let the Consumer handle the visibility based on isLoading.
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'en_IN',
    );

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Consumer<EarningsController>(
          builder: (context, controller, child) {
            // Use AnimatedSwitcher for a smooth transition between loading and content
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  controller.isLoading
                      ? Center(
                        key: ValueKey(
                          'loading',
                        ), // Key is crucial for AnimatedSwitcher
                        child: CircularProgressIndicator(),
                      )
                      : _buildContent(
                        controller,
                        currencyFormat,
                        context,
                      ), // Pass context
            );
          },
        ),
      ),
    );
  }

  // Extracted content building into a separate method
  Widget _buildContent(
    EarningsController controller,
    NumberFormat currencyFormat,
    BuildContext context,
  ) {
    if (controller.errorMessage != null) {
      return Center(
        key: ValueKey('error'), // Key for AnimatedSwitcher
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            controller.errorMessage!,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (controller.summaryModel == null) {
      return Center(
        key: ValueKey('no_data'), // Key for AnimatedSwitcher
        child: Text('No earnings data available'),
      );
    }

    // Trigger animations only when content is ready
    _fadeController.forward(from: 0.0);
    _slideController.forward(from: 0.0);

    final summary = controller.summaryModel!;
    final stats = summary.deliveryStats;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          key: ValueKey('main_content'), // Key for AnimatedSwitcher
          child: Column(
            children: [
              _buildHeader(),
              _buildPeriodFilter(controller, context),
              _buildSummaryCard(controller, currencyFormat),
              _buildEarningsBreakdown(summary, currencyFormat),
              _buildTasksList(stats),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: Colors.black, size: 28),
          SizedBox(width: 12),
          Text(
            'My Earnings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter(
    EarningsController controller,
    BuildContext context,
  ) {
    final periods = ['Today', 'This Week', 'This Month', 'Custom'];

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        // box boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.08),
        //     blurRadius: 10,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Row(
            children:
                periods.map((period) {
                  bool isSelected = controller.selectedPeriod == period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.isLoading)
                          return; // Prevent multiple taps while loading

                        if (period == 'Custom') {
                          await controller.selectCustomDateRange(context);
                        } else {
                          await controller.loadSummary(period);
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient:
                              isSelected
                                  ? LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B35),
                                      Color(0xFFFF8E53),
                                    ],
                                  )
                                  : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          period,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xFF666666),
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          if (controller.selectedPeriod == 'Custom' &&
              controller.customDateRange != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected: ${_formatDateRange(controller.customDateRange!)}',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTimeRange range) {
    final start = range.start;
    final end = range.end;
    return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
  }

  Widget _buildSummaryCard(
    EarningsController controller,
    NumberFormat currencyFormat,
  ) {
    final summary = controller.summaryModel?.summary;
    final stats = controller.summaryModel?.deliveryStats;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53E3E), Color(0xFFFF6B35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Period: ${controller.getFormattedPeriod()}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total',
                  summary != null
                      ? currencyFormat.format(summary.totalEarnings)
                      : '₹0',
                  Icons.account_balance_wallet,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Tasks',
                  stats != null
                      ? '${stats.completedDeliveries}/${stats.totalDeliveries}'
                      : '0/0',
                  Icons.assignment,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Hours',
                  '--', // Replace with actual hours if available
                  Icons.access_time,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsBreakdown(
    EarningsSummaryModel summary,
    NumberFormat currencyFormat,
  ) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Earnings Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildBreakdownItem(
            '💰',
            'Total Earnings',
            currencyFormat.format(summary.summary.totalEarnings),
            Color(0xFF4CAF50),
          ),
          _buildBreakdownItem(
            '🚀',
            'Incentives',
            currencyFormat.format(summary.summary.incentives),
            Color(0xFF2196F3),
          ),
          _buildBreakdownItem(
            '🔥',
            'Surge Bonus',
            currencyFormat.format(summary.summary.surgeBonus),
            Color(0xFFFF9800),
          ),
          _buildBreakdownItem(
            '🎁',
            'Tips',
            currencyFormat.format(summary.summary.tips),
            Color(0xFF9C27B0),
          ),
          _buildBreakdownItem(
            '📦',
            'Base Earnings',
            currencyFormat.format(summary.summary.baseEarnings),
            Color(0xFF607D8B),
          ),
          if (summary.summary.penalties > 0)
            _buildBreakdownItem(
              '⚠️',
              'Penalties',
              '-${currencyFormat.format(summary.summary.penalties)}',
              Color(0xFFF44336),
            ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    String emoji,
    String label,
    String amount,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(DeliveryStats stats) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.list_alt, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'Delivery Stats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatItem(
                  'Total Deliveries Assigned',
                  '${stats.totalDeliveries}',
                  Icons.local_shipping,
                  Color(0xFFFF6B35),
                ),
                SizedBox(height: 12),
                _buildStatItem(
                  'Completed Deliveries',
                  '${stats.completedDeliveries}',
                  Icons.check_circle,
                  Color(0xFF4CAF50),
                ),
                SizedBox(height: 12),
                _buildStatItem(
                  'Completion Rate',
                  '${stats.totalDeliveries > 0 ? ((stats.completedDeliveries / stats.totalDeliveries) * 100).toStringAsFixed(1) : 0}%',
                  Icons.trending_up,
                  Color(0xFF2196F3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
